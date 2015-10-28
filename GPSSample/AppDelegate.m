#import "AppDelegate.h"
#import <KudanAR/ARAPIKey.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[ARAPIKey sharedInstance] setAPIKey:@"GAWQE-F9AUS-3FKQU-YEEZ6-G7ZA3-D86JX-PJFNW-DTHUB-A9KAJ-6SAF9-EWUU7-MR9WK-6CDY6-TEK9R-LWF8A-A"];
    
    return YES;
}

@end
