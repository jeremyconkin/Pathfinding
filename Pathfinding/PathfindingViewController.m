//
//  PathfindingViewController.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/14/13.
//

#import "PathfindingViewController.h"

#import "PathfindingGrid.h"
#import "PathfindingScene.h"

typedef enum {
    PathfindingState_None,
    PathfindingState_SelectStartNode,
    PathfindingState_SelectFinishNode,
    PathfindingState_SelectAlgorithm,
    PathfindingState_Navigating,
    PathfindingState_Max
    
} PathfindingState;

@interface PathfindingViewController ()<PathfindingSceneDelegate, UIActionSheetDelegate>

/** Label giving instructions to the user */
@property (strong, nonatomic) UILabel *instructionsLabel;

/** What is this view controller currently doing? */
@property (assign, nonatomic) PathfindingState pathfindingState;

/** Scene containing the nodes and edges. It executes its own pathfinding algorightm. */
@property (strong, nonatomic) PathfindingScene* pathfindingScene;

@end

@implementation PathfindingViewController

- (void)presentSceneWithImage:(UIImage*)image {
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    // Flip these for debugging
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene. Flip width and height because we're in landscape only.
    self.pathfindingScene = [PathfindingScene sceneWithSize:CGSizeMake(skView.bounds.size.height, skView.bounds.size.width)];
    [self.pathfindingScene createGridWithImage:image];
    self.pathfindingScene.delegate = self;
    self.pathfindingScene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:self.pathfindingScene];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self addInstructionsLabel];
    self.pathfindingState = PathfindingState_SelectAlgorithm;
}

/**
 Create and add a label that tells the user what to do
 */
- (void)addInstructionsLabel {
    if (self.instructionsLabel) {
        [self.instructionsLabel removeFromSuperview];
    }
    self.instructionsLabel = [UILabel new];
    self.instructionsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.instructionsLabel];

    // Add constraints
    NSDictionary *viewsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:self.instructionsLabel, @"instructionsLabel", nil];
    
    NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[instructionsLabel]|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
    [self.view addConstraints:horizontalConstraints];
    NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[instructionsLabel(==30)]" options:NSLayoutFormatAlignAllBaseline metrics:nil views:viewsDictionary];
    [self.view addConstraints:verticalConstraints];
    
    // Label text formatting
    self.instructionsLabel.textAlignment = NSTextAlignmentCenter;
    self.instructionsLabel.textColor = [UIColor blackColor];
    self.instructionsLabel.font = [UIFont boldSystemFontOfSize:24];
}

- (void)setPathfindingState:(PathfindingState)pathfindingState {
    _pathfindingState = pathfindingState;
    
    switch (_pathfindingState) {
        case PathfindingState_SelectStartNode: {
                self.instructionsLabel.text = @"Select Starting Node";
                self.pathfindingScene.gridState = GridTapListeningState_StartingNode;
            }
            break;
            
        case PathfindingState_SelectFinishNode: {
                self.instructionsLabel.text = @"Select Ending Node";
                self.pathfindingScene.gridState = GridTapListeningState_EndingNode;
            }
            break;
            
        case PathfindingState_SelectAlgorithm: {
            self.instructionsLabel.text = @"Select Algorithm";
            UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Algorithm"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:nil];
            for (NSUInteger i = 0; i < PathfindingAlgorithm_Max; ++i) {
                [popup addButtonWithTitle:[self getNameForAlgorithm:(PathfindingAlgorithmIdentifier)i]];
            }
            [popup showInView:self.view];
        }
            break;
            
        default:
            break;
    }
}

- (NSString*)getNameForAlgorithm:(PathfindingAlgorithmIdentifier)algorithmIdentifier {
    
    NSString* returnValue = @"";
    
    switch (algorithmIdentifier) {
        case PathfindingAlgorithm_BreadthFirstSearch:
            returnValue = @"Breadth First Search";
            break;
            
        case PathfindingAlgorithm_DepthFirstSearch:
            returnValue = @"Depth First Search";
            break;
            
        case PathfindingAlgorithm_Dijkstra:
            returnValue = @"Dijkstra's";
            break;
            
        case PathfindingAlgorithm_AStar:
            returnValue = @"A-Star";
            break;
            
        default:
            break;
    }
    
    return returnValue;
}

#pragma mark - PathfindingSceneDelegate

- (void)didSelectStartingNode {
    self.pathfindingState = PathfindingState_SelectFinishNode;
}

- (void)didSelectEndingNode {
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    [self.pathfindingScene setAlgorithmIdentifier:(PathfindingAlgorithmIdentifier)buttonIndex];
    self.pathfindingState = PathfindingState_SelectStartNode;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
