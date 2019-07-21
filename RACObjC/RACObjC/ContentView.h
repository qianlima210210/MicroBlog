//
//  ContentView.h
//  RACObjC
//
//  Created by ma qianli on 2019/7/18.
//  Copyright © 2019 qianli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentView : UIView

@property (nonatomic, strong) RACSubject *subject;

- (void)sendValue:(NSString*)value dic:(NSDictionary*)dic;

@end

NS_ASSUME_NONNULL_END
