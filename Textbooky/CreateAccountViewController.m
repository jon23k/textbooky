//
//  CreateAccountViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/30/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

# pragma mark IBActions

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UIViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
