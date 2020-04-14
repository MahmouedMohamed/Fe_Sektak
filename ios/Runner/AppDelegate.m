#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  // TODO: Add your API key
  [GMSServices provideAPIKey: @"AIzaSyDzwwuHFfcazNEYoFDQC-P2hgwRfb1tJK4"];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end