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
@property (nonatomic, readonly) NSMutableDictionary *cache;

@end

@implementation JGPixelData

@synthesize cache = _cache;

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
//
//-(JGColorComponents)colorComponentsAtXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
//    
//    char *byte = [self pointerForXIndex:xIndex yIndex:yIndex];
//    
//    JGColorComponents color;
//    
//    color.red   = *(byte++); // byte + 0
//    color.green = *(byte++); // byte + 1
//    color.blue  = *(byte++); // byte + 2
//    color.alpha = *(byte);   // byte + 3
//    
//    return color;
//}

-(JGColorComponents*)colorComponentsAtXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
    
    return (JGColorComponents*)[self pointerForXIndex:xIndex yIndex:yIndex];
}

//-(void)setColorComponents:(JGColorComponents)color atXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
//    
//    char *byte = [self pointerForXIndex:xIndex yIndex:yIndex];
//    
//    *(byte++) = color.red;   // byte + 0
//    *(byte++) = color.green; // byte + 1
//    *(byte++) = color.blue;  // byte + 2
//    *(byte)   = color.alpha; // byte + 3
//
//}

-(char *)pointerForXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
    return ((char *)self.data.bytes + [self absoluteIndexForXIndex:xIndex yIndex:yIndex]);
}

-(NSInteger)absoluteIndexForXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
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

-(NSMutableDictionary*)cache{
    if (!_cache) _cache = [NSMutableDictionary dictionaryWithCapacity:self.width * self.height];
    return _cache;
}

-(void)processPixelsWithBlock:(void (^)(JGColorComponents *color, int x, int y))updatePixelColor{
    char *byte = (char*)self.data.bytes;
    
    for (int x = 0; x < self.width; x++) {
        for (int y = 0; y < self.height; y++) {
            updatePixelColor((JGColorComponents*)byte, x, y);
            byte += 4;
        }
    }
}

-(JGPixel*)pixelAtXIndex:(NSUInteger)xIndex yIndex:(NSUInteger)yIndex{
    NSNumber *index = @(xIndex + yIndex * self.width);
    JGPixel *pixel = [self.cache objectForKey:index];
    if (!pixel) {
        pixel = [[JGPixel alloc]initWithX:xIndex y:yIndex byte:[self pointerForXIndex:xIndex yIndex:yIndex]];
        [self.cache setObject:pixel forKey:index];
    }
    return pixel;
}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len{
    
    if(state->state == 0)
    {
        state->state = (long)self.data.bytes;
        state->mutationsPtr = &state->extra[4];
        state->extra[0] = 0; // x
        state->extra[1] = 0; // y
        state->extra[2] = self.width;
        state->extra[3] = self.height;
    }
    
    // keep track of how many objects we iterated over so we can return
    // that value
    NSUInteger objCount = 0;
    
    // we'll be putting objects in stackbuf, so point itemsPtr to it
    state->itemsPtr = buffer;
    
    // loop through until either we fill up stackbuf or when y is bigger than height
    while(state->extra[1] < state->extra[3] && objCount < len)
    {
        // pull the node out of extra[0]
        NSNumber *index = @(state->extra[0] + state->extra[1] * state->extra[3]);
        JGPixel *pixel = [self.cache objectForKey:index];
        if (!pixel){
            pixel = [[JGPixel alloc]initWithX:state->extra[0] y:state->extra[1] byte:(char *)state->state];
            [self.cache setObject:pixel forKey:index];
        }
        
        state->state += 4 * sizeof(char); //next rgba
        
        // fill current stackbuf location and move to the next
        *buffer++ = pixel;
        
        // and keep our count
        objCount++;
        
        // move to next node
        // increment x
        state->extra[0]++;
        
        //increment y if x is too big
        if (state->extra[0] >= state->extra[2]){
            state->extra[0] = 0;
            state->extra[1]++;
        }
    }
    
    return objCount;
}

@end

@interface JGPixel ()

@property (nonatomic) char *byte;

@end

@implementation JGPixel

-(id)initWithX:(NSInteger)x y:(NSInteger)y byte:(char *)byte{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _byte = byte;
    }
    return self;
}

-(void)setRed:(UInt8)red{
    *(self.byte) = red;
}

-(void)setGreen:(UInt8)green{
    *(self.byte+1) = green;
}

-(void)setBlue:(UInt8)blue{
    *(self.byte+2) = blue;
}

-(void)setAlpha:(UInt8)alpha{
    *(self.byte+3) = alpha;
}

-(UInt8)red{
    return *(self.byte);
}

-(UInt8)green{
    return *(self.byte+1);
}

-(UInt8)blue{
    return *(self.byte+2);
}

-(UInt8)alpha{
    return *(self.byte+3);
}

@end

