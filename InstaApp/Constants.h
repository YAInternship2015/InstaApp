//
//  Constants.h
//  InstaApp
//
//  Created by Maks on 10/15/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Constants_h
#define Constants_h

#pragma mark Data Model Attributes names

static NSString *const kModelIdIA = @"modelID";
static NSString *const kModelDecriptionIA = @"caption";
static NSString *const kModelImgIA = @"imageURL";
static NSString *const kModelDateAddedIA = @"dateAdded";

#pragma mark - Storyboard ID's

static NSString *const TableControllerID = @"IATableViewController";
static NSString *const CollectionControllerID = @"IACollectionViewController";
static NSString *const TableViewCellID = @"customTableCell";
static NSString *const CollectionViewCellID = @"customCollectionViewCell";

#pragma mark - Notifications

static NSString *const NotificationDataFileContentDidChange = @"NotificationDataFileContentDidChange";
static NSString *const NotificationLoginWasAcquired= @"NotificationLoginWasAcquired";
static NSString *const NotificationNewDataNeedToDownload= @"NotificationNewDataNeedToDownload";
static NSString *const NotificationTokenWasAcquiredReadyToParce= @"NotificationTokenWasAcquiredReadyToParce";


#pragma mark - UIImage+OtherPic

static NSString *const kNoImage = @"noPic";

#define  captionObject(i, arr)\
[[arr[i] objectForKey:@"caption"] objectForKey:@"text"]

#define  imageSRObject(i, arr)\
[[[arr[i] objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]

#define  idStringObject(i, arr)\
[arr[i] objectForKey:@"id"]

#define modelIDObject(i, arr, dataSource)\
[[dataSource modelWithID:idStringObject(i, arr)] valueForKey:@"modelID"]

#endif /* Constants_h */
