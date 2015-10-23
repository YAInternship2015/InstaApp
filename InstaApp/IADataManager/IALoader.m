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
    static IALoader *loader;
    if (loader == nil) {
    
    loader = [[IALoader alloc] init];
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

- (void)getTokenWithRecievedURl:(NSURL *)url{
    [IALogin loginWithURL:url];
}

- (void)needMore{
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"token"]) {
        [IAApiClient getDataNextURL:self.nextUrl completeBlock:^(NSDictionary *answer) {
            [self parseDataDictionary:answer];
        }failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)parseDataWithNotification:(NSNotification *)notification{
    NSDictionary * dictFromNotification = [NSDictionary dictionary];
    dictFromNotification = notification.object;
    [self parseDataDictionary:dictFromNotification];
}

- (void)parseDataDictionary:(NSDictionary *)dataDict
{
    NSArray *tempArray = [dataDict objectForKey:@"data"];
    self.dataArray = tempArray;
    self.nextUrl = [[dataDict objectForKey:@"pagination"] objectForKey:@"next_url"];
    for (int i = 0; i < [self.dataArray count]; i++) {
        if (!modelIDObject(i, self.dataArray, self.dataSource)){
            [self.dataSource insertModelWithCaption:captionObject(i, self.dataArray) imageURL:imageSRObject(i, self.dataArray) modelID:idStringObject(i, self.dataArray)];
        }
    }
}


@end
