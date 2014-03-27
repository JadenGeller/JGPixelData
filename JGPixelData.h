//
//  JGPixelData.h
//  JGPixelDataExample
//
//  Created by Jaden Geller on 2/3/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JGPixel;

typedef struct ColorComponents {
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    UInt8 alpha;
    
} JGColorComponents;

@interface JGPixelData : NSObject <NSFastEnumeration>

+(JGPixelData*)pixelDataWithImage:(UIImage*)image;
+(JGPixelData*)pixelDataWithSize:(CGSize)size;

-(JGColorComponents*)colorComponentsAtXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex;
//-(JGPixel*)pixelAtXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex;

-(void)processPixelsWithBlock:(void (^)(JGColorComponents *color, int x, int y))updatePixelColor;

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSUInteger width;
@property (nonatomic, readonly) NSUInteger height;

@end

// I RECOMMEND IGNORING THIS CLASS -- FAST ENUMATION ON JGPIXELDATA IS SLOWWWWWW

@interface JGPixel : NSObject

@property (nonatomic) UInt8 alpha;

@property (nonatomic) UInt8 red;
@property (nonatomic) UInt8 green;
@property (nonatomic) UInt8 blue;

@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;

-(id)initWithX:(NSInteger)x y:(NSInteger)y byte:(char *)byte;

@end
