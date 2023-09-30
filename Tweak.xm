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
%end

// app-measurement
%hook APMMeasurement
- (BOOL)isEnabled { return NO; }
%end