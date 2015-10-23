//
//  ViewController.m
//  InstaApp
//
//  Created by Maks on 10/12/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IAMainViewController.h"
#import "IATableViewController.h"
#import "IACollectionViewController.h"
#import "IAContainerViewController.h"
#import <AFNetworking.h>
#import "IADataSource.h"
#import "IALogin.h"

@interface IAMainViewController ()<IADataSourceDelegate>

@property (nonatomic, strong)IAContainerViewController *containerViewController;
@property (nonatomic, strong)IADataSource *dataSource;

@end


static NSString *const EmbedContainer = @"EmbedContainer";


@implementation IAMainViewController

#pragma mark - UIViewController methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EmbedContainer]) {
        self.containerViewController = segue.destinationViewController;
    }
}

#pragma mark - IBActions

- (IBAction)changeView:(id)sender {
    [self.containerViewController swapViewControllers:self.navigationItem];
}

- (IBAction)loginAction:(id)sender{
    [IALogin startLogin];
}

@end


