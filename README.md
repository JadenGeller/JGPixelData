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


Once you make the desired changes to the individual pixels, simply use the image property of a JGPixelData instance to get the newly modified image.

```
UIImage *editedImage = pixelData.image;
```

It's as easy as that!

Alternative Loop Mechanisms
===========

It is possible to manually loop over all pixels in the image using nested for loops.

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
        
        [pixelData setColorComponents:color atXIndex:x yIndex:y];
    }
}

```

Additionally, fast enumation is supported, so pixels can be looped over with a for in loop. Note that this is not recommended as it is slower in its current implmentation.

```
for (JGPixel *pixel in pixelData) {
    
    UInt8 temp = pixel.red;
    if (pixel.x > pixel.y) {
        pixel.red = pixel.blue;
        pixel.blue = temp;
    }
    else{
        pixel.red = pixel.green;
        pixel.green = temp;
    }
}
```

Individual Pixel Access
===========

Individual pixels can be accessed in one of two ways. The first way is by getting and setting JGColorComponents using the `colorComponentsAtXIndex:yIndex:` and `setColorComponents:atXIndex:yIndex:` methods, respectively. Note that this method is used in the above for loop mechanism.

```
JGColorComponents color = [pixelData colorComponentsAtXIndex:x yIndex:y];

// Modify color components

[pixelData setColorComponents:color atXIndex:x yIndex:y];
```

The second, more elegant way to access individual pixels is by requesting a JGPixel instance for a given x-y positiion using the `pixelAtXIndex:yIndex:` method. With a JGPixel object, there is no need to set the color components back afterwards, as the JGPixel is linked to its JGPixelData, and automatically relays the changes.

```
JGPixel *pixel = [pixelData pixelAtXIndex:x yIndex:y];

// Modify red, green, blue, or alpha
// And you are good!
```

Other
===========

For convenience, JGPixelData provides a `width` and `height` method that returns the pixel width and pixel height, respectively, or the pixel data.

Additionally, there is a UIImage category provided with the instance method `pixelData` that returns a JGPixelData object associated to the given image and a class method `imageWithPixelData:` that constructs a new UIImage from the contents of the JGPixelData. Note that these methods are just for convenices; JGPixelData has the equivalent methods `pixelDataWithImage:` and `image`. Use either set of methods based on your preference to have JGPixelData as the reciever or UIImage as the reciever.
