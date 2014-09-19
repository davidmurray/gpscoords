#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// Private API
@interface CLLocationManager ()
+ (void)setAuthorizationStatus:(BOOL)status forBundleIdentifier:(NSString *)bundleIdentifier;
- (instancetype)initWithEffectiveBundleIdentifier:(NSString *)bundleIdentifier;
@end

static CLLocationManager *locationManager = nil;

@interface GCLocationManagerDelegate : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedInstance;

@end

@implementation GCLocationManagerDelegate

+ (instancetype)sharedInstance
{
	static dispatch_once_t once;
	static GCLocationManagerDelegate *sharedInstance = nil;

	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});

	return sharedInstance;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	CLLocation *location = [locations lastObject];
	CLLocationCoordinate2D coordinate = [location coordinate];
	printf("%f, %f\n", coordinate.latitude, coordinate.longitude);

	CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Failed to get location: %@", error);
}

@end

int main(int argc, char **argv, char **envp)
{
	[CLLocationManager setAuthorizationStatus:YES forBundleIdentifier:@"me.cykey.gpscoords"];

	locationManager = [[CLLocationManager alloc] initWithEffectiveBundleIdentifier:@"me.cykey.gpscoords"];
	[locationManager setDistanceFilter:kCLDistanceFilterNone];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	[locationManager setDelegate:[GCLocationManagerDelegate sharedInstance]];
	[locationManager startUpdatingLocation];

	CFRunLoopRun();

	return 0;
}
