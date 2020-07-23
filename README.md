# OBJSBridge

[![CI Status](https://img.shields.io/travis/李杨/OBJSBridge.svg?style=flat)](https://travis-ci.org/李杨/OBJSBridge)
[![Version](https://img.shields.io/cocoapods/v/OBJSBridge.svg?style=flat)](https://cocoapods.org/pods/OBJSBridge)
[![License](https://img.shields.io/cocoapods/l/OBJSBridge.svg?style=flat)](https://cocoapods.org/pods/OBJSBridge)
[![Platform](https://img.shields.io/cocoapods/p/OBJSBridge.svg?style=flat)](https://cocoapods.org/pods/OBJSBridge)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

OBJSBridge is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'OBJSBridge'
```

## Use


不管js调用oc方法，还是oc调用js，前提是需要注册
# 一：OC->JS 传递参数，可以是字典，也可以是字符串。


首先向JS中注册方法，代码如下

```objectivec
    //oc代码
    [[OBJSBridge shareBridge] registerPushFunction:@"pushUserId"
                                           webView:self.wkwebView
                                            params:@{@"userID": @"2345432"}];

```
params：是传入的参数，js可以接收到该参数。
当方法注册了js中，js就可以直接使用方法了

```javascript
      //js代码
      if (typeof(pushUserId) === 'function') {
        this.info = pushUserId(); 
      }
```


# 二：JS->OC传递参数，可以是字典，也可以是字符串。

前提是oc向js中注入方法，该方法有回调，


```objectivec
   //oc代码
    [[OBJSBridge shareBridge] registerReceiveFunction:@"getJSProductUser"
                                              webView:self.wkwebView
                              didReceiveScriptMessage:^(WKScriptMessage * _Nonnull message) {
        NSLog(@"getJSProductUser:%@",message.body);
    }];

```

方法注册完成后，js直接调用方法，并传递参数。

```javascript
//js代码
if (typeof(getJSProductUser) === 'function') {
        getJSProductUser({"userName":"lishuyang","usreID":"32345"});
}

```

该方法也可在js直接调用，因为oc已经将方法注入到js中。
可在控制台查看js传过来的参数

## Author

OB, 714711047@qq.com

## License

OBJSBridge is available under the MIT license. See the LICENSE file for more info.
