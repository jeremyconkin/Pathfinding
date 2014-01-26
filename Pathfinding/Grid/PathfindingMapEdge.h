//
//  PathfindingMapEdge.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/4/13.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@class PathfindingMapNode;

@interface PathfindingMapEdge : SKShapeNode

- (id)initWithMapNode:(PathfindingMapNode*)nodeA
     withOtherMapNode:(PathfindingMapNode*)nodeB
             withCost:(float)cost
            withScene:(SKScene*)scene;

- (void)markSearched;
- (void)markPartOfPath;

@property (assign,nonatomic,readonly) float cost;
//todo_jconkin. Consider a singleton.
@property (weak,nonatomic) SKScene* parentScene;

- (BOOL)edgeTouchesNode:(PathfindingMapNode*)node;
- (PathfindingMapNode*)otherNode:(PathfindingMapNode*)fromNode;

// From node is used for pathfinding
@property (weak,nonatomic) PathfindingMapNode* fromNode;

@end
