//
//  Annotation.h
//  Textbooky
//
//  Created by Tayler How on 10/29/15.
//  Copyright © 2015 Jony Kurian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

- (id)initWithPlacemark:(CLPlacemark *)placemark andLocation:(MKUserLocation *)location NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end