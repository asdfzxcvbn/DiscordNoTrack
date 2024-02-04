#import <Foundation/Foundation.h>
#import "dummyDelegate.h"
%config(generator=internal);

dummyDelegate *dummy = [[dummyDelegate alloc] init];
NSURLRequest *blocked = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0.0.0.0/"]];
NSArray *endpoints = @[@"/api/v9/science", @"/api/v9/metrics"];

// main discord endpoints
%hook RCTHTTPRequestHandler
- (id)sendRequest:(NSURLRequest *)request withDelegate:(id)delegate {
    if ([endpoints containsObject:request.URL.path]) { return %orig(blocked, dummy); }
    return %orig(request, delegate);
}
%end

// firebase logging + adjust network blocking
%hook NSURLSession
- (id)uploadTaskWithRequest:(NSURLRequest *)request fromData:(id)data completionHandler:(id)handler {
    if ([request.URL.absoluteString containsString:@"firebaselogging"]) { return %orig(blocked, data, handler); }
    return %orig(request, data, handler);
}

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(id)handler {
    // jesus, they apparently own like, 3 domains? that's stupid.
    if ([request.URL.absoluteString containsString:@"adjust."]) { return %orig(blocked, handler); }
    return %orig(request, handler);
}
%end

// sentry
%hook SentrySDK
+ (BOOL)isEnabled { return NO; }
%end

%hook SentryOptions
- (BOOL)enabled { return NO; }
- (BOOL)isTracingEnabled { return NO; }
- (BOOL)isProfilingEnabled { return NO; }
- (void)setEnabled:(BOOL)a { %orig(NO); }
%end

%hook SentryClient
- (BOOL)isEnabled { return NO; }
%end

%hook SentryNSDataTracker
- (BOOL)isEnabled { return NO; }
- (void)setIsEnabled:(BOOL)a { %orig(NO); }
%end

%hook SentryNetworkTracker
- (BOOL)isNetworkTrackingEnabled { return NO; }
- (BOOL)isNetworkBreadcrumbEnabled { return NO; }
- (void)setIsNetworkTrackingEnabled:(BOOL)a { %orig(NO); }
- (void)setIsNetworkBreadcrumbEnabled:(BOOL)a { %orig(NO); }
%end

// app-measurement
%hook APMMeasurement
- (void)uploadData {}
- (BOOL)isEnabled { return NO; }
- (BOOL)hasDataToUpload { return NO; }
- (BOOL)isNetworkRequestPending { return NO; }
- (BOOL)isAnalyticsCollectionEnabled { return NO; }
- (BOOL)isAnalyticsCollectionDeactivated { return YES; }
%end

// adjust
%hook Adjust
+ (BOOL)isEnabled { return NO; }
+ (void)setEnabled:(BOOL)a { %orig(NO); }
+ (void)setOfflineMode:(BOOL)arg1 { %orig(YES); }
- (void)setOfflineMode:(BOOL)arg1 { %orig(YES); }
- (void)setEnabled:(BOOL)a { %orig(NO); }
- (BOOL)isInstanceEnabled { return NO; }
- (BOOL)isEnabled { return NO; }
%end

%hook ADJActivityHandler
- (void)setOfflineMode:(BOOL)a { %orig(YES); }
- (void)setOfflineModeI:(id)a offline:(BOOL)b { %orig(a, YES); }
%end

// crashlytics
%hook FIRCrashlytics
+ (void)load {}
- (void)sendUnsentReports {}
- (void)setCrashlyticsCollectionEnabled:(BOOL)a { %orig(NO); }
- (BOOL)isCrashlyticsCollectionEnabled { return NO; }
%end
