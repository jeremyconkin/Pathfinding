//
//  PathfindingLevelSelectObject.m
//  Pathfinding
//
//  Created by Jeremy Conkin on 2/7/14.
//  Copyright (c) 2014 Toeprint Interactive. All rights reserved.
//
//  This object contains the data necessary to create a level select cell

#import "PathfindingLevelSelectObject.h"

@interface PathfindingLevelSelectObject ()

/** Path to the image file for this object's corresponding level */
@property (nonatomic,strong) NSString* imageFilePath;

// Make this property writeable privately
@property (nonatomic,strong) UIImage* image;

@end

@implementation PathfindingLevelSelectObject

- (instancetype)initWithFilePath:(NSString*)imageFilePath
{
    self = [super init];
    
    if (self) {
        _imageFilePath = imageFilePath;
        [self createImage];
    }

    return self;
}

- (void)createImage
{
    self.image = [UIImage imageNamed:self.imageFilePath];
}

@end
