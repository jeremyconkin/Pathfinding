//
//  PathfindingGridCell.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 6/14/13.
//

#import <Foundation/Foundation.h>

#import "PathfindingScene.h"

@interface PathfindingGridCell : NSObject

- (id)initWithLocation:(CGPoint)location andSize:(CGSize)size andScene:(PathfindingScene*)scene;

@property (nonatomic) CGPoint location;

@end
