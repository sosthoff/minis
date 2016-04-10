//
//  MINSeriesOverviewTableViewController.m
//  minis
//
//  Created by Sebastian Osthoff on 11/10/15.
//  Copyright © 2015 Sebastian Osthoff. All rights reserved.
//

#import "MINSeriesOverviewTableViewController.h"
#import "MINSingleMinisCollectionViewController.h"
#import "UIImage+Voodoo.h"

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


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)setupArray{
    self.series = @[
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"disney" displayName:@"Disney"],
                    [[MiniSeriesNamePrefix alloc] initWithPrefix:@"15" displayName:@"Series 15"],
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
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MINSingleMinisCollectionViewController* vc = [segue destinationViewController];
    UITableViewCell* cell = sender;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    vc.suggestedSeriesName = self.series[indexPath.row].prefix;
}


@end
