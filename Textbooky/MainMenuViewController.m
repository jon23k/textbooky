//
//  ViewController.m
//  Textbooky
//
//  Created by Jony Kurian on 9/30/15.
//  Copyright (c) 2015 Jony Kurian. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ProfileViewController.h"
#import "SellABookViewController.h"

@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation MainMenuViewController

#pragma mark IBActions

- (IBAction)pressedSignOut:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)pressedSellABook:(id)sender {
    [self performSegueWithIdentifier:@"SellBookSegue" sender:self];
}

- (IBAction)pressedProfile:(id)sender {
    [self performSegueWithIdentifier:@"ViewYourProfileSegue" sender:self];
}

#pragma mark UIViewController subclass

- (void)viewDidLoad {
    [super viewDidLoad];
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome to Textbooky, %@!", [[self currentUser] objectForKey:@"firstname"]];
}


#pragma mark Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ViewYourProfileSegue"]) {
        //pass in valid user account info
        [((ProfileViewController *)[((UINavigationController *) [segue destinationViewController]) viewControllers][0]) setCurrentUser:self.currentUser];
    }
    
    if ([[segue identifier] isEqualToString:@"SellBookSegue"]) {
        //pass in valid user account info
        [((SellABookViewController *)[((UINavigationController *) [segue destinationViewController]) viewControllers][0]) setCurrentUser:self.currentUser];
    }
}

@end
