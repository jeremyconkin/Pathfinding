//
//  PathfindingBaseCharacter.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/14/13.
//

#import <Foundation/Foundation.h>

#import "PathfindingScene.h"

@interface PathfindingBaseCharacter : NSObject

- (void)addAction:(SKAction*)action;
- (CGFloat)baseSpeed;

@property (weak,nonatomic) SKSpriteNode* spriteNode;

@end
