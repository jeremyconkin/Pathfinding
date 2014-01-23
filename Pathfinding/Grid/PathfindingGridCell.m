//
//  PathfindingGridCell.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/14/13.
//

#import "PathfindingGridCell.h"

@interface PathfindingGridCell ()

@property (nonatomic,weak) PathfindingScene* parentScene;
@property (assign) CGSize size;

@end

@implementation PathfindingGridCell

- (id)initWithLocation:(CGPoint)location
               andSize:(CGSize)size
              andScene:(PathfindingScene*)scene {
    self = [super init];
    if(self) {
        self.location = location;
        self.size = size;
        self.parentScene = scene;
    }
    
    //[self drawDebug];
    return self;
}

- (void)drawDebug {
    SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];//todo_jconkin. Learn debug draw.
    sprite.position = self.location;
    sprite.size = self.size;
    [self.parentScene addChild:sprite];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"location: x:%f  y:%f \n", self.location.x, self.location.y];
}
@end
