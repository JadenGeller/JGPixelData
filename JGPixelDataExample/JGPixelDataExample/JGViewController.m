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
     
    [pixelData processPixelsWithBlock:^(JGColorComponents *color, int x, int y) {
        UInt8 temp = color->red;
        if (x > y) {
            color->red = color->blue;
            color->blue = temp;
        }
        else{
            color->red = color->green;
            color->green = temp;
        }
    }];
    
    self.afterImage.image = pixelData.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
