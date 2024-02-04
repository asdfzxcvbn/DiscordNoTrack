#import <Foundation/Foundation.h>

@interface dummyDelegate : NSObject
- (void)URLRequest:(id)requestToken didSendDataWithProgress:(int64_t)bytesSent;
- (void)URLRequest:(id)requestToken didReceiveResponse:(NSURLResponse *)response;
- (void)URLRequest:(id)requestToken didReceiveData:(NSData *)data;
- (void)URLRequest:(id)requestToken didCompleteWithError:(NSError *)error;
@end
