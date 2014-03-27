//
//  UIImage+JGPixelData.h
//  JGPixelDataExample
//
//  Created by Jaden Geller on 3/27/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGPixelData.h"

@interface UIImage (JGPixelData)

-(JGPixelData*)pixelData;
+(UIImage*)imageWithPixelData:(JGPixelData*)pixelData;

@end
