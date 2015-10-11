//
//  MINSeriesOverviewTableViewController.m
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import "MINSeriesOverviewTableViewController.h"
#import "MINSingleMinisCollectionViewController.h"

@interface MiniSeriesNamePrefix : NSObject

@property (nonatomic, strong, readwrite) NSString* displayName;
@property (nonatomic, strong, readwrite) NSString* prefix;

- (instancetype)initWithPrefix:(NSString*)prefix displayName:(NSString*)displayName;

@end

@implementation MiniSeriesNamePrefix : NSObject

-(instancetype)initWithPrefix:(NSString *)prefix displayName:(NSString *)displayName {
    self = [super init];
    if (self) {
        _displayName = displayName;
        _prefix = prefix;
    }
    return self;
}

@end



@interface MINSeriesOverviewTableViewController ()

@property (nonatomic, strong, readwrite)NSArray<MiniSeriesNamePrefix *>* series;

@end

@implementation MINSeriesOverviewTableViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupArray];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupArray];
    }
    return self;
}


-(void)setupArray{
    self.series = @[
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"14" displayName:@"Series 14"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"simpsons2" displayName:@"The Simpsons II"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"simpsons" displayName:@"The Simpsons"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"theMovie" displayName:@"The Lego Movie"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"13" displayName:@"Series 13"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"12" displayName:@"Series 12"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"11" displayName:@"Series 11"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"10" displayName:@"Series 10"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"9" displayName:@"Series 9"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"8" displayName:@"Series 8"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"7" displayName:@"Series 7"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"6" displayName:@"Series 6"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"5" displayName:@"Series 5"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"4" displayName:@"Series 4"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"3" displayName:@"Series 3"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"2" displayName:@"Series 2"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"1" displayName:@"Series 1"],
                    
                    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.series.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"seriesCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.series[indexPath.row].displayName;
    NSString* imageName = [NSString stringWithFormat:@"%@-1.jpg", self.series[indexPath.row].prefix];
    cell.imageView.image = [self replaceColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f] inImage:[UIImage imageNamed:imageName] withTolerance:15.0];
    
    return cell;
}


- (UIImage*) replaceColor:(UIColor*)color inImage:(UIImage*)image withTolerance:(float)tolerance {
    CGImageRef imageRef = [image CGImage];

    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    NSUInteger bitmapByteCount = bytesPerRow * height;

    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));

    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);

    CGColorRef cgColor = [color CGColor];
    const CGFloat *components = CGColorGetComponents(cgColor);
    float r = components[0];
    float g = components[1];
    float b = components[2];
    //float a = components[3]; // not needed

    r = r * 255.0;
    g = g * 255.0;
    b = b * 255.0;

    const float redRange[2] = {
        MAX(r - (tolerance / 2.0), 0.0),
        MIN(r + (tolerance / 2.0), 255.0)
    };
    const float greenRange[2] = {
        MAX(g - (tolerance / 2.0), 0.0),
        MIN(g + (tolerance / 2.0), 255.0)
    };

    const float blueRange[2] = {
        MAX(b - (tolerance / 2.0), 0.0),
        MIN(b + (tolerance / 2.0), 255.0)
    };

    int byteIndex = 0;

    while (byteIndex < bitmapByteCount) {
        unsigned char red   = rawData[byteIndex];
        unsigned char green = rawData[byteIndex + 1];
        unsigned char blue  = rawData[byteIndex + 2];

        if (((red >= redRange[0]) && (red <= redRange[1])) &&
            ((green >= greenRange[0]) && (green <= greenRange[1])) &&
            ((blue >= blueRange[0]) && (blue <= blueRange[1]))) {
            // make the pixel transparent
            //
            rawData[byteIndex] = 0;
            rawData[byteIndex + 1] = 0;
            rawData[byteIndex + 2] = 0;
            rawData[byteIndex + 3] = 0;
        }

        byteIndex += 4;
    }

    CGImageRef imgref = CGBitmapContextCreateImage(context);
    UIImage *result = [UIImage imageWithCGImage:imgref];

    CGImageRelease(imgref);
    CGContextRelease(context);
    free(rawData);

    return result;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MINSingleMinisCollectionViewController* vc = [segue destinationViewController];
    UITableViewCell* cell = sender;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    vc.suggestedSeriesName = self.series[indexPath.row].prefix;
}


@end
