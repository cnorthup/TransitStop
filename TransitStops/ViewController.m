//
//  ViewController.m
//  TransitStops
//
//  Created by Charles Northup on 3/25/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "StopDetailViewController.h"

@interface ViewController () <MKMapViewDelegate>
{
    NSArray* arrayOfStopInfo;
    NSMutableDictionary* stopsDictionary;
    IBOutlet MKMapView *myMapView;
    IBOutlet UIButton* infoButton;
}
@end

@implementation ViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    arrayOfStopInfo = [NSArray new];
    stopsDictionary = [NSMutableDictionary new];
    infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    CLLocationCoordinate2D centerOfChicago = CLLocationCoordinate2DMake(41.88206, -87.6278);
    MKCoordinateSpan corrdinateSpan = MKCoordinateSpanMake(.3, .4);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerOfChicago, corrdinateSpan);
    myMapView.region = region;
    NSURL* url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError* error;
        stopsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        arrayOfStopInfo = stopsDictionary[@"row"];
        [self stopsOnMap];
//        NSLog(@"%lu", (unsigned long)stopsDictionary.count);
//        
//        
//        NSLog(@"%lu", (unsigned long)arrayOfStopInfo.count);
//        NSDictionary *firstStopTest = [arrayOfStopInfo objectAtIndex:0];
//        double lat = [firstStopTest[@"latitude"] doubleValue];
//        CLLocationDegrees* latitude = &lat;
//        double lonG = [firstStopTest[@"longitude"] doubleValue];
//        CLLocationDegrees* longitude = &lonG;
//        CLLocationCoordinate2D jackAndFin = CLLocationCoordinate2DMake(*latitude, *longitude);
//        MKPointAnnotation *testStop = [MKPointAnnotation new];
//        testStop.coordinate = jackAndFin;
//        [myMapView addAnnotation:testStop];
    }];
}

-(void)stopsOnMap{
    for (int i = 0; i <arrayOfStopInfo.count; i++) {
        NSDictionary* stop = [arrayOfStopInfo objectAtIndex:i];
        double lat = [stop[@"latitude"] doubleValue];
        CLLocationDegrees* latitude = &lat;
        double lonG = [stop[@"longitude"] doubleValue];
        CLLocationDegrees* longitude = &lonG;
        CLLocationCoordinate2D currentStop = CLLocationCoordinate2DMake(*latitude, *longitude);

        MKPointAnnotation *testStop = [MKPointAnnotation new];
        testStop.coordinate = currentStop;
        testStop.title = stop[@"cta_stop_name"];
        testStop.subtitle = [NSString stringWithFormat:@"Routes: %@",stop[@"routes"]];

        [myMapView addAnnotation:testStop];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MKPinAnnotationView* pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = infoButton;
    NSLog(@"runing");
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    [self performSegueWithIdentifier:@"MAX_IS_BEST" sender:view.annotation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKPointAnnotation *)annotation {
    StopDetailViewController *vc = segue.destinationViewController;
    vc.title = annotation.title;
    vc.routes = annotation.subtitle;
    vc.detailCurrentStop = annotation.coordinate;
    for (NSDictionary*transfer in arrayOfStopInfo) {
        NSString* tester = transfer[@"cta_stop_name"];
        if ([vc.title isEqualToString:tester]) {
            vc.trans = transfer[@"inter_modal"];
        }
    }
    if (vc.trans.length == 0) {
        vc.trans = @"None";
    }
}












@end
