//
//  IACollectionViewController.m
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IACollectionViewController.h"
#import "IACollectionViewCell.h"
#import "IADataSource.h"

int const kValueToUploadCollection = 3;

@interface IACollectionViewController()<IADataSourceDelegate>

@property (nonatomic, strong) IADataSource *dataSource;

@end

@implementation IACollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[IADataSource alloc]initWithDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    self.dataSource.delegate = self;
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource countOfModels];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IACollectionViewCell *cell = (IACollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    [cell configWithModel:[self.dataSource modelAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (([self.dataSource countOfModels] - indexPath.row) == kValueToUploadCollection) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNewDataNeedToDownload object:nil];
    }
    
}

#pragma mark - DDModelsDataSourceDelegate

- (void)contentWasChangedAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } else {
        [self.collectionView reloadData];
    }
}

@end
