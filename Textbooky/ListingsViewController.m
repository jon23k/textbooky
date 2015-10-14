//
//  ListingsViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/13/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "ListingsViewController.h"

@interface ListingsViewController ()

@end

@implementation ListingsViewController

#pragma mark - IBActions

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
