//
//  PathfindingViewController.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/14/13.
//

#import "PathfindingViewController.h"
#import "PathfindingScene.h"

@interface PathfindingViewController ()

/** Label giving instructions to the user */
@property (strong, nonatomic) UILabel *instructionsLabel;

@end

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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self addInstructionsLabel];
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
    self.instructionsLabel.textColor = [UIColor darkGrayColor];
    self.instructionsLabel.font = [UIFont boldSystemFontOfSize:24];
    self.instructionsLabel.text = @"temp_jconkin";
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
