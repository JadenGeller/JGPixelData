JGPixelData
===========

JGPixelData simplifies the process of editing the raw pixel RGBA values of a UIImage. Simply create a JGPixelData object and directly modify the RGBA values of each pixel independently. Furthermore, looping over the pixels is effortless!

First, we create an instance of JGPixelData from a given UIImage.

```
JGPixelData *pixelData = [JGPixelData pixelDataWithImage:image];
```

Then, we use a block function to loop over all the pixels in an image and swap the values of their red and blue color components.

```
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

```

Once you make the desired changes to the individual pixels, simply use the image property of a JGPixelData instance to get the newly modified image.

```
UIImage *editedImage = pixelData.image;
```

It's as easy as that!

Advanced Looping
===========

JGPixelData provides a convenient pointer to a start and a stop pixel that can be used in iteration. In the following example, we will invert the color of our image. Because we don't care about the x or y value of each pixel, we can forget about the block and just iterate using a for loop.

```
for (JGPixel *pixel = pixelData.start; pixel < pixelData.stop; pixel++) {
    pixel->red   = JGPixelColorMax - pixel->red;
    pixel->green = JGPixelColorMax - pixel->green;
    pixel->blue  = JGPixelColorMax - pixel->blue;
}
```

Notice that we can create even more complicated loops since we have direct access to the pixel. For example, we can change a pixel based off its surrounding pixels. There is an advanced example of this in the example project.

Individual Pixel Access
===========

Individual pixels can be accessed using the method `pixelWithX:y:`.


Other
===========

For convenience, JGPixelData provides a `width` and `height` method that returns the pixel width and pixel height, respectively, or the pixel data.
