//
//  ViewController.m
//  Textbooky
//
//  Created by Jony Kurian on 9/30/15.
//  Copyright (c) 2015 Jony Kurian. All rights reserved.
//

#import "MainMenuViewController.h"

@interface MainMenuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome to Textbooky, %@!", [[self currentUser] objectForKey:@"firstname"]];
}

@end
