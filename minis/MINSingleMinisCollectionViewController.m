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

@interface MINSingleMinisCollectionViewController ()

@property (nonatomic, strong, readwrite) UIBarButtonItem* rightButton;
@property (nonatomic, assign, readwrite) BOOL isViewModeDiscover;

@end

@implementation MINSingleMinisCollectionViewController

static NSString * const reuseIdentifier = @"miniCell";


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"Collection" style:UIBarButtonItemStylePlain target:self action:@selector(switchViewMode:)];
        _rightButton = item;
        [self.navigationItem setRightBarButtonItem:item];
    }
    return self;
}

- (IBAction)switchViewMode:(id)sender {
    if (self.isViewModeDiscover) {
        self.isViewModeDiscover = NO;
        self.rightButton.title = @"Collection";
    } else {
        self.isViewModeDiscover = YES;
        self.rightButton.title = @"Discover";
    }
            [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MINSingleMiniDisplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    NSString* imageName = [self imageNameForIndexPath:indexPath];
    UIImage* image = [UIImage imageNamed:imageName];
    cell.miniImage.image = image;
    
//    image = [self replaceColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] inImage:image withTolerance:15.0];
    UIImage* greyImage = [self convertImageToGrayScale:image];
    cell.greyImage.image = greyImage;
    cell.gestureRecognizers = [self gestureRecognizersForCell];
    BOOL owned = [self ownedStatuesOf:imageName];
    if (self.isViewModeDiscover) {
        owned = YES;
    }
    [cell displayAsOwned:owned animated:YES];
    
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
        BOOL newOwned = ![self ownedStatuesOf:name];
        [cell displayAsOwned:newOwned animated:YES];
        [self setOwnedStatus:newOwned miniName:name];
    }
}


- (BOOL)ownedStatuesOf:(NSString*)miniName {
    return [[NSUserDefaults standardUserDefaults] boolForKey:miniName];
}

- (void)setOwnedStatus:(BOOL)owned miniName:(NSString*)miniName {
    [[NSUserDefaults standardUserDefaults] setBool:owned forKey:miniName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}





//- (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance {
//    CGImageRef imageRef = [image CGImage];
//    
//    NSUInteger width = CGImageGetWidth(imageRef);
//    NSUInteger height = CGImageGetHeight(imageRef);
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    NSUInteger bytesPerPixel = 4;
//    NSUInteger bytesPerRow = bytesPerPixel * width;
//    NSUInteger bitsPerComponent = 8;
//    NSUInteger bitmapByteCount = bytesPerRow * height;
//    
//    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
//    
//    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
//                                                 bitsPerComponent, bytesPerRow, colorSpace,
//                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//    CGColorSpaceRelease(colorSpace);
//    
//    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
//    
//    CGColorRef cgColor = [color CGColor];
//    const CGFloat *components = CGColorGetComponents(cgColor);
//    float r = components[0];
//    float g = components[1];
//    float b = components[2];
//    //float a = components[3]; // not needed
//    
//    r = r * 255.0;
//    g = g * 255.0;
//    b = b * 255.0;
//    
//    const float redRange[2] = {
//        MAX(r - (tolerance / 2.0), 0.0),
//        MIN(r + (tolerance / 2.0), 255.0)
//    };
//    const float greenRange[2] = {
//        MAX(g - (tolerance / 2.0), 0.0),
//        MIN(g + (tolerance / 2.0), 255.0)
//    };
//    
//    const float blueRange[2] = {
//        MAX(b - (tolerance / 2.0), 0.0),
//        MIN(b + (tolerance / 2.0), 255.0)
//    };
//    
//    int byteIndex = 0;
//    
//    while (byteIndex < bitmapByteCount) {
//        unsigned char red   = rawData[byteIndex];
//        unsigned char green = rawData[byteIndex + 1];
//        unsigned char blue  = rawData[byteIndex + 2];
//        
//        if (((red >= redRange[0]) && (red <= redRange[1])) &&
//            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
//            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
//            // make the pixel transparent
//            //
//            rawData[byteIndex] = 0;
//            rawData[byteIndex + 1] = 0;
//            rawData[byteIndex + 2] = 0;
//            rawData[byteIndex + 3] = 0;
//        }
//        
//        byteIndex += 4;
//    }
//    
//    CGImageRef imgref = CGBitmapContextCreateImage(context);
//    UIImage *result = [UIImage imageWithCGImage:imgref];
//    
//    CGImageRelease(imgref);
//    CGContextRelease(context);
//    free(rawData);
//    
//    return result;
//}


@end
