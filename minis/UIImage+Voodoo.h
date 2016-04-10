//
//  UIImage+Voodoo.h
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Voodoo)

- (UIImage *)convertImageToGrayScale;
- (UIImage *)replaceColor:(UIColor*)color withTolerance:(float)tolerance;
- (UIImage *)replaceColorWithEdgeDetection:(UIColor*)color withTolerance:(float)tolerance;
+ (UIImage*)circularScaleAndCropImage:(UIImage*)image frame:(CGRect)frame;

@end
