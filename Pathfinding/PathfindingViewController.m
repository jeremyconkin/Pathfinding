//
//  PathfindingViewController.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/14/13.
//

#import "PathfindingViewController.h"
#import "PathfindingScene.h"

@implementation PathfindingViewController

- (void)presentSceneWithImage:(UIImage*)image {
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    // Flip these for debugging
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene. Flip width and height because we're in landscape only.
    PathfindingScene* scene = [PathfindingScene sceneWithSize:CGSizeMake(skView.bounds.size.height, skView.bounds.size.width)];
    [scene createGridWithImage:image];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
