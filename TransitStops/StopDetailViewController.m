//
//  StopDetailViewController.m
//  TransitStops
//
//  Created by Charles Northup on 3/25/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "StopDetailViewController.h"

@interface StopDetailViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *routesLabel;
@property (weak, nonatomic) IBOutlet MKMapView *stopLocationMap;
@property (weak, nonatomic) IBOutlet UILabel *transferLabel;

@end

@implementation StopDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.routesLabel sizeToFit];
    self.routesLabel.text = self.routes;
    [self.routesLabel sizeToFit];
    self.transferLabel.text = self.trans;
    [self.transferLabel sizeToFit];
    MKCoordinateSpan corrdinateSpan = MKCoordinateSpanMake(.005, .005);
    MKCoordinateRegion region = MKCoordinateRegionMake(self.detailCurrentStop, corrdinateSpan);
    self.stopLocationMap.region = region;
    MKPointAnnotation* annotation = [MKPointAnnotation new];
    annotation.coordinate = self.detailCurrentStop;
    //annotation.title = @"Mobile Makers";
    [self.stopLocationMap addAnnotation:annotation];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
