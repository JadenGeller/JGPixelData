//
//  UIImage+JGPixelData.m
//  JGPixelDataExample
//
//  Created by Jaden Geller on 3/27/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import "UIImage+JGPixelData.h"

@implementation UIImage (JGPixelData)

-(JGPixelData*)pixelData{
    return [JGPixelData pixelDataWithImage:self];
}

+(UIImage*)imageWithPixelData:(JGPixelData*)pixelData{
    return [pixelData image];
}

@end
