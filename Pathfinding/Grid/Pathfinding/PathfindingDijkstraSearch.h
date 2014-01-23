//
//  PathfindingDijkstraSearch.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/28/13.
//

#import <Foundation/Foundation.h>

#import "PathfindingPathfinder.h"

@interface PathfindingDijkstraSearch : NSObject <PathfindingPathfinder>

@property (nonatomic,weak) PathfindingMapNode* destinationNode;

@end
