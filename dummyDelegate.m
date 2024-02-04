#import <Foundation/Foundation.h>
#import "dummyDelegate.h"

@implementation dummyDelegate
- (void)URLRequest:(id)requestToken didSendDataWithProgress:(int64_t)bytesSent {}
- (void)URLRequest:(id)requestToken didReceiveResponse:(NSURLResponse *)response {}
- (void)URLRequest:(id)requestToken didReceiveData:(NSData *)data {}
- (void)URLRequest:(id)requestToken didCompleteWithError:(NSError *)error {}
@end
