//
//  AppDelegate.m
//  url-redirct
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
	NSString *urlString = [[event paramDescriptorForKeyword:keyDirectObject]stringValue];
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSDictionary *infoPlist = [mainBundle infoDictionary];
	
	NSString *targetNotificationIdentifier = [infoPlist objectForKey:@"URTargetNotificationIdentifier"];
	
	if(targetNotificationIdentifier)
	{
		void *object;
		const void *keys[] =   {CFSTR("url")};
		const void *values[] = {(CFStringRef)urlString};
		CFDictionaryRef userInfo = CFDictionaryCreate(kCFAllocatorDefault, keys, values, 1, NULL, NULL);
		CFStringRef notificationIdentifier = (CFStringRef)targetNotificationIdentifier;
		CFNotificationCenterRef distributedCenter = CFNotificationCenterGetDistributedCenter();
		CFNotificationCenterPostNotification(distributedCenter,
																				 notificationIdentifier,
																				 object,
																				 userInfo,
																				 true);
		CFRelease(userInfo);
	}
}

- (id)init
{
	if(!(self = [super init]))return self;
	
	NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
	
	[em
  setEventHandler:self
  andSelector:@selector(getUrl:withReplyEvent:)
  forEventClass:kInternetEventClass
  andEventID:kAEGetURL];
	
	[em
  setEventHandler:self
  andSelector:@selector(getUrl:withReplyEvent:)
  forEventClass:'WWW!'
  andEventID:'OURL'];
	
	NSBundle *mainBundle = [NSBundle mainBundle];
	NSDictionary *infoPlist = [mainBundle infoDictionary];
	CFStringRef bundleID = (CFStringRef)([mainBundle bundleIdentifier]);
	NSArray *types = [infoPlist objectForKey:@"CFBundleURLTypes"];
	if((types) && ([types count]))
	{
	 NSDictionary *type = [types objectAtIndex:0];
	 NSArray *schemes = [type objectForKey:@"CFBundleURLSchemes"];
	 for(NSUInteger i = 0; i < [schemes count];++i)
	 {
		 CFStringRef scheme = (CFStringRef)[schemes objectAtIndex:i];
		 OSStatus err = LSSetDefaultHandlerForURLScheme(scheme, bundleID);
		 if(!err){
			 NSLog(@"registered url scheme:%@", scheme);
		 }else
		 {
			 NSLog(@"failed registered url scheme:%@, error %d", scheme, (int)err);
		 }
	 }
	}
	
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
	[em removeEventHandlerForEventClass:kInternetEventClass andEventID:kAEGetURL];
	[em removeEventHandlerForEventClass:'WWW!' andEventID:'OURL'];
	NSLog(@"unregistered url schemes");
}

@end