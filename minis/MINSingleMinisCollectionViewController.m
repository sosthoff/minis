//
//  MINSingleMinisCollectionViewController.m
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import "MINSingleMinisCollectionViewController.h"
#import "MINSingleMiniDisplayCollectionViewCell.h"
#import "MINMiniDetailViewController.h"
#import "UIImage+Voodoo.h"

@interface MINSingleMinisCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

typedef NS_ENUM(NSInteger, MINViewMode){
    MINViewModeCollection,
    MINViewModeDiscovery,
    MINViewModeShopping
};


@property (nonatomic, strong, readwrite) UIBarButtonItem* rightButton;
@property (nonatomic, assign, readwrite) MINViewMode viewMode;

@end

@implementation MINSingleMinisCollectionViewController

static NSString * const reuseIdentifier = @"miniCell";


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"View Mode" style:UIBarButtonItemStylePlain target:self action:@selector(switchViewMode:)];
        _rightButton = item;
        [self.navigationItem setRightBarButtonItem:item];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

-(void)setViewMode:(MINViewMode)viewMode {
    BOOL shouldReload = _viewMode != viewMode;
    _viewMode = viewMode;
    NSString* title;
    switch (viewMode) {
        case MINViewModeCollection:
            title = @"Collection";
            break;
            
        case MINViewModeDiscovery:
            title = @"Discovery";
            break;
            
        case MINViewModeShopping:
            title = @"Shopping";
            break;
    }
    if (self.rightButton) {
        self.rightButton.title = title;
    }
    if (shouldReload) {
        [self.collectionView reloadData];
    }
}

- (IBAction)switchViewMode:(id)sender {
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Discovery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewMode = MINViewModeDiscovery;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Collection" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewMode = MINViewModeCollection;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Shopping" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.viewMode = MINViewModeShopping;
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat hight = size.height - 64;
    hight = hight/6;
    
    return CGSizeMake(hight, hight);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MINSingleMiniDisplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    NSString* imageName = [self imageNameForIndexPath:indexPath];
    UIImage* image = [UIImage imageNamed:imageName];
    cell.miniImage.image = image;
    
    UIImage* greyImage = [image convertImageToGrayScale];
    greyImage = [greyImage replaceColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] withTolerance:10.0];
    cell.greyImage.image = greyImage;
    cell.gestureRecognizers = [self gestureRecognizersForCell];
    BOOL owned = [self ownedStatusOf:imageName];
    if (self.viewMode == MINViewModeDiscovery) {
        owned = YES;
    }
    [cell displayAsOwned:owned animated:NO];
    
   return cell;
}


- (NSString*)imageNameForIndexPath:(NSIndexPath*)indexPath {
    return [NSString stringWithFormat: @"%@-%@.jpg", self.suggestedSeriesName, [@(indexPath.row +1) stringValue]];
}

- (NSArray<UIGestureRecognizer*>*)gestureRecognizersForCell {
    UIGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    UIGestureRecognizer* longPresRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];

    return @[tapRecognizer, longPresRecognizer];
}

- (IBAction)cellTapped:(id)sender{
    UIGestureRecognizer* tapRecognizer = sender;
    MINSingleMiniDisplayCollectionViewCell* cell = (MINSingleMiniDisplayCollectionViewCell*)tapRecognizer.view;
    UIImage* image = cell.miniImage.image;
    
    MINMiniDetailViewController* vc = [[MINMiniDetailViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:vc animated:YES];
    }

- (IBAction)cellLongPressed:(id)sender{
    UIGestureRecognizer* longRecognizer = sender;
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        MINSingleMiniDisplayCollectionViewCell* cell = (MINSingleMiniDisplayCollectionViewCell*)longRecognizer.view;
        NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
        NSString* name = [self imageNameForIndexPath:indexPath];
        BOOL newOwned = ![self ownedStatusOf:name];
        [cell displayAsOwned:newOwned animated:YES];
        [self setOwnedStatus:newOwned miniName:name];
    }
}


- (BOOL)ownedStatusOf:(NSString*)miniName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:miniName];
}

- (void)setOwnedStatus:(BOOL)owned miniName:(NSString*)miniName {
    [[NSUserDefaults standardUserDefaults] setBool:owned forKey:miniName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
