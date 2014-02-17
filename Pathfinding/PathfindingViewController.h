//
//  PathfindingViewController.h
//  Pathfinding
//

//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface PathfindingViewController : UIViewController

/**
 * Load a map file with an image terrain map
 *
 * @param image Image to define the map borders
 */
- (void)presentSceneWithImage:(UIImage*)image;

@end
