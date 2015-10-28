@import UIKit;
@import MapKit;

@interface MapViewController : UIViewController <MKMapViewDelegate>

/**
 MapView for displaying user and model location.
 */
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

/**
 Map pin to mark location the model should be drawn at.
 */
@property (strong, nonatomic) MKPointAnnotation *touchPin;

/**
 Location manager to update user position on map.
 */
@property (strong, nonatomic) CLLocationManager *locationManager;

/**
 Button to segue mapViewController into CameraViewController.
 */
- (IBAction)progressButton:(id)sender;

@end
