@import UIKit;
@class CLLocation;

#import <KudanAR/KudanAR.h>

@interface CameraViewController : ARCameraViewController <ARRendererDelegate>

/**
 Location the model will be placed at.
 */
@property (strong, nonatomic) CLLocation *objectCoordinate;

- (IBAction)smoothingButton:(id)sender;

@end

