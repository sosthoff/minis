//
//  MINSingleMiniDisplayCollectionViewCell.m
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import "MINSingleMiniDisplayCollectionViewCell.h"

@implementation MINSingleMiniDisplayCollectionViewCell


- (void)displayAsOwned:(BOOL)owned animated:(BOOL)animated {
    CGFloat newMiniAlpha = 0.0;
    CGFloat newGreyAlpha = 1.0;
    
    if (owned) {
        newMiniAlpha = 1.0;
        newGreyAlpha = 0.0;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.miniImage.alpha = newMiniAlpha;
            self.greyImage.alpha = newGreyAlpha;
            self.bgImage.alpha = newGreyAlpha;
        }];
    } else {
        self.miniImage.alpha = newMiniAlpha;
        self.greyImage.alpha = newGreyAlpha;
        self.bgImage.alpha = newGreyAlpha;
    }
}

@end
