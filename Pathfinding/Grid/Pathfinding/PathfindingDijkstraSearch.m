//
//  PathfindingDijkstraSearch.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/28/13.
//

#import "PathfindingDijkstraSearch.h"

#import "PathfindingMapNode.h"

@interface PathfindingDijkstraSearch()

@property (nonatomic,strong) NSMutableArray* edgeStack;
@property (nonatomic,strong) NSMutableArray* searchFrontier;
@property (nonatomic,weak) PathfindingMapNode* startNode;
@property (assign) NSInteger searchIdentifier;

@end

@implementation PathfindingDijkstraSearch

- (void)pathFromNode:(PathfindingMapNode*)fromNode
              toNode:(PathfindingMapNode*)toNode {
    
    self.searchIdentifier = arc4random();//temp_jconkin. Could make this a static value that increments. Then no dupes.
    self.startNode = fromNode;
    self.destinationNode = toNode;
    self.searchFrontier = [[NSMutableArray alloc] init];
    [self.searchFrontier addObject:fromNode];
    PathfindingMapEdge* startingEdge = [[PathfindingMapEdge alloc] initWithMapNode:fromNode
                                                      withOtherMapNode:fromNode
                                                              withCost:0
                                                             withScene:nil];
    fromNode.previousEdge = startingEdge;
    
    [self processNode:fromNode];
}

- (void)processNode:(PathfindingMapNode*)node {
    
    if(node == self.destinationNode) {
        // Success!
        [self completeSearch];
        return;
    }
    
    // Mark the node as having its shortest path determined
    [self.searchFrontier removeObjectIdenticalTo:node];
    node.pathfindingSearchedId = self.searchIdentifier;
    
    for (PathfindingMapEdge* edge in node.edges) {
        PathfindingMapNode* otherNode = [edge otherNode:node];
        
        // Add to search frontier if necessary
        if((otherNode.pathfindingSearchedId != self.searchIdentifier) // Hasn't been marked complete
           && (![self.searchFrontier containsObject:otherNode]) // Isn't already in the search frontier
        ) {
            otherNode.costToReach = NSIntegerMax;
            otherNode.heuristicCostToDestination = [self heuristicCostForNode:otherNode];
            [self.searchFrontier addObject:otherNode];
        }
        
        // New cost is cost to this destination plus edge cost
        NSInteger costToReachOtherNodeFromHere = node.costToReach + edge.cost;
        if(otherNode.costToReach > costToReachOtherNodeFromHere) {
            otherNode.costToReach = costToReachOtherNodeFromHere;
            otherNode.previousEdge = edge;
        }
    }
    
    [self sortTheFrontier];
    
    if (self.searchFrontier.count == 0) {
        // Unreachable
        return;
    }
    
    // Process cheapest node
    PathfindingMapNode* nextNode = [self.searchFrontier objectAtIndex:0];
    [nextNode.previousEdge markSearched];
    [self performSelector:@selector(processNode:) withObject:nextNode afterDelay:PathfindingITERATION_DELAY];
}

- (void)completeSearch {
    // Set the search path
    PathfindingMapNode* node = self.destinationNode;
    while (node != self.startNode) {
        [node.previousEdge markPartOfPath];
        PathfindingMapNode* previousNode = [node.previousEdge otherNode:node];
        
        // Set next edge so we can travel forwards
        previousNode.nextEdge = node.previousEdge;
        node = previousNode;
    }
}

- (void)sortTheFrontier {
    [self.searchFrontier sortUsingComparator:
     ^NSComparisonResult(id obj1, id obj2){
         
         PathfindingMapNode *nodeA = (PathfindingMapNode*)obj1;
         PathfindingMapNode *nodeB = (PathfindingMapNode*)obj2;
         return ((nodeA.costToReach + nodeA.heuristicCostToDestination) > (nodeB.costToReach + nodeB.heuristicCostToDestination)) ?
             (NSComparisonResult)NSOrderedDescending :
             (NSComparisonResult)NSOrderedAscending;
     }
     ];
}

- (CGFloat)heuristicCostForNode:(PathfindingMapNode*)node {
    return 0.f;
}

@end
