//
//  PathfindingCharacterManager.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/29/13.
//

#import "PathfindingCharacterManager.h"

#import "PathfindingBaseCharacter.h"
#import "PathfindingGrid.h"

@interface PathfindingCharacterManager()

@property (strong,nonatomic) NSMutableArray* characters;
@property (weak,nonatomic) PathfindingGrid* grid;

@end

@implementation PathfindingCharacterManager

- (id)initWithGrid:(PathfindingGrid*)grid {
    self = [super init];
    if (self) {
        self.grid = grid;
        self.characters = [[NSMutableArray alloc] init];
        //temp_jconkin
//        [self spawnCharacterAtRow:2
//                         atColumn:3];
//        [self spawnCharacterAtRow:1
//                         atColumn:1];
    }
    
    return self;
}

- (void)spawnCharacterAtRow:(NSInteger)row
                   atColumn:(NSInteger)column {
    PathfindingBaseCharacter* character = [[PathfindingBaseCharacter alloc] init];
    [self.characters addObject:character];
    [self.grid addCharacter:character
                      atRow:row
                   atColumn:column];
    
    //temp_jconkin
    SKAction* moveAction = [SKAction moveTo:[self.grid zeroXForRow:row]
                                   duration:(column*[character baseSpeed])];
    [character addAction:moveAction];
    
}

@end
