//
//  JGPixelData.h
//  JGPixelDataExample
//
//  Created by Jaden Geller on 2/3/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JGPixelColorMin 0
#define JGPixelColorMax 255

typedef struct JGColorComponents {
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    UInt8 alpha;
    
} JGPixel;

@interface JGPixelData : NSObject <NSCopying>

+(JGPixelData*)pixelDataWithImage:(UIImage*)image;
+(JGPixelData*)pixelDataWithSize:(CGSize)size;

-(JGPixel*)pixelWithX:(NSUInteger)xIndex y:(NSUInteger)yIndex;

-(void)processPixelsWithBlock:(void (^)(JGPixel *color, int x, int y))updatePixelColor;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

// Can be used for wacky iterations
@property (nonatomic, readonly) JGPixel *start;
@property (nonatomic, readonly) JGPixel *stop;

-(BOOL)inRange:(JGPixel*)pixel;

@end
