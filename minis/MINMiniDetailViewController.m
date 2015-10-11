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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithImage:(UIImage *)image {
    self = [self initWithNibName:nil bundle:nil];
    _image = image;
    
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
