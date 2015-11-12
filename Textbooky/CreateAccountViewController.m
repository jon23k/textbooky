//
//  CreateAccountViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/30/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "CreateAccountViewController.h"
#import "AFNetworking.h"
#import "MainMenuViewController.h"


@interface CreateAccountViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (nonatomic, strong) NSDictionary *createdUser;

@end

@implementation CreateAccountViewController

# pragma mark IBActions

- (IBAction)pressedSignUp:(id)sender {
    if ([self.firstNameTextField.text isEqualToString:@""] ||
        [self.lastNameTextField.text isEqualToString:@""] ||
        [self.emailTextField.text isEqualToString:@""] ||
        [self.phoneNumberTextField.text isEqualToString:@""] ||
        [self.usernameTextField.text isEqualToString:@""] ||
        [self.passwordTextField.text isEqualToString:@""] ||
        [self.confirmPasswordTextField.text isEqualToString:@""]) {
            [self displayAlertWithTitle:@"Invalid Input" AndMessage:@"All fields are required"];
            return;
    }
    
    if (self.passwordTextField.text != self.confirmPasswordTextField.text) {
        [self displayAlertWithTitle:@"Invalid Input" AndMessage:@"Passwords do not match"];
        return;
    }
    
    //verify username available
    NSString *usersUrl = @"http://textbooky.csse.rose-hulman.edu:8000/users/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:usersUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (int i = 0; i <= [responseObject count] ; i++) {
            if (i == [responseObject count]) {
                [self postToUserAPI];
                return;
            }
            
            NSDictionary *dict = responseObject[i];
            
            if ([self.usernameTextField.text isEqualToString: [dict objectForKey:@"username"]]) {
                [self displayAlertWithTitle:@"Invalid Input" AndMessage:@"Username is unavailable"];
                return;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UIViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.secureTextEntry = YES;
    
    self.confirmPasswordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.confirmPasswordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.confirmPasswordTextField.secureTextEntry = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CreateAccountSegue"]) {
        //pass in valid user account info
        self.firstNameTextField.text = @"";
        self.lastNameTextField.text = @"";
        self.emailTextField.text = @"";
        self.phoneNumberTextField.text = @"";
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        self.confirmPasswordTextField.text = @"";
        [((MainMenuViewController *) [segue destinationViewController]) setCurrentUser:self.createdUser];
    }}

# pragma mark - private

- (void)postToUserAPI {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://textbooky.csse.rose-hulman.edu:8000/users/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/JSON" forHTTPHeaderField:@"Content-type"];
    
    NSArray *objects = @[ self.usernameTextField.text, self.passwordTextField.text, self.phoneNumberTextField.text, self.firstNameTextField.text, self.lastNameTextField.text, @"not applicable", @"not applicable", @0 ];
    NSArray *keys = @[ @"username", @"password", @"phonenum", @"firstname", @"lastname", @"photodir", @"location", @"transactioncount" ];
    
    NSDictionary *dataToPost = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataToPost options:0 error:&error];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *urlResponse, NSData *responseData, NSError *requestError) {
                               // Check for Errors
                               if (requestError || !responseData) {
                                   // jump back to the main thread to update the UI
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"Something went wrong...");
                                   });
                               } else {
                                   // jump back to the main thread to update the UI
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"All going well...");
                                       [self setUserWithUsername:self.usernameTextField.text];
                                   });
                               }
                           }
     ];
}

-(void)setUserWithUsername:(NSString *)username {
    NSString *usersUrl = @"http://textbooky.csse.rose-hulman.edu:8000/users/";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:usersUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        for (int i = 0; i <= [responseObject count] ; i++) {
            if (i == [responseObject count]) {
                NSLog(@"No user found...");
                return;
            }
            
            NSDictionary *dict = responseObject[i];
            
            if ([username isEqualToString: [dict objectForKey:@"username"]]) {
                self.createdUser = dict;
                [self performSegueWithIdentifier:@"CreateAccountSegue" sender:self];
                return;
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)displayAlertWithTitle:(NSString *)title AndMessage:(NSString *)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)dismissKeyboard {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

@end
