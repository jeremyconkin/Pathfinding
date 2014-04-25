//
//  PathfindingGrid.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/29/13.
//

#import "PathfindingMapNode.h"

#import "PathfindingGrid.h"

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

@end
