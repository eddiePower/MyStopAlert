//
//  StopDetailViewController.m
//  MyStopAlert
//
//  Created by Eddie Power on 8/6/19.
//  Copyright © 2019 Eddie Power. All rights reserved.
//

#import "StopDetailViewController.h"

@interface StopDetailViewController () <GMSMapViewDelegate>
@end

// Returns a random value from 0-1.0f.
static CGFloat randf() { return (((float)arc4random() / 0x100000000) * 1.0f); }

@implementation StopDetailViewController
@synthesize stopSuburb;
@synthesize stopName;
@synthesize stopLong;
@synthesize stopLatt;
@synthesize stopHeader;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtStopSuburb.text = self.stopSuburb;
    self.txtStopNameDetail.text = self.stopName;
    self.txtStopLong.text = [NSString stringWithFormat:@"%@", self.stopLong];
    self.txtStopLatt.text = [NSString stringWithFormat:@"%@", self.stopLatt];
    self.txtStopDetailHeader.text = [NSString stringWithFormat:@"Stop: %@ Details.", self.stopName];
    
    [self buildGoogleMapForStopLocation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)buildGoogleMapForStopLocation
{
    //create the map location called the camera.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: [self.stopLatt doubleValue]
                                                            longitude: [self.stopLong doubleValue]
                                                                 zoom: 16];
    
    //create the map view to go within our camera
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.frame = CGRectMake(35, 470, 320, 332);
    
    //set the scrolling / zooming settings for the map instance.
    self.mapView.settings.scrollGestures = FALSE;
    self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = FALSE;
    self.mapView.settings.zoomGestures = FALSE;
    self.mapView.settings.allowScrollGesturesDuringRotateOrZoom = FALSE;
    
    self.mapView.delegate = self; //set where to send map updates to
    
    // Add status label, initially hidden.
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    self.statusLabel.alpha = 0.0f;
    self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.statusLabel.backgroundColor = [UIColor blueColor];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = [NSString stringWithFormat:@"%@\n%@\nFacilities: Stuff", self.stopName, self.stopSuburb];
    
    //assign our map marker to the mapview,
    [self.mapView addSubview: self.statusLabel];
    [self.view addSubview:self.mapView]; //set the map view as a sub view of our vc
}

//- (void)mapViewDidStartTileRendering:(GMSMapView *)mapView
//{
//    self.statusLabel.alpha = 0.8f;
//    self.statusLabel.text = @"Rendering";
//}
//
//- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView
//{
//    self.statusLabel.alpha = 0.0f;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self.mapView
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self.mapView clear];
    [self addDefaultMarker];
}

- (void)applicationWillEnterForeground
{
    [self.mapView clear];
    [self addDefaultMarker];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker
{
    // Show an info window with dynamic content - a simple background color animation.
    self.infoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    UIView *infoView = self.infoView;
    marker.tracksInfoWindowChanges = YES;
    UIColor *color = [UIColor colorWithHue:randf() saturation:1.f brightness:1.f alpha:1.0f];
    self.infoView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:1.0
                          delay:1.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         infoView.backgroundColor = color;
                     }
                     completion:^(BOOL finished)
                    {
                         [UIView animateWithDuration:1.0
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              infoView.backgroundColor = [UIColor clearColor];
                                          }
                                          completion:^(BOOL finished2) {
                                              marker.tracksInfoWindowChanges = NO;
                                          }];
                     }];
    
    return self.infoView;
}

- (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker
{
    self.infoView = nil;
    marker.tracksInfoWindowChanges = NO;
}

- (void)addDefaultMarker
{
    // Add a custom 'glow' marker with a pulsing blue shadow on the stop requested.
    GMSMarker *stopMarker = [[GMSMarker alloc] init];
    stopMarker.title = [NSString stringWithFormat:@"%@\n%@\nFacilities: Stuff", self.stopName, self.stopSuburb];
    stopMarker.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glow-marker"]];
    stopMarker.position = CLLocationCoordinate2DMake([self.stopLatt doubleValue], [self.stopLong doubleValue]);
    stopMarker.iconView.contentMode = UIViewContentModeCenter;
    CGRect oldBound = stopMarker.iconView.bounds;
    CGRect bound = oldBound;
    bound.size.width *= 2;
    bound.size.height *= 2;
    stopMarker.iconView.bounds = bound;
    stopMarker.groundAnchor = CGPointMake(0.5, 0.75);
    stopMarker.infoWindowAnchor = CGPointMake(0.5, 0.25);
    UIView *stopGlow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glow-marker"]];
    stopGlow.layer.shadowColor = [UIColor blueColor].CGColor;
    stopGlow.layer.shadowOffset = CGSizeZero;
    stopGlow.layer.shadowRadius = 8.0;
    stopGlow.layer.shadowOpacity = 1.0;
    stopGlow.layer.opacity = 0.0;
    [stopMarker.iconView addSubview: stopGlow];
    stopGlow.center = CGPointMake(oldBound.size.width, oldBound.size.height);
    stopMarker.map = self.mapView;
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewKeyframeAnimationOptionAutoreverse |
     UIViewKeyframeAnimationOptionRepeat
                     animations:^{
                         stopGlow.layer.opacity = 1.0;
                     }
                     completion:^(BOOL finished)
    {
                         // If the animation is ever terminated, no need to keep tracking the view for changes.
                         stopMarker.tracksViewChanges = NO;
                     }];
}

@end
