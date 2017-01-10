#import "GPSNode.h"
#import "GPSManager.h"

@implementation GPSNode
{
    double _previousFrameTime;
}

/**
Initiates the node using a latitude, a longitude and a bearing.

@param location The real world location of the node.
@param bearing The bearing of the node relative to true north.
*/
- (instancetype)initWithLocation:(CLLocation *)location bearing:(double)bearing
{
    self = [super init];
    if (self) {
        GPSManager *gpsManager = [GPSManager getInstance];
        _deviceHeight = 1.5;
        
        if ([gpsManager getCurrentLocation] != nil) {
            
            [self setLocation:location bearing:bearing];
        }
    }
    
    return self;
}

/**
 Initiates the node using a latitude and a longitude. The node will face true north.
 
 @param location The real world location of the node.
 */
- (instancetype)initWithLocation:(CLLocation *)location
{
    return [self initWithLocation:location bearing:0];
}

//Sets location and bearing of GPS node and updates it's position.
- (void)setLocation:(CLLocation *)location bearing:(double) bearing
{
    _location = location;
    _bearing = bearing;
    
    [self updateWorldPosition];
}

//Sets GPS nodes locations and updates postion.
- (void)setLocation:(CLLocation *)location
{
    _location = location;
    
    [self updateWorldPosition];
}

//Sets GPS nodes bearing and updates postion.
- (void)setBearing:(double)bearing
{
    _bearing = bearing;
    
    [self updateWorldPosition];
}

//Sets devices height and updates postion.
- (void)setDeviceHeight:(double)deviceHeight
{
    _deviceHeight = deviceHeight;
    
    [self updateWorldPosition];
}

// Translate unit vector pointing north to position vector of object by bearing rotation then distance scale.
- (ARVector3 *)calculateTranslationVectorWithBearing:(double)bearing distance:(double)distance
{
    ARVector3 *northVec = [ARVector3 vectorWithValuesX:-1 y:0 z:0];
    northVec = [[ARQuaternion quaternionWithDegrees:bearing axisX:0 y:-1 z:0] multiplyByVector:northVec];
    northVec = [northVec multiplyByScalar:distance];
    
    return northVec;
}

//Updates GPS nodes position in GPS Manager world.
- (void)updateWorldPosition
{
    CLLocation *currentPos = [[GPSManager getInstance] getCurrentLocation];
    double distanceToObject = [_location distanceFromLocation:currentPos];
    double bearingToObject = [GPSManager bearingFrom:_location to:currentPos];
    
    _course = currentPos.course;
    _speed = currentPos.speed;
    
    // Translate unit vector pointing north to position vector of object by bearing rotation then distance scale.
    ARVector3 *translationVec = [self calculateTranslationVectorWithBearing:bearingToObject distance:distanceToObject];
    
    // Set node origin at floor height relative to the device.
    translationVec.y = -_deviceHeight;
    
    self.position = translationVec;
    self.orientation = [ARQuaternion quaternionWithDegrees:_bearing axisX:0 y:-1 z:0];
}

//ARRenderer delegate method.
- (void)preRender
{
    if (self.interpolateMotionUsingHeading) {
        
        // Check speed and course values are valid
        if (_speed > 0 && _course > 0) {
            
            double currentFrameTime = [ARRenderer getInstance].currentFrameTime;
            double deltaT = currentFrameTime - _previousFrameTime;
            
            // Don't let the object translate too far on the first frame or at low frame rates.
            if (deltaT < 1) {
                ARVector3 *translationVec = [self calculateTranslationVectorWithBearing:_course distance:deltaT * _speed];
                
                [self translateByVector:[translationVec negate]];
            }
            
            _previousFrameTime = currentFrameTime;
        }
    }
    
    [super preRender];
}
@end
