#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <KudanAR/KudanAR.h>
/**
 A manager class singleton for placing nodes at real world locations. The GPSManager world is aligned to true north.
 */
@interface GPSManager : NSObject <CLLocationManagerDelegate, ARRendererDelegate>

/**
 The location manager responsible for updating the location of the manager world.
 */
@property (nonatomic, strong) CLLocationManager *locationManager;

/**
 Maths method for calculating the bearing between two locations.
 @param source The start location.
 @param dest The end location.
 */
+ (double)bearingFrom:(CLLocation *)source to:(CLLocation *)dest;

/**
 Returns the manager singleton.
 */
+ (GPSManager *)getInstance;

/**
 Returns the most recent update of the device location.
 */
- (CLLocation *)getCurrentLocation;

/**
 Initialises GPS Manager.
 */
- (void)initialise;

/**
 Deinitialises GPS manager
 */
- (void)deinitialise;

/**
 Starts GPS Manager, Gyro manager and ands GPS Manager to ARRenderer delegate
 */
- (void)start;

/**
 Stops GPS Manager, Gyro Manager and removes GPS Manager from ARRenderer delegate
 */
- (void)stop;

/**
 GPS Managers world
 */
@property (nonatomic) ARWorld *world;

@end
