//
//  ViewController.m
//  Runtime
//
//  Created by wangZL on 2017/3/2.
//  Copyright © 2017年 WangZeLin. All rights reserved.
//

#import "ViewController.h"
 #import <objc/objc-runtime.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}
+(void)load{
    [super load];
    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method toMethod = class_getInstanceMethod([self class], @selector(zz_viewDidLoad));
    /**
     *在这里使用class_addMethod()函数对Method Swizzling做了一层验证,如果self没有被实现,就会交换失败
     *self没有交换的实现方法,但是父类有这个方法,这样就会调用父类的方法
     *通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了
     */
    if (!class_addMethod([self class], @selector(viewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}
-(void)zz_viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    NSLog(@"替换系统方法");
}
@end
