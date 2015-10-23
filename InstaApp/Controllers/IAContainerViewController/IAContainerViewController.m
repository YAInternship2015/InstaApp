//
//  IAContainerViewController.m
//  InstaApp
//
//  Created by Maks on 10/18/15.
//  Copyright © 2015 Maks. All rights reserved.
//

#import "IAContainerViewController.h"
#import "IATableViewController.h"
#import "IACollectionViewController.h"

@interface IAContainerViewController ()

@property (nonatomic, strong) IATableViewController *tableController;
@property (nonatomic, strong) IACollectionViewController *collectionController;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, assign) BOOL isChangeViewController;

@end

static CGFloat const AnimeDuration = 1.3f;

@implementation IAContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChangeViewController = NO;
    
    self.tableController = [self.storyboard instantiateViewControllerWithIdentifier:TableControllerID];
    self.collectionController = [self.storyboard instantiateViewControllerWithIdentifier:CollectionControllerID];
    
    [self presentController:self.tableController];
}

- (void)presentController:(UIViewController *)controller {
    if (self.currentViewController) {
        [self removeCurrentViewController];
    }
    [self addChildViewController:controller];
    controller.view.frame = [self frameForCharacterController];
    [self.view addSubview:controller.view];
    self.currentViewController = controller;
    [controller didMoveToParentViewController:self];
}

- (void)removeCurrentViewController {
    [self.currentViewController willMoveToParentViewController:nil];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
}

- (void)swapCurrentControllerWith:(UIViewController *)controller {
    
    __block CGRect tempRect;
    tempRect.origin.x = 0.f;
    tempRect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) * 2;
    tempRect.size = CGSizeMake(CGRectGetWidth(controller.view.frame), CGRectGetHeight(controller.view.frame));
    
    [self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:controller];
    controller.view.frame = tempRect;
    [self.view addSubview:controller.view];
    
    [UIView animateWithDuration:AnimeDuration animations:^{
        
        controller.view.frame = self.currentViewController.view.frame;
        tempRect.origin.y = -(CGRectGetHeight([UIScreen mainScreen].bounds) * 2);
        self.currentViewController.view.frame = tempRect;
        
    } completion:^(BOOL finished) {
        
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = controller;
        [self.currentViewController didMoveToParentViewController:self];
    }];
}

- (CGRect)frameForCharacterController {
    return self.view.bounds;
}

#pragma mark - Actions

- (void)swapViewControllers:(UINavigationItem *)navigationItem {
    if (!self.isChangeViewController) {
        [self swapCurrentControllerWith:self.collectionController];
        self.isChangeViewController = YES;
    } else {
        [self swapCurrentControllerWith:self.tableController];
        self.isChangeViewController = NO;
    }
}


@end
