#import <Foundation/Foundation.h>
NSURLRequest *blocked = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://0.0.0.0/"]];

%hook RCTHTTPRequestHandler
- (id)sendRequest:(NSURLRequest *)request withDelegate:(id)delegate {
    if ([request.URL.absoluteString containsString:@"/api/v9/science"] || [request.URL.absoluteString containsString:@"/api/v9/metrics"]) { return %orig(blocked, delegate); }
    return %orig(request, delegate);
}
%end

%hook NSURLSession
- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(id)handler {
    if ([request.URL.absoluteString containsString:@"sentry.io"]) { return %orig(blocked, handler); }
    return %orig(request, handler);
}
%end
