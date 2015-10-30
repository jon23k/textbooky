//
//  Annotation.m
//  Textbooky
//
//  Created by Tayler How on 10/29/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import "Annotation.h"

@interface Annotation ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@end

@implementation Annotation

/*
- (id)initWithPlacemark:(CLPlacemark *)placemark andLocation:(MKUserLocation *)location;
{
    if (self == [super init]){
        self.coordinate = location.coordinate;
        self.title = [placemark name];
        self.subtitle = [NSString stringWithFormat:@"%@, %@", [placemark locality], [placemark administrativeArea]];
    }
    return self;
}
*/

- (id)initWithLocation:(CLLocationCoordinate2D)location Title:(NSString *)title andSubtitle:(NSString *)subtitle;
{
    if (self == [super init]){
        self.coordinate = location;
        self.title = title;
        self.subtitle = subtitle;
    }
    return self;
}


@end
