#import "MapViewController.h"
#import "CameraViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
    [self.mapView addGestureRecognizer:tapGestureRecogniser];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // Init location manager and check permissions.
    self.locationManager = [[CLLocationManager alloc] init];
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if (status == kCLAuthorizationStatusNotDetermined &&
        [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewWasTapped:(UIGestureRecognizer *)gesture
{
    // Remove touch pin if one already exists.
    if (self.touchPin) {
        [self.mapView removeAnnotation:self.touchPin];
    }
    
    // Setup touch pin and add to map.
    self.touchPin = [[MKPointAnnotation alloc] init];
    self.touchPin.title = @"Place object here.";
    
    CGPoint touchPoint = [gesture locationInView:self.mapView];
    CLLocationCoordinate2D touchCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    self.touchPin.coordinate = touchCoordinate;
    
    [self.mapView addAnnotation:self.touchPin];
}

- (IBAction)progressButton:(id)sender
{
    if (self.touchPin) {
        [self performSegueWithIdentifier:@"showGPSDemo" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showGPSDemo"]) {
        // Set model coordinate to position of the map pin.
        CameraViewController *viewController = [segue destinationViewController];
        
        CLLocationCoordinate2D touchPinCoordinate = self.touchPin.coordinate;
        
        viewController.objectCoordinate = [[CLLocation alloc] initWithLatitude:touchPinCoordinate.latitude longitude:touchPinCoordinate.longitude];
    }
}

@end
