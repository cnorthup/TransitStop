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
    CLLocationCoordinate2D centerOfStops;
    MKCoordinateSpan trainSpan;
    MKCoordinateRegion trainRegion;
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
        myMapView.region = trainRegion;
    }];
}

-(void)stopsOnMap{
    double easternBorder = 0.0;
    double westernBorder = 0.0;
    double northernBorder = 0.0;
    double southernBorder = 100.0;
    double averageLat = 0.0;
    double averageLong = 0.0;
    
    for (int i = 0; i <arrayOfStopInfo.count; i++) {
        NSDictionary* stop = [arrayOfStopInfo objectAtIndex:i];
        double lat = [stop[@"latitude"] doubleValue];
        CLLocationDegrees* latitude = &lat;
        double lonG = [stop[@"longitude"] doubleValue];
        if ([stop[@"stop_id"] isEqualToString:@"4975"]) {
            lonG *= -1;
        }
        CLLocationDegrees* longitude = &lonG;
        CLLocationCoordinate2D currentStop = CLLocationCoordinate2DMake(*latitude, *longitude);

        MKPointAnnotation *testStop = [MKPointAnnotation new];
        testStop.coordinate = currentStop;
        testStop.title = stop[@"cta_stop_name"];
        testStop.subtitle = [NSString stringWithFormat:@"Routes: %@",stop[@"routes"]];
        
        averageLat += lat;
        averageLong += lonG;
        if (northernBorder < lat) {
            northernBorder = lat;
        }
        if (southernBorder > lat) {
            southernBorder = lat;
        }
        if (easternBorder > lonG) {
            easternBorder = lonG;
        }
        if (westernBorder < fabs(lonG)) {
            westernBorder = lonG;
        }

        [myMapView addAnnotation:testStop];
    }
    NSLog(@"%f",westernBorder);
    NSLog(@"%f",easternBorder);
    NSLog(@"%f",northernBorder);
    NSLog(@"%f",southernBorder);
    averageLat /= arrayOfStopInfo.count;
    averageLong /= arrayOfStopInfo.count;
    NSLog(@"%f", averageLong);
    NSLog(@"%f", averageLat);
    centerOfStops = CLLocationCoordinate2DMake(averageLat, averageLong);
    CLLocationDegrees eastWestSpan = fabs(easternBorder - westernBorder)+.006;
    CLLocationDegrees northSouthSpan = (northernBorder - southernBorder)+.006;
    trainSpan = MKCoordinateSpanMake(northSouthSpan, eastWestSpan);
    trainRegion = MKCoordinateRegionMake(centerOfStops, trainSpan);
    
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
