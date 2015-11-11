//
//  BookListingViewController.h
//  Textbooky
//
//  Created by Tayler How on 10/14/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListingViewController : UIViewController

- (void)setCurrentListing:(NSDictionary*)dict;

@property (nonatomic, strong) NSDictionary *currentListing;

@end
