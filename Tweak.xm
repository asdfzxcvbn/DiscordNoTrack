#import <Foundation/Foundation.h>
NSURLRequest *blocked = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0.0.0.0/"]];

// main discord endpoints
%hook RCTHTTPRequestHandler
- (id)sendRequest:(NSURLRequest *)request withDelegate:(id)delegate {
    if ([request.URL.absoluteString containsString:@"/api/v9/science"] || [request.URL.absoluteString containsString:@"/api/v9/metrics"]) { return %orig(blocked, delegate); }
    return %orig(request, delegate);
}
%end

// firebase logging
%hook NSURLSession
- (id)uploadTaskWithRequest:(NSURLRequest *)request fromData:(id)data completionHandler:(id)handler {
    if ([request.URL.absoluteString containsString:@"firebaselogging"]) { return %orig(blocked, data, handler); }
    return %orig(request, data, handler);
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
+ (void)setOfflineMode:(BOOL)a { %orig(YES); }
- (void)setEnabled:(BOOL)a { %orig(NO); }
%end

%hook ADJActivityHandler
- (void)setOfflineMode:(BOOL)a { %orig(YES); }
%end
