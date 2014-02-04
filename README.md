JGPixelData
===========

JGPixelData simplifies the process of editing the raw pixel RGBA values of a UIImage. Simply create a JGPixelData object and directly modify the RGBA values of each pixel independently. In the following example, we loop over all the pixels in an image and swap the values of their red and blue color components.

```
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

```

Once you make the desired changes to the individual pixels, simply use the image property of a JGPixelData instance to get the newly modified image.

```
UIImage *editedImage = pixelData.image;
```

It's as easy as that!
