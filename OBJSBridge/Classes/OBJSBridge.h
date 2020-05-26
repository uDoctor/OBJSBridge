//
//  OBJSBridge.h
//  TestNativeToJS
//
//  Created by uDoctor on 2020/5/26.
//  Copyright © 2020 UD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBJSBridge : NSObject


/**
 选择单利创建 OBJSBridge 实例是因为jsbridge 注册方法后，某些条件下不能销毁，故只创建一次

 @return 返回一个OBJSBridge 实例
 */
+ (instancetype)shareBridge;


/**
 OC -> JS
 向js中注册一个方法，oc可以通过该方法传入参数给js 使用，

 @param fnName js方法名字
 @param webView js接收的web环境
 @param dict 参数，可以是字符串，也可以是字典
 */
- (void)registerPushFunction:(NSString *)fnName
                     webView:(WKWebView*)webView
                      params:(id)dict;


/**
 JS -> OC
 向js中注册一个方法，js可以通过该方法向OC传参

 @param fnName js方法名字
 @param webView js接收的web环境
 @param messageBack 其中body是js传过来的数据容器
 */
- (void)registerReceiveFunction:(NSString *)fnName
                        webView:(WKWebView*)webView
        didReceiveScriptMessage:(void(^)(WKScriptMessage *message))messageBack;

@end

NS_ASSUME_NONNULL_END
