//
//  PathfindingGrid.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/29/13.
//

#import "PathfindingGrid.h"

#import "PathfindingAStarSearch.h"
#import "PathfindingBaseCharacter.h"
#import "PathfindingBreadthFirstSearch.h"
#import "PathfindingDepthFirstSearch.h"
#import "PathfindingDijkstraSearch.h"
#import "PathfindingGridCell.h"
#import "PathfindingMapEdge.h"
#import "PathfindingMapNode.h"

@interface PathfindingGrid()

@property (strong,nonatomic) NSMutableArray* rows;
@property (assign) NSInteger numberOfRows;
@property (assign) NSInteger numberOfColumns;
@property (weak,nonatomic) PathfindingScene* scene;

@end


@implementation PathfindingGrid

- (id)initWithScene:(PathfindingScene*)scene
        withRows:(NSInteger)rows
        withColumns:(NSInteger)columns {
    
    self = [super init];
    if(self) {
        self.scene = scene;
        self.numberOfRows = rows;
        self.numberOfColumns = columns;
        [self createGrid];
    }
    
    return self;
}

- (void)createGrid {
    CGFloat const rowHeight = 30.f;
    CGFloat const columnWidth = 50.f;
    
    self.rows = [[NSMutableArray alloc] init];
    for(NSUInteger i = 0; i < self.numberOfRows; ++i) {
        NSMutableArray* row = [NSMutableArray arrayWithCapacity:self.numberOfColumns];
        for(NSUInteger j = 0; j < self.numberOfColumns; ++j) {
            PathfindingGridCell* cell = [[PathfindingGridCell alloc] initWithLocation:CGPointMake(j*columnWidth + 20, i*rowHeight + 230.f)
                                                                  andSize:CGSizeMake(columnWidth,rowHeight)
                                                                 andScene:self.scene];
            [row addObject:cell];
        }
        [self.rows addObject:row];
    }
    
    NSString *mapFilePath = [[NSBundle mainBundle] pathForResource:@"PathfindingMapB" ofType:@"plist"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithContentsOfFile:mapFilePath];
    NSMutableDictionary* nodesDict = [[NSMutableDictionary alloc] init];
    
    // Parse the nodes
    NSEnumerator *nodeEnumerator = [[mapData objectForKey:@"Nodes"] objectEnumerator];
    id value;
    while (value = [nodeEnumerator nextObject]) {
        NSInteger X = [[value valueForKey:@"X"] intValue];
        NSInteger Y = [[value valueForKey:@"Y"] intValue];
        PathfindingMapNode* node = [[PathfindingMapNode alloc] initWithPosition:CGPointMake(X,Y)
                                                          withScene:self.scene];
        node.name = [value objectForKey:@"Name"];
        [nodesDict setValue:node
                      forKey:node.name];
    }
    
    // Parse the edges
    NSEnumerator *edgeEnumerator = [[mapData objectForKey:@"Edges"] objectEnumerator];
    while (value = [edgeEnumerator nextObject]) {
        PathfindingMapNode* nodeA = [nodesDict objectForKey:[value valueForKey:@"NodeA"]];
        PathfindingMapNode* nodeB = [nodesDict objectForKey:[value valueForKey:@"NodeB"]];
        NSInteger cost = [[value valueForKey:@"Cost"] intValue];
        PathfindingMapEdge* edge = [[PathfindingMapEdge alloc] initWithMapNode:nodeA
                                                  withOtherMapNode:nodeB
                                                          withCost:cost
                                                         withScene:self.scene];
        edge.name = [value valueForKey:@"Name"];
    }

    PathfindingAStarSearch* search = [[PathfindingAStarSearch alloc] init];
    PathfindingMapNode* nodeA = [nodesDict objectForKey:@"F8"];
    [search  pathFromNode:nodeA
                   toNode:[nodesDict objectForKey:@"C8"]];
}

- (void)addCharacter:(PathfindingBaseCharacter*)character
               atRow:(NSInteger)row
            atColumn:(NSInteger)column {
    
    SKSpriteNode* spriteNode = [character spriteNode];
    
    spriteNode.position = [self locationForCellAtRow:row
                                            atColumn:column];
    
    [self.scene addChild:spriteNode];
}

- (CGPoint)zeroXForRow:(NSInteger)row {
   return [self locationForCellAtRow:row
                            atColumn:0];
}

- (CGPoint)locationForCellAtRow:(CGFloat)row
                       atColumn:(CGFloat)column {
    PathfindingGridCell* cell = [[self.rows objectAtIndex:row] objectAtIndex:column];
    return cell.location;
}

@end
