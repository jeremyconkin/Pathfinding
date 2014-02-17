//
//  PathfindingScene.h
//  Pathfinding
//  Created by Jeremy Conkin on 7/7/13.
//

#import <SpriteKit/SpriteKit.h>

@interface PathfindingScene : SKScene

/**
 * Load a map file with an image terrain map
 *
 * @param image Image to define the map borders
 */
- (void)createGridWithImage:(UIImage*)image;

@end
