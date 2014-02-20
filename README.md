JGPixelData
===========

JGPixelData simplifies the process of editing the raw pixel RGBA values of a UIImage. Simply create a JGPixelData object and directly modify the RGBA values of each pixel independently. In the following example, we use a block function to loop over all the pixels in an image and swap the values of their red and blue color components.

```
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

```

Alternatively, it is possible to manually loop over all pixels in the image using nested for loops.

```
for (int x = 0; x < pixelData.width; x++) {
    for (int y = 0; y < pixelData.height; y++) {
        JGColorComponents color = [pixelData colorComponentsAtXIndex:x yIndex:y];
        
        UInt8 temp = color->red;
        if (x > y) {
           color->red = color->blue;
           color->blue = temp;
        }
        else{
            color->red = color->green;
            color->green = temp;
        }
    }
}];
        
        [pixelData setColorComponents:color atXIndex:x yIndex:y];
    }
}

```

Once you make the desired changes to the individual pixels, simply use the image property of a JGPixelData instance to get the newly modified image.

```
UIImage *editedImage = pixelData.image;
```

It's as easy as that!
