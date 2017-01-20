#import "CameraViewController.h"
#import "GPSNode.h"
#import "GPSManager.h"

@import CoreLocation;

@interface CameraViewController()

@property (nonatomic, strong) GPSNode *gpsNode;

@end

@implementation CameraViewController

- (void)setupContent
{
    // Initialise and start the GPSManager.
    GPSManager *gpsManager = [GPSManager getInstance];
    [gpsManager initialise];
    [self.cameraView.contentViewPort.camera addChild:gpsManager.world];
    [gpsManager start];
    
    // Initialise a GPSNode with coordinate provided from the map.
    self.gpsNode = [[GPSNode alloc] initWithLocation:self.objectCoordinate];
    
    // Point the GPS Node due east.
    [self.gpsNode setBearing:90];
    
    // Must add GPSNode as a child to the GPS Manager world.
    [gpsManager.world addChild:self.gpsNode];
    
    // Import the model.
    ARModelImporter *modelImporter = [[ARModelImporter alloc] initWithBundled:@"Big_Ben_Low_Poly.armodel"];
    
    // The ARModel node represents all external contents relating to the model e.g.animations, textures.
    ARModelNode *modelNode = [modelImporter getNode];

    // Add the modelNode as a child to the GPSNode.
    [self.gpsNode addChild:modelNode];
    
    // Add the texture to the 3D model.
    ARTexture *modelTexture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"Big_Ben_diffuse"]];
    
    // Setup the object material.
    ARLightMaterial *modelMaterial = [[ARLightMaterial alloc] init];
    modelMaterial.colour.texture = modelTexture;
    modelMaterial.ambient.value = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
    modelMaterial.diffuse.value = [ARVector3 vectorWithValues:0.5]; // An alternative way of creating an ARVector3 that contains the same values in all fields
    
    // Apply to the model.
    for (ARMeshNode *meshNode in modelNode.meshNodes) {
        meshNode.material = modelMaterial;
    }
    
    // Scale the model to the correct height of Big Ben from model height. Units of the GPSManager world are meters, model is 11008 units high in object space.
    [modelNode scaleByUniform:(96.0 / 11008.0)];
}


- (IBAction)smoothingButton:(UIButton *)sender
{    
    BOOL isMotionInterpolated = self.gpsNode.interpolateMotionUsingHeading;
    
    self.gpsNode.interpolateMotionUsingHeading = !isMotionInterpolated;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [sender setTitle:[NSString stringWithFormat:@"Smoothing:%@", !isMotionInterpolated ? @"ON" : @"OFF"] forState:UIControlStateNormal];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[GPSManager getInstance] deinitialise];
    [super viewWillDisappear:animated];
}

@end
