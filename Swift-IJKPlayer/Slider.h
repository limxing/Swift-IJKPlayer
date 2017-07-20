//
//  Slider.h
//  Swift-IJKPlayer
//
//  Created by 李利锋 on 2017/7/20.
//  Copyright © 2017年 leefeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Slider : UIImage
+ (UIImage*) createImageWithColor:(UIColor*) color;
+ (UIImage *)circleImageWithImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end
