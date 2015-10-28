#import "CameraViewController.h"
@import CoreLocation;

@interface CameraViewController()

@property (nonatomic, strong) ARGPSNode *gpsNode;

@end

@implementation CameraViewController

- (void)setupContent
{
    // Initialise and start the GPS Manager.
    ARGPSManager *gpsManager = [ARGPSManager getInstance];
    [gpsManager initialise];
    [gpsManager start];
    
    // Initialise a GPSNode with coordinate provided from the map.
    ARGPSNode *gpsNode = [[ARGPSNode alloc] initWithLocation:self.objectCoordinate];
    
    // Point the GPS Node due east.
    [gpsNode setBearing:90];
    
    // Must add GPSNode as a child to the GPS Manager world.
    [gpsManager.world addChild:gpsNode];
    
    // Import the model.
    ARModelImporter *modelImporter = [[ARModelImporter alloc] initWithBundled:@"Big_Ben_Low_Poly.armodel"];
    
    // The ARModel node represents all external contents relating to the model e.g.animations, textures.
    ARModelNode *modelNode = [modelImporter getNode];

    // Add the modelNode as a child to the GPSNode.
    [gpsNode addChild:modelNode];
    
    // Add the texture to the 3D model.
    ARTexture *modelTexture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"Big_Ben_diffuse"]];
    
    // Setup the object material.
    ARLightMaterial *modelMaterial = [[ARLightMaterial alloc] init];
    modelMaterial.texture = modelTexture;
    modelMaterial.ambient = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
    modelMaterial.diffuse = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
    
    // Apply to the model.
    for (ARMeshNode *meshNode in modelNode.meshNodes) {
        meshNode.material = modelMaterial;
    }
    
    // Scale the model to the correct height of Big Ben from model height. Units of the GPSManager world are meters, model is 11008 units high in object space.
    [modelNode scaleByUniform:(96.0 / 11008.0)];
    
    self.gpsNode = gpsNode;
}


- (IBAction)smoothingButton:(id)sender
{    
    BOOL isMotionInterpolated = self.gpsNode.interpolateMotionUsingHeading;
    
    self.gpsNode.interpolateMotionUsingHeading = !isMotionInterpolated;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sender setTitle:[NSString stringWithFormat:@"Smoothing:%@", !isMotionInterpolated ? @"ON" : @"OFF"] forState:UIControlStateNormal];
    });
}

@end
