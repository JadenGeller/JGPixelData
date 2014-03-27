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

@synthesize stop = _stop, width = _width, height = _height;

- (id)copyWithZone:(NSZone *)zone
{
    JGPixelData *copy = [[[self class] alloc] init];
    
    if (copy) {
        copy->_data = _data.copy;
        copy->_imageRef = _imageRef;
    }
    
    return copy;
}

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

-(JGPixel*)pixelWithX:(NSUInteger)xIndex y:(NSUInteger)yIndex{
    return (JGPixel*)self.data.bytes + xIndex + self.width * yIndex;
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
    if (!_width) _width = CGImageGetWidth(self.imageRef);
    return _width;
}

-(NSUInteger)height{
    if (!_height) _height = CGImageGetHeight(self.imageRef);
    return _height;
}

+(JGPixelData*)pixelDataWithImage:(UIImage*)image{
    return [[JGPixelData alloc]initWithImage:image];
}

+(JGPixelData*)pixelDataWithSize:(CGSize)size{
    return [[JGPixelData alloc]initWithSize:size];
}

-(void)processPixelsWithBlock:(void (^)(JGPixel *color, int x, int y))updatePixelColor{
    
    JGPixel *pixel = self.start;
    for (int x = 0; x < self.width; x++) {
        for (int y = 0; y < self.height; y++) {
            updatePixelColor(pixel++, x, y);
        }
    }
}

-(JGPixel*)start{
    return (JGPixel*)self.data.bytes;
}

-(JGPixel*)stop{
    if (!_stop) _stop = ((JGPixel*)self.data.bytes + self.width * self.height);
    return _stop;
}

-(BOOL)inRange:(JGPixel*)pixel{
    return (pixel >= self.start && pixel < self.stop);
}

@end


