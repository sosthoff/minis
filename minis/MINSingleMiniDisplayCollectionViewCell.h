//
//  MINSingleMiniDisplayCollectionViewCell.h
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MINSingleMiniDisplayCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readwrite) IBOutlet UIImageView *miniImage;
@property (weak, nonatomic) IBOutlet UIImageView *greyImage;

- (void)displayAsOwned:(BOOL)owned animated:(BOOL)animated;

@end
