//
//  PathfindingMapEdge.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 7/4/13.
//

#import "PathfindingMapEdge.h"

#import "PathfindingMapNode.h"

@interface PathfindingMapEdge()

@property (weak,nonatomic) PathfindingMapNode* nodeA;
@property (weak,nonatomic) PathfindingMapNode* nodeB;
@property (assign,nonatomic) float cost;

@end


@implementation PathfindingMapEdge

- (id)initWithMapNode:(PathfindingMapNode*)nodeA
     withOtherMapNode:(PathfindingMapNode*)nodeB
             withCost:(float)cost {
    self = [super init];
    
    if(self) {
        self.nodeA = nodeA;
        self.nodeB = nodeB;
        self.cost = cost;
        
        // Add the edges to the nodes. (bi-directional)
        [nodeA addEdge:self];
        [nodeB addEdge:self];
        
        self.hidden = YES;
        self.lineWidth = 0.75f;
        self.glowWidth = 0.f;
        self.antialiased = NO;
        
        [self createPath];
    }

    return self;
}

- (void)setScene:(SKScene *)scene {
    
    self.parentScene = scene;
    [self drawDebug];
}

- (BOOL)edgeTouchesNode:(PathfindingMapNode*)node {
    return ((node == self.nodeA) || (node == self.nodeB));
}

- (PathfindingMapNode*)otherNode:(PathfindingMapNode*)fromNode {
    return (self.nodeA == fromNode) ? self.nodeB : self.nodeA;
}

- (void)setFromNode:(PathfindingMapNode*)fromNode {
    
    NSAssert(((fromNode == self.nodeA) || (fromNode == self.nodeB)), @"fromNode must be on this edge");
    
    _fromNode = fromNode;
};

- (void)createPath {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, self.nodeA.position.x, self.nodeA.position.y);
    CGPathAddLineToPoint(path, nil, self.nodeB.position.x, self.nodeB.position.y);
    
    self.path = path;
}

- (void)drawDebug {
    if(self.parentScene) {
        [self.parentScene addChild:self];
        //[self drawDebugCostText];
    }
}

- (void)drawDebugCostText {
    if(self.parentScene) {
        SKLabelNode* labelNode = [[SKLabelNode alloc] init];
        labelNode.position = CGPointMake(self.nodeA.position.x + ((self.nodeB.position.x - self.nodeA.position.x) * 0.5f),
                                         self.nodeA.position.y + ((self.nodeB.position.y - self.nodeA.position.y) * 0.5f));
        labelNode.text = [NSString stringWithFormat:@"%f",self.cost];
        labelNode.fontColor = [SKColor whiteColor];
        labelNode.fontSize = 10;
        [self.parentScene addChild:labelNode];
    }
}

- (void)markSearched {
    self.hidden = NO;
    self.strokeColor = [UIColor blueColor];
}

- (void)markPartOfPath {
    self.hidden = NO;
    self.strokeColor = [UIColor greenColor];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"NodeA: %@\nNodeB: %@", self.nodeA, self.nodeB];
}

@end
