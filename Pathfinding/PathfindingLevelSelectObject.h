//
//  PathfindingLevelSelectObject.h
//  Pathfinding
//
//  Created by Jeremy Conkin on 2/7/14.
//  Copyright (c) 2014 Toeprint Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathfindingLevelSelectObject : NSObject


/**
 * Create an instance of this class and it's image property
 *
 * @param imageFilePath Path to the image to load
 */
- (instancetype)initWithFilePath:(NSString*)imageFilePath;


/** Image file for this level */
@property (nonatomic,readonly) UIImage* image;

@end
