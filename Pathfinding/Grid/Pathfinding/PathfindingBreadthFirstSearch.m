//
//  PathfindingBreadthFirstSearch.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/8/13.
//

#import "PathfindingBreadthFirstSearch.h"

#import "PathfindingMapNode.h"

@interface PathfindingBreadthFirstSearch()

@property (nonatomic,strong) NSMutableArray* edgeStack;
@property (nonatomic,weak) PathfindingMapNode* startNode;
@property (nonatomic,weak) PathfindingMapNode* destinationNode;
@property (assign) NSInteger searchIdentifier;

@end

@implementation PathfindingBreadthFirstSearch

- (void)pathFromNode:(PathfindingMapNode*)fromNode
              toNode:(PathfindingMapNode*)toNode {

    self.edgeStack = [[NSMutableArray alloc] init];
    self.startNode = fromNode;
    self.destinationNode = toNode;
    
    // Create an edge to and from the starting node. Push it on the edge stack and process
    self.searchIdentifier = arc4random();
    PathfindingMapEdge* startingEdge = [[PathfindingMapEdge alloc] initWithMapNode:fromNode
                                                      withOtherMapNode:fromNode
                                                              withCost:0
                                                             withScene:nil];
    [self.edgeStack addObject:startingEdge];
    [self processEdge];
}

- (void)processEdge {
    
    if(self.edgeStack.count <= 0) {
        // Search failed
        return;
    }
    
    // Get the oldest edge off of the deque
    PathfindingMapEdge* edge = [self.edgeStack firstObject];
    [self.edgeStack removeObjectAtIndex:0];
    
    // Get the nodes
    PathfindingMapNode* node = edge.fromNode;
    PathfindingMapNode* otherNode = [edge otherNode:node];
    
    // Check it other node is destination
    if(otherNode == self.destinationNode)
    {// We made it to our destination
        otherNode.previousEdge = edge;
        [self completeSearch];
        return;
    }
    
    // If other node has not been checked, push all of it's other edges onto the stack
    if(otherNode.pathfindingSearchedId != self.searchIdentifier) {
        otherNode.previousEdge = edge;
        for (PathfindingMapEdge* otherEdge in otherNode.edges) {
            if(otherEdge != edge) {
                otherEdge.fromNode = otherNode;
                [self.edgeStack addObject:otherEdge];
            }
        }
    }
    
    // Mark the node as visited
    node.pathfindingSearchedId = self.searchIdentifier;
    [edge markSearched];
    
    [self performSelector:@selector(processEdge) withObject:nil afterDelay:PathfindingITERATION_DELAY];
}

- (void)completeSearch {
    // Highlight travel path
    PathfindingMapNode* currentNode = self.destinationNode;
    while (currentNode != self.startNode) {
        PathfindingMapEdge* edge = currentNode.previousEdge;
        [edge markPartOfPath];
        currentNode = [edge otherNode:currentNode];
        // Set next edge so we can traverse forwards
        currentNode.nextEdge = edge;
    }
}


@end
