//
//  PathfindingGrid.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/29/13.
//

#import <Foundation/Foundation.h>

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

@end
