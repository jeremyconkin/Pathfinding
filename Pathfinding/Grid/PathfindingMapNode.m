//
//  PathfindingMapNode.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/4/13.
//

#import "PathfindingMapNode.h"

@implementation PathfindingMapNode

- (id)initWithPosition:(CGPoint)position
             withScene:(SKScene*)scene
          withValidity:(BOOL)isValid {
    self = [super init];
    if(self) {
        self.position = position;
        self.parentScene = scene;
        self.isValid = isValid;
        self.edges = [[NSMutableArray alloc] init];
        self.fillColor = isValid ? [SKColor greenColor] : [SKColor redColor];
        self.lineWidth = 0.f;
        
        [self createPath];
        [self drawDebug];
    }
    
    return self;
}

- (void)addEdge:(PathfindingMapEdge*)edge {
    [self.edges addObject:edge];
}

- (void)setNextEdge:(PathfindingMapEdge*) nextEdge {
    NSAssert([self.edges containsObject:nextEdge], @"Next edge must be an edge of this node");
    _nextEdge = nextEdge;
}

- (void)setPreviousEdge:(PathfindingMapEdge*) previousEdge {
    NSAssert([self.edges containsObject:previousEdge], @"Previous edge must be an edge of this node");
    _previousEdge = previousEdge;
}

- (void)createPath {
    CGMutablePathRef path = CGPathCreateMutable();
    static const CGFloat radius = 2.f;
    CGPathAddArc(path, nil, 0.f, 0.f, radius, -M_PI_2, M_PI_2*3, NO);
    self.path = path;
}

- (void)drawDebug {
    [self.parentScene addChild:self];
}

@end
