//
//  JGPixelData.h
//  JGPixelDataExample
//
//  Created by Jaden Geller on 2/3/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct ColorComponents {
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    UInt8 alpha;
    
} JGColorComponents;

@interface JGPixelData : NSObject

+(JGPixelData*)pixelDataWithImage:(UIImage*)image;
+(JGPixelData*)pixelDataWithSize:(CGSize)size;
-(JGColorComponents)colorComponentsAtXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex;
-(void)setColorComponents:(JGColorComponents)color atXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

@end
