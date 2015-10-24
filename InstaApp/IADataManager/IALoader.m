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
        [[NSNotificationCenter defaultCenter] addObserver:loader selector:@selector(needMore)
                                                     name:NotificationNewDataNeedToDownload object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:loader selector:@selector(parseDataWithNotification:)
                                                     name:NotificationTokenWasAcquiredReadyToParce object:nil];
    });
    
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
        __weak typeof(self) weakSelf = self;
        [IAApiClient loadDataNextURL:self.nextUrl completeBlock:^(NSDictionary *response) {
        [weakSelf parseDataDictionary:response];
        }failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)parseDataWithNotification:(NSNotification *)notification {
    [self parseDataDictionary:notification.object];
}

- (void)parseDataDictionary:(NSDictionary *)dataDict {
    NSArray *tempArray = [dataDict objectForKey:@"data"];
    self.dataArray = tempArray;
    self.nextUrl = [[dataDict objectForKey:@"pagination"] objectForKey:@"next_url"];
    for (int i = 0; i < [self.dataArray count]; i++) {
        
        if (![[self.dataSource modelWithID:[self.dataArray[i] objectForKey:@"id"]] valueForKey:@"modelID"]) {
            [self.dataSource insertModelWithCaption:[[self.dataArray[i] objectForKey:@"caption"] objectForKey:@"text"] imageURL:[[[self.dataArray[i] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"] modelID:[self.dataArray[i] objectForKey:@"id"]];
        }
    }
}


@end
