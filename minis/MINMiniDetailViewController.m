//
//  MINMiniDetailViewController.m
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import "MINMiniDetailViewController.h"

@interface MINMiniDetailViewController ()

@property (nonatomic, weak, readwrite) IBOutlet UIImageView* miniImage;
@property (nonatomic, strong, readwrite) UIImage* image;

@end

@implementation MINMiniDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.miniImage.image = self.image;
}


- (id)initWithImage:(UIImage *)image {
    self = [self initWithNibName:nil bundle:nil];
    _image = image;
    
    return self;
}


@end
