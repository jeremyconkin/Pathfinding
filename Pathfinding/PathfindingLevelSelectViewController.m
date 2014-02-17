//
//  PathfindingLevelSelectViewController.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 2/7/14.
//  Copyright (c) 2014 Toeprint Interactive. All rights reserved.
//

#import "PathfindingLevelSelectViewController.h"

#import "PathfindingLevelSelectObject.h"
#import "PathfindingViewController.h"

@interface PathfindingLevelSelectViewController ()

@property (nonatomic,strong) NSMutableArray* mapsArray;

@end

@implementation PathfindingLevelSelectViewController

static NSString* LEVEL_SELECT_CELL_ID = @"levelSelectCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapsArray = [NSMutableArray new];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *bundleURL = [[NSBundle mainBundle] bundleURL];
    NSArray *contents = [fileManager contentsOfDirectoryAtURL:bundleURL
                                   includingPropertiesForKeys:@[]
                                                      options:NSDirectoryEnumerationSkipsHiddenFiles
                                                        error:nil];
    
    // Enumerate each bmp file
    static NSString* fileExtension = @"bmp";
    static NSString* predicateFormat;
    predicateFormat = [NSString stringWithFormat:@"pathExtension ENDSWITH '%@'", fileExtension];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    for (NSString *path in [contents filteredArrayUsingPredicate:predicate]) {
        NSString* filename = [[path lastPathComponent] stringByDeletingPathExtension];
        filename = [NSString stringWithFormat:@"%@.%@", filename, fileExtension];
        PathfindingLevelSelectObject* pathfindingObject = [[PathfindingLevelSelectObject alloc] initWithFilePath:filename];
        [self.mapsArray addObject:pathfindingObject];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mapsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PathfindingLevelSelectObject* levelSelectObject = (PathfindingLevelSelectObject*)[self.mapsArray objectAtIndex:indexPath.row];
    UIImageView* mapImage = [[UIImageView alloc] initWithImage:levelSelectObject.image];
    UICollectionViewCell* currentCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:LEVEL_SELECT_CELL_ID
                                                   forIndexPath:indexPath];
    
    [currentCell.contentView addSubview:mapImage];
    
    // Setup image constraints
    mapImage.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(mapImage);
    
    NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[mapImage]|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
    [currentCell.contentView addConstraints:horizontalConstraints];
    
    NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapImage]|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
    [currentCell.contentView addConstraints:verticalConstraints];
    
    return currentCell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* temp_jconkin = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    temp_jconkin.backgroundColor = [UIColor greenColor];
    return temp_jconkin;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PathfindingLevelSelectObject* levelSelectObject = (PathfindingLevelSelectObject*)[self.mapsArray objectAtIndex:indexPath.row];
    [self gotoMapScreenWithLevelSelectObject:levelSelectObject];
}

/**
 * Leave this screen for a map screen
 *
 * @param levelSelectObject Data that specifies the map to load
 */
- (void)gotoMapScreenWithLevelSelectObject:(PathfindingLevelSelectObject*)levelSelectObject
{
    // Determine iPad or iPhone
    UIUserInterfaceIdiom idiom = [[UIDevice currentDevice] userInterfaceIdiom];
    NSString* storyboardName = (idiom == UIUserInterfaceIdiomPad) ? @"Main_iPad" : @"Main_iPhone";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    PathfindingViewController* pathfindingViewController = (PathfindingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"PathfindingViewControllerID"];
    
    [pathfindingViewController presentSceneWithImage:levelSelectObject.image];
    
    [self presentViewController:pathfindingViewController animated:YES completion:Nil];
}

@end
