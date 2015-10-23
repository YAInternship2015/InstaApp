//
//  IATableViewController.m
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IATableViewController.h"
#import "IATableViewCell.h"
#import "IADataSource.h"

NSInteger const kValueToUploadTable = 3;

@interface IATableViewController()<UITableViewDataSource, UITableViewDelegate, IADataSourceDelegate>

@property (nonatomic, strong)IADataSource *dataSource;

@end

@implementation IATableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[IADataSource alloc]initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    self.dataSource.delegate = self;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource countOfModels];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID forIndexPath:indexPath];
    [cell configWithModel:[self.dataSource modelAtIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [self.dataSource removeModelAtIndex:indexPath];
        [tableView endUpdates];
    }
}


#pragma mark - IADataSourceDelegate

- (void)contentWasChangedAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    [self.tableView beginUpdates];
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView reloadData];
    }
    
    [self.tableView endUpdates];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (([self.dataSource countOfModels] - indexPath.row) == kValueToUploadTable) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNewDataNeedToDownload object:nil];
    }
}
- (CGFloat)estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
@end
