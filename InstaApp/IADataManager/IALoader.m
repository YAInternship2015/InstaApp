//
//  IADataManager.m
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IALoader.h"
#import "IADataSource.h"
#import "AFNetworking.h"
#import "IAApiclient.h"
#import "IALoginService.h"

@interface IALoader()<IADataSourceDelegate>

@property (nonatomic, strong) IADataSource *dataSource;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *nextUrl;

@end

@implementation IALoader


+ (id)dataLoader {
    static IALoader *loader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[IALoader alloc] init];
    });
    [[NSNotificationCenter defaultCenter] addObserver:loader selector:@selector(needMore)
                                                 name:NotificationNewDataNeedToDownload object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:loader selector:@selector(parseDataWithNotification:)
                                                 name:NotificationTokenWasAcquiredReadyToParce object:nil];
    return loader;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = [[IADataSource alloc]initWithDelegate:self];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)requestTokenWithRecievedURL:(NSURL *)url{
    [IALoginService loginWithURL:url];
}

- (void)needMore{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"token"]) {
        [IAApiClient loadDataNextURL:self.nextUrl completeBlock:^(NSDictionary *answer) {
#warning здесь нужен weakSelf
            [self parseDataDictionary:answer];
        }failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)parseDataWithNotification:(NSNotification *)notification{
    NSDictionary * dictFromNotification = [NSDictionary dictionary];
    dictFromNotification = notification.object;
#warning зачем нужна переменная dictFromNotification, если можно передать в следующий метод сразу notification.object?
    [self parseDataDictionary:dictFromNotification];
}

- (void)parseDataDictionary:(NSDictionary *)dataDict
{
    NSArray *tempArray = [dataDict objectForKey:@"data"];
    self.dataArray = tempArray;
    self.nextUrl = [[dataDict objectForKey:@"pagination"] objectForKey:@"next_url"];
    for (int i = 0; i < [self.dataArray count]; i++) {
#warning использовать такие дефайны не очень хорошо, потому что код теряет читабельность. Напишите без испольщования define
        if (!modelIDObject(i, self.dataArray, self.dataSource)){
            [self.dataSource insertModelWithCaption:captionObject(i, self.dataArray) imageURL:imageSRObject(i, self.dataArray) modelID:idStringObject(i, self.dataArray)];
        }
    }
}


@end
