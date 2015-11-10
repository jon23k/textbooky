//
//  LoginViewController.m
//  Textbooky
//
//  Created by Tayler How on 11/5/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MainMenuViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) NSDictionary *currentUser;

@end

@implementation LoginViewController

#pragma mark - IBActions
- (IBAction)pressedSignUp:(id)sender {
    [self performSegueWithIdentifier:@"SignUpSegue" sender:self];
}

- (IBAction)pressedSignIn:(id)sender {
    //verify usersname/password
    NSString *usersUrl = @"http://textbooky.csse.rose-hulman.edu:8000/users/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:usersUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Users JSON: %@", responseObject);
        
        bool successfulSignIn = NO;
        
        for (int i = 0; i <= [responseObject count] ; i++) {
            if (successfulSignIn) break;
            if (i == [responseObject count]) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Invalid Login Credentials"
                                                                               message:@"Please enter a valid username and password combination"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
                break;
            }
            
            NSDictionary *dict = responseObject[i];
            
            if ([self.usernameTextField.text isEqualToString: [dict objectForKey:@"username"]] &&
                [self.passwordTextField.text isEqualToString: [dict objectForKey:@"password"]]) {
                successfulSignIn = YES;
                self.currentUser = dict;
                [self performSegueWithIdentifier:@"SignInSegue" sender:self];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - UITableViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.secureTextEntry = YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"SignInSegue"]) {
        //pass in valid user account info
        [((MainMenuViewController *) [segue destinationViewController]) setCurrentUser:self.currentUser];
    }
}


@end
