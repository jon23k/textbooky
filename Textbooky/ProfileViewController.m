//
//  ProfileViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/14/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextView *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation ProfileViewController

#pragma mark - IBActions

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameLabel.text = [NSString stringWithFormat:@"%@", [[self currentUser] objectForKey:@"username"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[self currentUser] objectForKey:@"firstname"], [[self currentUser] objectForKey:@"lastname"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@", [[self currentUser] objectForKey:@"phonenum"]];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
