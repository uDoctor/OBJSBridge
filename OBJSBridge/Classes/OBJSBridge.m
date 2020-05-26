//
//  OBJSBridge.m
//  TestNativeToJS
//
//  Created by uDoctor on 2020/5/26.
//  Copyright © 2020 UD. All rights reserved.
//

#import "OBJSBridge.h"

typedef void(^MessageCallBack)(WKScriptMessage *message);

@interface OBJSBridge() <WKScriptMessageHandler>
@property (nonatomic, copy)MessageCallBack msgBack;
@end

@implementation OBJSBridge


+ (instancetype)shareBridge {
    static OBJSBridge * jsBridge = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsBridge = [OBJSBridge new];
    });
    return jsBridge;
}

- (void)registerPushFunction:(NSString *)fnName
                     webView:(WKWebView*)webView
                      params:(id)dict {
    NSString * dictStr = @"";
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        
        dictStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    } else if ([dict isKindOfClass:[NSString class]]) {
        dictStr = [NSString stringWithFormat:@"'%@'",dict];
    }
    
    NSString *jsStr = [NSString stringWithFormat:@"function %@ (){ return %@; }",fnName,dictStr];
    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error:%@",error);
        }
    }];
}

- (void)registerReceiveFunction:(NSString *)fnName
                        webView:(WKWebView*)webView
        didReceiveScriptMessage:(void(^)(WKScriptMessage *message))messageBack {
    
    __weak OBJSBridge *weakSelf = self;
    [webView.configuration.userContentController addScriptMessageHandler:weakSelf name:fnName];
    NSString *jsStr = [NSString stringWithFormat:@"function %@ (obj){ window.webkit.messageHandlers.%@.postMessage(obj); }",fnName,fnName];
    [webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"obj:%@",obj);
        NSLog(@"error:%@",error);
    }];
    self.msgBack = messageBack;
    
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.msgBack) {
        self.msgBack(message);
    }
}


- (void)dealloc
{
    NSLog(@"OBJSBridge dealloc!");
}
@end
