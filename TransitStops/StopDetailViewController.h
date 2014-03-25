//
//  StopDetailViewController.h
//  TransitStops
//
//  Created by Charles Northup on 3/25/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface StopDetailViewController : UIViewController
@property NSString* address;
@property NSString* routes;
@property CLLocationCoordinate2D detailCurrentStop;
@property NSString* trans;
@end
