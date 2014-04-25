//
//  PathfindingScene.h
//  Pathfinding
//  Created by Jeremy Conkin on 7/7/13.
//

#import "PathfindingGrid.h"

/** Protocol to receive callbacks from the pathfinding scene */
@protocol PathfindingSceneDelegate <NSObject>

@required
/**
 * Callback once the starting node is chosen
 */
- (void)didSelectStartingNode;

/**
 * Callback once the ending node is chosen
 */
- (void)didSelectEndingNode;

@end

typedef enum {
    GridTapListeningState_None,
    GridTapListeningState_StartingNode,
    GridTapListeningState_EndingNode,
    GridTapListeningState_Max
}GridTapListeningState;

@interface PathfindingScene : SKScene

/**
 * Load a map file with an image terrain map
 *
 * @param image Image to define the map borders
 */
- (void)createGridWithImage:(UIImage*)image;

/**
 * Set the pathfinding algorithm for the grid to use
 *
 * @param algorithmIdentifier Enum for the algorithm to use
 */
- (void)setAlgorithmIdentifier:(PathfindingAlgorithmIdentifier)algorithmIdentifier;

/** State for how this grid view responds when tapped */
@property (assign, nonatomic) GridTapListeningState gridState;

/** Delegate to receive callbacks */
@property (weak, nonatomic) id<PathfindingSceneDelegate> delegate;

@end
