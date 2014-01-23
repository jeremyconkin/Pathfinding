//
//  PathfindingDepthFirstSearch.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/7/13.
//

#import "PathfindingDepthFirstSearch.h"

#import "PathfindingMapNode.h"

@interface PathfindingDepthFirstSearch()

@property (nonatomic,strong) NSMutableArray* edgeStack;
@property (nonatomic,weak) PathfindingMapNode* startNode;
@property (nonatomic,weak) PathfindingMapNode* destinationNode;
@property (assign) NSInteger searchIdentifier;

@end

@implementation PathfindingDepthFirstSearch

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
    startingEdge.fromNode = fromNode;
    [self.edgeStack addObject:startingEdge];
    [self processEdge];
}

- (void)processEdge {
    
    if(self.edgeStack.count <= 0) {
        // Search failed
        return;
    }
    
    PathfindingMapEdge* edge = [self.edgeStack lastObject];
    [self.edgeStack removeLastObject];
    
    // Get the nodes
    PathfindingMapNode* node = edge.fromNode;
    PathfindingMapNode* otherNode = [edge otherNode:node];
    
    // Set the next edge
    node.nextEdge = edge;
    [edge markSearched];
    
    // If next node is destination, winsauce
    if(otherNode == self.destinationNode)
    {// We made it to our destination
        edge.fromNode = node;
        [self completeSearch];
        return;
    }
    
    // If next node is visited, exit
    if(otherNode.pathfindingSearchedId == self.searchIdentifier) {
        [self processEdge];
        return;
    }
    
    // Mark the node as visited
    node.pathfindingSearchedId = self.searchIdentifier;
    
    // Add all the new edges
    for (PathfindingMapEdge* otherEdge in otherNode.edges) {
        if(otherEdge != edge) {
            otherEdge.fromNode = otherNode;
            [self.edgeStack addObject:otherEdge];
        }
    }
    
    // Try another edge
    [self performSelector:@selector(processEdge) withObject:nil afterDelay:PathfindingITERATION_DELAY];
}

- (void)completeSearch {
    // Highlight travel path
    PathfindingMapNode* currentNode = self.startNode;
    while (currentNode != self.destinationNode) {
        [currentNode.nextEdge markPartOfPath];
        currentNode = [currentNode.nextEdge otherNode:currentNode];
    }
}


@end
