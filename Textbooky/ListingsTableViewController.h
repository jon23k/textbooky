//
//  ListingsTableViewController.h
//  Textbooky
//
//  Created by Tayler How on 10/13/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingsTableViewController : UITableViewController

- (void)setCurrentUser:(NSDictionary*)dict;

@property (nonatomic, strong) NSDictionary *currentUser;

@end
