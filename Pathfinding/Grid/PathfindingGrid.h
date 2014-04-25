//
//  PathfindingGrid.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/29/13.
//

#import "PathfindingMapNode.h"

#import "PathfindingGrid.h"

typedef enum {
    PathfindingAlgorithm_DepthFirstSearch,
    PathfindingAlgorithm_BreadthFirstSearch,
    PathfindingAlgorithm_Dijkstra,
    PathfindingAlgorithm_AStar,
    PathfindingAlgorithm_Max
}PathfindingAlgorithmIdentifier;

@class PathfindingScene;

@interface PathfindingGrid : NSObject

/**
 * Create the map and show it
 *
 * @param scene The scene that holds the grid
 * @param image Image that makes the map
 */
- (id)initWithScene:(PathfindingScene*)scene
       withMapImage:(UIImage*)image;

/**
 * Find the map node on the grid at the location closest to the give point
 *
 * @param searchPoint   Place where we search for a node
 *
 * @return  The map node
 */
- (PathfindingMapNode*)getMapNodeClosestToPoint:(CGPoint)searchPoint;

/**
 * Set the pathfinding node where the navigation begins
 *
 * @param startingNode  Pathfinding node where navigation starts
 */
- (void)setStartingNode:(PathfindingMapNode *)startingNode;

/**
 * Set the pathfinding node where the pathing ends
 *
 * @param startingNode  Pathfinding node where pathfinding ends
 */
- (void)setEndingNode:(PathfindingMapNode *)endingNode;

/**
 * Set the pathfinding algorithm to use
 *
 * @param algorithmIdentifier Enum for the algorithm to use
 */
- (void)setAlgorithmIdentifier:(PathfindingAlgorithmIdentifier)algorithmIdentifier;

@end
