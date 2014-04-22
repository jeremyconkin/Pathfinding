//
//  PathfindingGrid.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/29/13.
//

#import "PathfindingGrid.h"

#import "PathfindingAStarSearch.h"
#import "PathfindingBreadthFirstSearch.h"
#import "PathfindingDepthFirstSearch.h"
#import "PathfindingDijkstraSearch.h"
#import "PathfindingMapEdge.h"
#import "PathfindingMapNode.h"
#import "PathfindingScene.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.height
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.width

@interface PathfindingGrid()

@property (strong,nonatomic) NSMutableArray* rows;
@property (assign) NSInteger numberOfRows;
@property (assign) NSInteger numberOfColumns;
@property (weak,nonatomic) PathfindingScene* scene;
@property (strong,nonatomic) NSMutableArray* mapData;

@end

static const NSUInteger NODE_DENSITY = 16;

@implementation PathfindingGrid

- (id)initWithScene:(PathfindingScene*)scene
       withMapImage:(UIImage*)image {
    
    self = [super init];
    if(self) {
        self.scene = scene;
        
        [self parseMapIntoDataArrayWithImage:image];
        
        // Hard-coded pathfinding example
        id<PathfindingPathfinder> search = [[PathfindingAStarSearch alloc] init];
        NSArray *startingRow = [self.mapData objectAtIndex:5];
        NSArray *finishingRow = [self.mapData objectAtIndex:10];
        PathfindingMapNode* nodeA = [startingRow objectAtIndex:10];
        PathfindingMapNode* nodeB = [finishingRow objectAtIndex:20];
        nodeB.fillColor = [UIColor purpleColor];
        [search  pathFromNode:nodeA
                       toNode:nodeB];
    }
    
    return self;
}

/**
 * Create a grid of nodes using pixel data to determine if a node
 * is traversable
 *
 * @param image Image used to make the map
 */
- (void)parseMapIntoDataArrayWithImage:(UIImage*)image {
    
    self.mapData = [[NSMutableArray alloc] init];
    
    // Create a data buffer holding the map image data
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    static const NSUInteger bytesPerPixel = 4;
    unsigned char *rawData = malloc(height * width * bytesPerPixel);
    NSUInteger bytesPerRow = bytesPerPixel * width;
    static const NSUInteger bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    CGFloat widthSpacing = SCREEN_WIDTH/width;
    CGFloat heightSpacing = SCREEN_HEIGHT/height;
    // rawData now contains the image data in the RGBA8888 pixel format.
    // Create a double array of nodes in the format array[columns][rows]. Bottom left origin.
    for (NSUInteger row = 0; row < height; row += NODE_DENSITY) {
        
        NSUInteger byteIndexOfRow = (bytesPerRow*row);
        NSMutableArray *rowNodesArray = [[NSMutableArray alloc] init];
        for (NSUInteger column = 0; column < width; column += NODE_DENSITY) {
            
            NSUInteger arrayOffset = byteIndexOfRow + (column * bytesPerPixel);
            NSUInteger redGreenBlue = rawData[arrayOffset] + rawData[arrayOffset+1] + rawData[arrayOffset+2];
            // Image buffer is y down coordinate space and sprite node is y up.
            // Therefore, the current row is found via (row+currentRow) = height => currentRow = (height-row)
            PathfindingMapNode* node = [[PathfindingMapNode alloc] initWithPosition:CGPointMake(column * widthSpacing, (height-row) * heightSpacing)
                                                                          withScene:self.scene
                                                                       withValidity:(redGreenBlue > 0)];
            [rowNodesArray addObject:node];
        }
        [self.mapData addObject:rowNodesArray];
    }
    
    [self createEdges];
}

- (void)createEdges {
    
    static const float diagonalCost = 1.4f; // Diagonal distance if edges are both distance of 1
    for (NSUInteger i = 0; i < self.mapData.count; ++i) {

        NSArray *rowData = [self.mapData objectAtIndex:i];
        BOOL notLastRow = (i < (self.mapData.count - 1));

        if (notLastRow) {
            NSArray *nextRow = [self.mapData objectAtIndex:i+1];
            
            // Add upward edges
            for (NSUInteger j = 0; j < rowData.count; ++j) {
                [self addBidirectionalEdgeFromNode:[rowData objectAtIndex:j]
                                            toNode:[nextRow objectAtIndex:j]
                                          withCost:1.f];
            }
            
            // Upper right diagonals
            for (NSUInteger j = 0; j < rowData.count-1; ++j) {
                [self addBidirectionalEdgeFromNode:[rowData objectAtIndex:j]
                                            toNode:[nextRow objectAtIndex:j+1]
                                          withCost:diagonalCost];
            }
            
            // Upper left diagonals
            for (NSUInteger j = 1; j < rowData.count; ++j) {
                [self addBidirectionalEdgeFromNode:[rowData objectAtIndex:j]
                                            toNode:[nextRow objectAtIndex:j-1]
                                          withCost:diagonalCost];
            }
        }
        
        // Add right edges
        for (NSUInteger j = 0; j < rowData.count-1; ++j) {
            [self addBidirectionalEdgeFromNode:[rowData objectAtIndex:j]
                                        toNode:[rowData objectAtIndex:j+1]
                                      withCost:1.f];
        }
    }
}

- (void)addBidirectionalEdgeFromNode:(PathfindingMapNode *)nodeA
                              toNode:(PathfindingMapNode *)nodeB
                            withCost:(float)cost {
    
    if (nodeA.isValid && nodeB.isValid) {
        PathfindingMapEdge* edge = [[PathfindingMapEdge alloc] initWithMapNode:nodeA
                                                              withOtherMapNode:nodeB
                                                                      withCost:cost];
        [edge setScene:self.scene];
    }
}

@end
