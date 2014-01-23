//
//  PathfindingBaseCharacter.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/14/13.
//

#import "PathfindingBaseCharacter.h"

#import "PathfindingScene.h"

@interface PathfindingBaseCharacter()

@property (weak,nonatomic) PathfindingScene* parentScene;

@end

@implementation PathfindingBaseCharacter

- (void)addAction:(SKAction*)action {
    [self.spriteNode runAction:action completion:Nil];//todo_jconkin. completion.
}

- (SKSpriteNode*)spriteNode {
    if(_spriteNode == nil) {
        _spriteNode = [SKSpriteNode spriteNodeWithImageNamed:[self imageName]];
        _spriteNode.size = [self spriteSize];
    }
    
    return _spriteNode;
}

- (NSString*)imageName {
    return @"Spaceship";
}

- (CGSize)spriteSize {
    return CGSizeMake(50.f, 50.f);
}

// Speed is measured in cell/second
- (CGFloat)baseSpeed {
    return 5.f;
}
@end
