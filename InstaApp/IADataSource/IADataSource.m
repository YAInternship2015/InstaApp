//
//  IADataSource.m
//  InstaApp
//
//  Created by Maks on 10/12/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IADataSource.h"
#import "IAModelItem.h"

#import <MagicalRecord/MagicalRecord.h>

@interface IADataSource()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


@implementation IADataSource

- (instancetype)initWithDelegate:(id<IADataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setupFetchedResultsController];
    }
    return self;
}

#pragma mark - DataSource methods

- (void)setupFetchedResultsController {
    self.fetchedResultsController = [IAModelItem MR_fetchAllSortedBy:kModelDateAddedIA ascending:YES withPredicate:nil groupBy:nil delegate:self];
}

- (NSUInteger)countOfModels {
    return [IAModelItem MR_countOfEntities];
}

- (IAModelItem *)modelAtIndex:(NSInteger)index {
    return self.fetchedResultsController.fetchedObjects[index];    
}

- (void)removeModelAtIndex:(NSIndexPath *)indexPath {
    IAModelItem *modelToRemove = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [modelToRemove MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)insertModelWithCaption:(NSString *)caption imageURL:(NSString *)imageURL modelID:(NSString *)modelID {
    
    IAModelItem *objectForInsert = [IAModelItem MR_createEntity];
    
    [objectForInsert setValue:caption forKey:kModelDecriptionIA];
    [objectForInsert setValue:imageURL forKey:kModelImgIA];
    [objectForInsert setValue:modelID forKey:kModelIdIA];
    [objectForInsert setValue:[NSDate date] forKey:kModelDateAddedIA];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (IAModelItem *)modelWithID:(NSString *)idString {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"modelID == %@", idString];
    [request setEntity:[IAModelItem MR_entityDescription]];
    [request setPredicate:predicate];
    NSArray *results = [[NSManagedObjectContext MR_defaultContext] executeFetchRequest:request error:&error];

    return [results firstObject];
    }


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self setupFetchedResultsController];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ([self.delegate respondsToSelector:@selector(contentWasChangedAtIndexPath:forChangeType:newIndexPath:)]) {
        [self.delegate contentWasChangedAtIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
    
}


@end
