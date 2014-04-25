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
#import "PathfindingScene.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.height
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.width

@interface PathfindingGrid()

@property (strong,nonatomic) NSMutableArray* rows;
@property (assign) NSInteger numberOfRows;
@property (assign) NSInteger numberOfColumns;
@property (weak,nonatomic) PathfindingScene* scene;
@property (strong,nonatomic) NSMutableArray* mapData;
@property (strong,nonatomic) PathfindingMapNode* startingNode;
@property (strong,nonatomic) PathfindingMapNode* endingNode;
@property (assign,nonatomic) PathfindingAlgorithmIdentifier algorithmIdentifier;

@end

static const NSUInteger NODE_DENSITY = 16;

@implementation PathfindingGrid

- (id)initWithScene:(PathfindingScene*)scene
       withMapImage:(UIImage*)image {
    
    self = [super init];
    if(self) {
        self.scene = scene;
        
        [self parseMapIntoDataArrayWithImage:image];
    }
    
    return self;
}

- (void)setStartingNode:(PathfindingMapNode *)startingNode {
    _startingNode = startingNode;
}

- (void)setEndingNode:(PathfindingMapNode *)endingNode {
    _endingNode = endingNode;
    [self beginPathfinding];
}

- (void)setAlgorithmIdentifier:(PathfindingAlgorithmIdentifier)algorithmIdentifier {
    _algorithmIdentifier = algorithmIdentifier;
}

/**
 * Execute pathfinding algorithm
 */
- (void)beginPathfinding {
    NSAssert(self.startingNode != nil, @"Must have a start node to begin pathfinding");
    NSAssert(self.endingNode != nil, @"Must have an end node to begin pathfinding");
    
    Class pathfindingClass = [PathfindingGrid getPathfindingClassForIdentifier:self.algorithmIdentifier];
    id<PathfindingPathfinder> search = [[pathfindingClass alloc] init];
    [search  pathFromNode:self.startingNode
                   toNode:self.endingNode];
}

/**
 * Get a pathfinding class via an identifier
 *
 * @param identifier    Enum for a pathfinding algorithm
 * @return Class that implements PathfindingPathfinder
 */
+ (Class)getPathfindingClassForIdentifier:(PathfindingAlgorithmIdentifier)identifier {
    
    switch (identifier) {
        case PathfindingAlgorithm_DepthFirstSearch:
            return [PathfindingDepthFirstSearch class];
            break;
            
        case PathfindingAlgorithm_BreadthFirstSearch:
            return [PathfindingBreadthFirstSearch class];
            break;
            
        case PathfindingAlgorithm_Dijkstra:
            return [PathfindingDijkstraSearch class];
            break;
            
        case PathfindingAlgorithm_AStar:
            return [PathfindingAStarSearch class];
            break;
            
        default:
            return [PathfindingDepthFirstSearch class];
            break;
    }
}

- (PathfindingMapNode*)getMapNodeClosestToPoint:(CGPoint)searchPoint {
    
    CGFloat yPercentage = searchPoint.y / SCREEN_HEIGHT;
    NSUInteger yIndex = nearbyintf(self.mapData.count - (yPercentage * self.mapData.count));
    
    CGFloat xPercentage = searchPoint.x / SCREEN_WIDTH;
    NSArray *selectedRow = [self.mapData objectAtIndex:yIndex];
    NSUInteger xIndex = nearbyintf(xPercentage * selectedRow.count);
    
    return [selectedRow objectAtIndex:xIndex];
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
