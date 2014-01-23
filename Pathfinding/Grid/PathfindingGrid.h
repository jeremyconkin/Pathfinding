//
//  PathfindingGrid.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/29/13.
//

#import <Foundation/Foundation.h>

@class PathfindingBaseCharacter;
@class PathfindingScene;

@interface PathfindingGrid : NSObject

- (id)initWithScene:(PathfindingScene*)scene
           withRows:(NSInteger)rows
        withColumns:(NSInteger)columns;

- (void)addCharacter:(PathfindingBaseCharacter*)character
               atRow:(NSInteger)row
            atColumn:(NSInteger)column;

- (CGPoint)zeroXForRow:(NSInteger)row;
@end
