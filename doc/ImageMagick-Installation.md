# ImageMagick

From http://www.imagemagick.org/script/index.php:

> ImageMagick® is a software suite to create, edit, compose, or convert bitmap images. It can read and write images in a variety of formats (over 200) including PNG, JPEG, JPEG-2000, GIF, TIFF, DPX, EXR, WebP, Postscript, PDF, and SVG.

### Installation
```bash
sudo apt-get install imagemagick libmagickwand-dev
sudo ln -s /usr/lib/x86_64-linux-gnu/libMagickCore.so.5 /usr/lib/x86_64-linux-gnu/libMagickCore.so.4
sudo ln -s /usr/lib/x86_64-linux-gnu/libMagickWand.so.5 /usr/lib/x86_64-linux-gnu/libMagickWand.so.4
sudo ldconfig
```
