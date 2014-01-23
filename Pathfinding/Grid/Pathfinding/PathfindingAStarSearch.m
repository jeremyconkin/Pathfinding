//
//  PathfindingAStarSearch.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/28/13.
//

#import "PathfindingAStarSearch.h"

#import "PathfindingMapNode.h"

@implementation PathfindingAStarSearch

- (CGFloat)heuristicCostForNode:(PathfindingMapNode*)node {
    // Use Euclidean distance for heuristic cost
    CGFloat xDistance = ABS(self.destinationNode.position.x - node.position.x);
    CGFloat yDistance = ABS(self.destinationNode.position.y - node.position.y);
    
    CGFloat returnVal = (xDistance + yDistance) * 0.1f;
    
    return returnVal;
}

@end
