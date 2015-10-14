//
//  ListingObj.h
//  Textbooky
//
//  Created by Tayler How on 10/14/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListingObj : NSObject

@property (readwrite) NSInteger *ListingID;

@property (readwrite) NSString *ISBN;

@property (readwrite) NSInteger *UserID;

@property (readwrite) NSString *Price;

@property (readwrite) NSString *Location;

@property (readwrite) NSInteger *Condition;

@property (readwrite) NSString *Comments;

@property (readwrite) BOOL Negotiable;

@property (readwrite) NSDate *PostDate;

@property (readwrite) NSDate *ExpirationDate;

@end
