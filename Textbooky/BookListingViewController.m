//
//  BookListingViewController.m
//  Textbooky
//
//  Created by Tayler How on 10/14/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "BookListingViewController.h"
#import "ProfileViewController.h"
#import "AFNetworking.h"

@interface BookListingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ISBNLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *editionLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *negotiableLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *sellerButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (nonatomic, strong) NSDictionary *listingSeller;

@end

@implementation BookListingViewController

#pragma mark - IBActions

- (IBAction)pressedBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedSellerName:(id)sender {
    [self performSegueWithIdentifier:@"SellerProfileSegue" sender:self];
}

#pragma mark - UITableViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //get user info
    NSString *usersUrl = [self.currentListing objectForKey:@"userid"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:usersUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.listingSeller = responseObject;
        [self updateLabels];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SellerProfileSegue"]) {
        [((ProfileViewController *)[((UINavigationController *) [segue destinationViewController]) viewControllers][0]) setCurrentUser:self.listingSeller];
    }
}


#pragma mark - private

-(void)updateLabels {
    self.ISBNLabel.text = [self.currentListing objectForKey:@"isbn"];
    self.titleLabel.text = [self.currentListing objectForKey:@"title"];
    self.editionLabel.text = [self.currentListing objectForKey:@"edition"];
    self.authorLabel.text = [self.currentListing objectForKey:@"author"];
    
    switch ([[self.currentListing objectForKey:@"condition"] integerValue]) {
        case 1:
            self.conditionLabel.text = @"Poor";
            break;
        case 2:
            self.conditionLabel.text = @"Average";
            break;
        case 3:
            self.conditionLabel.text = @"Good";
            break;
        case 4:
            self.conditionLabel.text = @"Excellent";
            break;
        default:
            self.conditionLabel.text = @"Error";
            break;
    }
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%.02f", [[self.currentListing objectForKey:@"price"] doubleValue]];
    
    if ([self.currentListing objectForKey:@"negotiable"]) {
        self.negotiableLabel.text = @"Yes";
    } else {
        self.negotiableLabel.text = @"No";
    }
    
    self.commentsLabel.text = [self.currentListing objectForKey:@"comments"];
    self.expirationDateLabel.text = [self.currentListing objectForKey:@"expirationdate"];
    
    [self.sellerButton setTitle:[NSString stringWithFormat:@"%@ %@", [self.listingSeller objectForKey:@"firstname"], [self.listingSeller objectForKey:@"lastname"]] forState:UIControlStateNormal];
    self.phoneNumberLabel.text = [self.listingSeller objectForKey:@"phonenum"];
}

@end
