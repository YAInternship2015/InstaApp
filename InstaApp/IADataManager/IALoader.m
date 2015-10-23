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
#import "IALogin.h"

@interface IALoader()<IADataSourceDelegate>

@property (nonatomic, strong) IADataSource *dataSource;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *nextUrl;

@end

@implementation IALoader


+ (id)dataLoader
{
#warning это - неправильное объявление синглтона, правильное то, где используется dispatch_once. Легко находится в гугле
    static IALoader *loader;
    if (loader == nil) {
    
    loader = [[IALoader alloc] init];
#warning настройка объекта должна происходить в init
    loader.dataSource = [[IADataSource alloc]initWithDelegate:loader];
    [[NSNotificationCenter defaultCenter] addObserver:loader selector:@selector(needMore)
                                                 name:NotificationNewDataNeedToDownload object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:loader selector:@selector(parseDataWithNotification:)
                                                     name:NotificationTokenWasAcquiredReadyToParce object:nil];
    }
    return loader;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#warning вместо get лучше "load" или "request", так как операция длительная, а не мгновенная. И также в имени метода урл пишется либо уже весь капсом, либо camel case'ом
- (void)getTokenWithRecievedURl:(NSURL *)url{
    [IALogin loginWithURL:url];
}

- (void)needMore{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"token"]) {
        [IAApiClient getDataNextURL:self.nextUrl completeBlock:^(NSDictionary *answer) {
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
