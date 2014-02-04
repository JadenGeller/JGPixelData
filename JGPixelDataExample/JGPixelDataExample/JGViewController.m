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
    
    JGPixelData *pixelData = [JGPixelData pixelDataWithImage:self.beforeImage.image];
    
    for (int x = 0; x < pixelData.width; x++) {
        for (int y = 0; y < pixelData.height; y++) {
            JGColorComponents color = [pixelData colorComponentsAtXIndex:x yIndex:y];
            
            // Swap red and blue colors
            UInt8 temp = color.red;
            color.red = color.blue;
            color.blue = temp;
            
            [pixelData setColorComponents:color atXIndex:x yIndex:y];
        }
    }
    
    self.afterImage.image = pixelData.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
