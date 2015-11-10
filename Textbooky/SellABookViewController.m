//
//  SellABookViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/14/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "SellABookViewController.h"
#import "AFNetworking.h"
#import "BookListingViewController.h"

@interface SellABookViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ISBNTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *editionTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property (weak, nonatomic) IBOutlet UITextField *conditionTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *negotiableTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *expirationTextField;

@property (nonatomic, strong) NSDictionary *createdPost;

@end

@implementation SellABookViewController

#pragma mark - IBActions

- (IBAction)pressedPostListing:(id)sender {
    
    if ([self.ISBNTextField.text isEqualToString:@""] ||
        [self.titleTextField.text isEqualToString:@""] ||
        [self.editionTextField.text isEqualToString:@""] ||
        [self.authorTextField.text isEqualToString:@""] ||
        [self.conditionTextField.text isEqualToString:@""] ||
        [self.priceTextField.text isEqualToString:@""] ||
        [self.negotiableTextField.text isEqualToString:@""] ||
        [self.commentsTextField.text isEqualToString:@""] ||
        [self.expirationTextField.text isEqualToString:@""]) {
        NSLog(@"All fields required.");
        return;
    }
    
    NSLog(@"calling postToListingsAPI");
    
    [self postToListingsAPI];
    
    //[self performSegueWithIdentifier:@"PostListingSegue" sender:self];
}

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews {

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


# pragma mark - private

- (void)postToListingsAPI {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:@"http://textbooky.csse.rose-hulman.edu:8000/listings/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/JSON" forHTTPHeaderField:@"Content-type"];
    
    NSLog(@"creating dictionary arrays");
    
    NSString *currentUserID = [NSString stringWithFormat:@"http://textbooky.csse.rose-hulman.edu:8000/users/%@/", [self.currentUser objectForKey:@"userid"]];
    
    NSArray *objects = @[ self.ISBNTextField.text, self.titleTextField.text, self.editionTextField.text, self.authorTextField.text, @3, self.priceTextField.text, @false, self.commentsTextField.text, self.expirationTextField.text, @"2015-11-10", @"39.4824939", @"-87.3226889", currentUserID ];
    NSArray *keys = @[ @"isbn", @"title", @"edition", @"author", @"condition", @"price", @"negotiable", @"comments", @"expirationdate", @"postdate", @"latitude", @"longitude", @"userid" ];
    
    NSDictionary *dataToPost = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    self.createdPost = dataToPost;
    
    NSLog(@"Serializing JSON");
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dataToPost options:0 error:&error];
    [request setHTTPBody:postData];
    
    NSLog(@"calling deprecated functions");
    
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
                                       NSLog(@"All going well posting listing...");
                                       [self performSegueWithIdentifier:@"PostListingSegue" sender:self];
                                   });
                               }
                           }
     ];
}

-(void)dismissKeyboard {
    for (UIView * txt in self.view.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
}

@end
