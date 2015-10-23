//
//  IADataSource.h
//  InstaApp
//
//  Created by Maks on 10/12/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol IADataSourceDelegate;

@interface IADataSource : NSObject

@property (nonatomic, weak) id<IADataSourceDelegate>delegate;

- (void)insertModelWithCaption:(NSString *)caption
                      imageURL:(NSString *)imageURL
                       modelID:(NSString *)modelID;

- (instancetype)initWithDelegate:(id<IADataSourceDelegate>)delegate;
- (NSUInteger)countOfModels;
- (IAModelItem *)modelAtIndex:(NSInteger)index;
- (void)removeModelAtIndex:(NSIndexPath *)indexPath;
- (IAModelItem *)modelWithID:(NSString *)idString;

@end

@protocol IADataSourceDelegate <NSObject>

@optional

- (void)contentWasChangedAtIndexPath:(NSIndexPath *)indexPath
                       forChangeType:(NSFetchedResultsChangeType)type
                        newIndexPath:(NSIndexPath *)newIndexPath;

@end