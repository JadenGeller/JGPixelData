//
//  JGPixelData.m
//  JGPixelDataExample
//
//  Created by Jaden Geller on 2/3/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import "JGPixelData.h"

@interface JGPixelData ()

@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) CGImageRef imageRef;

@end

@implementation JGPixelData

-(id)initWithImage:(UIImage*)image{
    self = [super init];
    if (self) {
        [self setRawDataWithImage:image];
    }
    return self;
}

-(id)initWithSize:(CGSize)size{
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    //CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
    UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self initWithImage:blank];
}

-(void)setRawDataWithImage:(UIImage*)image{
    _imageRef = image.CGImage;
    _data = (NSData *)CFBridgingRelease(CGDataProviderCopyData(CGImageGetDataProvider(self.imageRef)));
}

-(JGColorComponents)colorComponentsAtXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
    
    char *byte = [self pointerForXIndex:xIndex yIndex:yIndex];
    
    JGColorComponents color;
    
    color.red   = *(byte++); // byte + 0
    color.green = *(byte++); // byte + 1
    color.blue  = *(byte++); // byte + 2
    color.alpha = *(byte);   // byte + 3
    
    return color;
}

-(void)setColorComponents:(JGColorComponents)color atXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
    
    char *byte = [self pointerForXIndex:xIndex yIndex:yIndex];
    
    *(byte++) = color.red;   // byte + 0
    *(byte++) = color.green; // byte + 1
    *(byte++) = color.blue;  // byte + 2
    *(byte)   = color.alpha; // byte + 3

}

-(char *)pointerForXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
    return ((char *)self.data.bytes + [self absoluteIndexForXIndex:xIndex yIndex:yIndex]);
}

-(int)absoluteIndexForXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * self.width;
    
    return (bytesPerRow * yIndex) + xIndex * bytesPerPixel;

}

-(UIImage*)image{
    
    // Create new image from data

    size_t bitsPerComponent         = CGImageGetBitsPerComponent(self.imageRef);
    size_t bitsPerPixel             = CGImageGetBitsPerPixel(self.imageRef);
    size_t bytesPerRow              = CGImageGetBytesPerRow(self.imageRef);
    
    CGColorSpaceRef colorspace      = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo         = CGImageGetBitmapInfo(self.imageRef);
    CGDataProviderRef provider      = CGDataProviderCreateWithData(NULL, self.data.bytes, [self.data length], NULL);
    
    CGImageRef newImageRef = CGImageCreate (
                                            self.width,
                                            self.height,
                                            bitsPerComponent,
                                            bitsPerPixel,
                                            bytesPerRow,
                                            colorspace,
                                            bitmapInfo,
                                            provider,
                                            NULL,
                                            false,
                                            kCGRenderingIntentDefault
                                            );
    // the modified image
    UIImage *newImage   = [UIImage imageWithCGImage:newImageRef];
    
    // cleanup
    CGColorSpaceRelease(colorspace);
    CGDataProviderRelease(provider);
    CGImageRelease(newImageRef);
    
    return newImage;
}

-(NSUInteger)width{
    return CGImageGetWidth(self.imageRef);
}

-(NSUInteger)height{
    return CGImageGetHeight(self.imageRef);
}

+(JGPixelData*)pixelDataWithImage:(UIImage*)image{
    return [[JGPixelData alloc]initWithImage:image];
}

+(JGPixelData*)pixelDataWithSize:(CGSize)size{
    return [[JGPixelData alloc]initWithSize:size];
}

-(void)processPixelsWithBlock:(void (^)(JGColorComponents *color, int x, int y))updatePixelColor{
    for (int x = 0; x < self.width; x++) {
        for (int y = 0; y < self.height; y++) {
            JGColorComponents color = [self colorComponentsAtXIndex:x yIndex:y];
            updatePixelColor(&color, x, y);
            
            [self setColorComponents:color atXIndex:x yIndex:y];
        }
    }

}

@end
