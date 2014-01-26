//
//  PathfindingMapNode.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/4/13.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

#import "PathfindingMapEdge.h"

@interface PathfindingMapNode : SKShapeNode //todo_jconkin. Rename to PathNode?

- (id)initWithPosition:(CGPoint)position
             withScene:(SKScene*)scene
          withValidity:(BOOL)isValid;

- (void)addEdge:(PathfindingMapEdge*)edge;

@property (weak,nonatomic) SKScene* parentScene;
@property (strong,nonatomic) NSMutableArray* edges;

// From edge is used for pathfinding
@property (weak,nonatomic) PathfindingMapEdge* nextEdge;
@property (weak,nonatomic) PathfindingMapEdge* previousEdge;

// If the pathfinding algorithm is using this search id, this node has already been visited
@property (assign) NSInteger pathfindingSearchedId;

// The actual cost to reach this node
@property (assign) float costToReach;

// The estimated cost for this node to the destination node
@property (assign) float heuristicCostToDestination;

// Can a character travel to this node
@property (assign) BOOL isValid;

@end
