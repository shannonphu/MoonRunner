//
//  MapDetailViewController.m
//  MoonRunner
//
//  Created by Shannon Phu on 7/31/15.
//  Copyright (c) 2015 Shannon Phu. All rights reserved.
//

#import "MapDetailViewController.h"
#import <MapKit/MapKit.h>
#import "MathController.h"
#import "Run.h"
#import "Location.h"

@interface MapDetailViewController () <MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;
@end

@implementation MapDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Managing map

- (void)setRun:(Run *)run {
    if (_run != run) {
        _run = run;
        [self configureView];
    }
}

- (void)configureView {
    self.mapView.delegate = self;
    self.distanceLabel.text = [MathController stringForDistance:self.run.distance.floatValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLabel.text = [formatter stringFromDate:self.run.timestamp];
    self.timeLabel.text = [NSString stringWithFormat:@"Time: %@", [MathController stringForSeconds:self.run.duration.intValue usingLongFormat:YES]];
    self.paceLabel.text = [NSString stringWithFormat:@"Pace: %@", [MathController stringForAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];
    [self loadMap];
}

- (MKCoordinateRegion)mapRegion {
    MKCoordinateRegion region;
    Location *initialLoc = self.run.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longitude.floatValue;
    
    for (Location *location in self.run.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue < minLng) {
            minLng = location.longitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longitude.floatValue > maxLng) {
            maxLng = location.longitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f; // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * 1.1f; // 10% padding
    
    return region;
}


// if map gets request to add overlay, check it is
// MKPolyLine and make line black and width 3

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        renderer.strokeColor = [UIColor blackColor];
        renderer.lineWidth = 3;
        return renderer;
    }
    return nil;
}

- (MKPolyline *)polyline {
    CLLocationCoordinate2D coord[self.run.locations.count];
    for (int i = 0; i < self.run.locations.count; i++) {
        Location *location = [self.run.locations objectAtIndex:i];
        coord[i] = CLLocationCoordinate2DMake(location.latitude.doubleValue, location.longitude.doubleValue);
    }
    return [MKPolyline polylineWithCoordinates:coord count:self.run.locations.count];
}

- (void)loadMap {
    if (self.run.locations.count > 0) {
        self.mapView.hidden = NO;
        [self.mapView setRegion:[self mapRegion]];
        [self.mapView addOverlay:[self polyline]];
    } else {
        self.mapView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, this run has no locations saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
