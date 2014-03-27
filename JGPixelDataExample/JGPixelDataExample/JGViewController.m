//
//  JGViewController.m
//  JGPixelDataExample
//
//  Created by Jaden Geller on 2/3/14.
//  Copyright (c) 2014 Jaden Geller. All rights reserved.
//

#import "JGViewController.h"
#import "JGPixelData.h"

@interface JGViewController ()

@end

@implementation JGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.afterImage.image = [self advancedImage];

    
}

- (IBAction)segmentChanged:(id)sender {
    if ([sender selectedSegmentIndex]) {
        self.afterImage.image = [self advancedImage];
    }
    else{
        self.afterImage.image = [self simpleImage];
    }
}

-(UIImage*)simpleImage{
    JGPixelData *pixelData = [JGPixelData pixelDataWithImage:self.beforeImage.image];

    [pixelData processPixelsWithBlock:^(JGPixel *pixel, int x, int y) {
        UInt8 temp = pixel->red;
        if (x > y) {
            pixel->red = pixel->blue;
            pixel->blue = temp;
        }
        else{
            pixel->red = pixel->green;
            pixel->green = temp;
        }
    }];
    
    return pixelData.image;
}

-(UIImage*)advancedImage{
    JGPixelData *pixelData = [JGPixelData pixelDataWithImage:self.beforeImage.image];
    JGPixelData *referenceData = pixelData.copy;
    
    NSUInteger x = 0, y = 0;
    
    JGPixel *top    = referenceData.start - referenceData.width;
    JGPixel *bottom = referenceData.start + referenceData.width;
    JGPixel *left   = referenceData.start - 1;
    JGPixel *right  = referenceData.start - 1;
    
    for (JGPixel *pixel = pixelData.start; pixel < pixelData.stop; pixel++) {
        
        NSInteger red   = 0;
        NSInteger green = 0;
        NSInteger blue  = 0;
        
        // Sum pixels that are in range and in visually continuous
        if ([referenceData inRange:left] && x > 0){
            red   += left->red;
            green += left->green;
            blue  += left->blue;
        }
        if ([referenceData inRange:right] && x < pixelData.width - 1){
            red   -= right->red;
            green -= right->green;
            blue  -= right->blue;
        }
        if ([referenceData inRange:top] && y > 0){
            red   += top->red;
            green += top->green;
            blue  += top->blue;
        }
        if ([referenceData inRange:bottom] && y < pixelData.height - 1){
            red   -= bottom->red;
            green -= bottom->green;
            blue  -= bottom->blue;
        }
        
        if (red)   pixel->red   = MAX(0, red);
        if (green) pixel->green = MAX(0, green);
        if (blue)  pixel->blue  = MAX(0, blue);
        
        // Increment variables
        x++; if (x > pixelData.width) { x = 0; y++; }
        
        // Increment pointers
        top++; bottom++; left++; right++;
    }
    
    return pixelData.image;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
