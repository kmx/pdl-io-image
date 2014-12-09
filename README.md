# NAME

PDL::IO::Image - Load/save bitmap from/to PDL (via FreeImage library)

# SYNOPSIS

Functional interface:

    use 5.010;
    use PDL;
    use PDL::IO::Image;
    
    my $pdl1 = rimage('picture.tiff');
    say $pdl1->info;       # PDL: Byte D [400,300] ... width 400, height 300
    # do some hacking with $piddle
    wimage($pdl1, 'output.tiff');
    # you can use wimage as PDL's method
    $pdl1->wimage('another-output.png');
     
    my ($pixels, $palette) = rimage('picture-256colors.gif', { palette=>1 });
    say $pixels->info;     # PDL: Byte D [400,300] ... width 400, height 300
    say $palette->info;    # PDL: Byte D [3,256]
    # do some hacking with $pixels and $palette
    wimage($pixels, 'output.gif', { palette=>$palette });
     
    # load specific image (page) from multi-page file
    my $pdl2 = rimage('picture.tiff', { page=>0 });
     
    # load specific image + flit vertically before converting to piddle
    my $pdl3 = rimage('picture.tiff', { flip=>'V' });
    
    # random pixels + ramdom colors (RGBA - 35 bits per pixel)
    (random(400, 300, 4) * 256)->byte->wimage("random.png");
    
    my $pix1 = (sin(0.25 * rvals(101, 101)) * 128 + 127)->byte;
    say $pix1->info;       # PDL: Byte D [101,101]
    my $pal1 = yvals(3, 256)->byte;
    $pal1->slice("(2),:") .= 0; # set blue part of palette to zero
    say $pal1->info;       # PDL: Byte D [3,256]
    $pix1->wimage("wave1_grayscale.gif"); # default is grayscale palette
    $pix1->wimage("wave2_yellow.gif", { palette=>$pal1 });
    
    # rotate /rescale before saving
    my $pix2 = (sin(0.25 * xvals(101, 101)) * 128 + 127)->byte;
    $pix2->wimage("wave3_grayscale.gif", { rotate=>33.33, rescale=>[16,16] }); # rescale to 16x16 pixels
    $pix2->wimage("wave4_grayscale.gif", { rescale_pct=>50 }); # rescale to 50%

Object oriented (OO) interface:

    use 5.010;
    use PDL;
    use PDL::IO::Image;
    
    # create PDL::IO::Image object from file
    my $pimage1 = PDL::IO::Image->new_from_file('picture.gif');
    say 'width       = ' . $pimage1->get_width;
    say 'height      = ' . $pimage1->get_height;
    say 'image_type  = ' . $pimage1->get_image_type;
    say 'color_type  = ' . $pimage1->get_color_type;
    say 'colors_used = ' . $pimage1->get_colors_used;
    say 'bpp         = ' . $pimage1->get_bpp;
    # you can do some operations with PDL::IO::Image object
    $pimage1->flip_vertical;
    # export pixels from PDL::IO::Image object content into a piddle
    my $pix_pdl = $pimage1->pixels_to_pdl();
    # export palette from PDL::IO::Image object content into a piddle
    my $pal_pdl = $pimage1->palette_to_pdl();
    
    # create PDL::IO::Image object from PDL data
    my $wave_pixels = (sin(0.008 * xvals(2001, 2001)) * 128 + 127)->byte;
    # here you can do some other tricks with $wave_pixels
    my $pimage2 = PDL::IO::Image->new_from_pdl($wave_pixels);
    # do some transformation with PDL::IO::Image object
    $pimage2->rotate(45);
    $pimage2->rescale(200, 200);
    # export PDL::IO::Image object content into a image file
    $pimage2->save("output.jpg");

# DESCRIPTION

XXX

## Supported file formats

This module supports loading (["new\_from\_file"](#new_from_file) or ["rimage"](#rimage)) and saving (["save"](#save) or ["wimage"](#wimage))
of the following formats (note that not all formats suppors writing - see `R/W` column).

       BMP  R/W  Windows or OS/2 Bitmap [extensions: bmp]
       ICO  R/W  Windows Icon [extensions: ico]
      JPEG  R/W  JPEG - JFIF Compliant [extensions: jpg,jif,jpeg,jpe]
       JNG  R/W  JPEG Network Graphics [extensions: jng]
     KOALA  R/-  C64 Koala Graphics [extensions: koa]
       IFF  R/-  IFF Interleaved Bitmap [extensions: iff,lbm]
       MNG  R/-  Multiple-image Network Graphics [extensions: mng]
       PBM  R/W  Portable Bitmap (ASCII) [extensions: pbm]
    PBMRAW  R/W  Portable Bitmap (RAW) [extensions: pbm]
       PCD  R/-  Kodak PhotoCD [extensions: pcd]
       PCX  R/-  Zsoft Paintbrush [extensions: pcx]
       PGM  R/W  Portable Greymap (ASCII) [extensions: pgm]
    PGMRAW  R/W  Portable Greymap (RAW) [extensions: pgm]
       PNG  R/W  Portable Network Graphics [extensions: png]
       PPM  R/W  Portable Pixelmap (ASCII) [extensions: ppm]
    PPMRAW  R/W  Portable Pixelmap (RAW) [extensions: ppm]
       RAS  R/-  Sun Raster Image [extensions: ras]
     TARGA  R/W  Truevision Targa [extensions: tga,targa]
      TIFF  R/W  Tagged Image File Format [extensions: tif,tiff]
      WBMP  R/W  Wireless Bitmap [extensions: wap,wbmp,wbm]
       PSD  R/-  Adobe Photoshop [extensions: psd]
       CUT  R/-  Dr. Halo [extensions: cut]
       XBM  R/-  X11 Bitmap Format [extensions: xbm]
       XPM  R/W  X11 Pixmap Format [extensions: xpm]
       DDS  R/-  DirectX Surface [extensions: dds]
       GIF  R/W  Graphics Interchange Format [extensions: gif]
       HDR  R/W  High Dynamic Range Image [extensions: hdr]
        G3  R/-  Raw fax format CCITT G.3 [extensions: g3]
       SGI  R/-  SGI Image Format [extensions: sgi,rgb,rgba,bw]
       EXR  R/W  ILM OpenEXR [extensions: exr]
       J2K  R/W  JPEG-2000 codestream [extensions: j2k,j2c]
       JP2  R/W  JPEG-2000 File Format [extensions: jp2]
       PFM  R/W  Portable floatmap [extensions: pfm]
      PICT  R/-  Macintosh PICT [extensions: pct,pict,pic]
       RAW  R/-  RAW camera image [extensions: 3fr,arw,bay,bmq,cap,cine,
                     cr2,crw,cs1,dc2, dcr,drf,dsc,dng,erf,fff,ia,iiq,k25,
                     kc2,kdc,mdc,mef,mos,mrw,nef,nrw,orf,pef, ptx,pxn,qtk,
                     raf,raw,rdc,rw2,rwl,rwz,sr2,srf,srw,sti]
      WEBP  R/W  Google WebP image format [extensions: webp]
   JPEG-XR  R/W  JPEG XR image format [extensions: jxr,wdp,hdp]

**IMPORTANT** the strings in the first column (e.g. `'BMP'`, `'JPEG'`, `'PNG'`) are used as a format identifier in
["new\_from\_file"](#new_from_file), ["save"](#save), ["rimage"](#rimage), ["wimage"](#wimage) (+some other methods).

The supported format may differ depending on freeimage library version. You can list what exactly you freeimage library
can handle like this:

    for (PDL::IO::Image->format_list) {
      my $r = PDL::IO::Image->format_can_read($_) ? 'R' : '-';
      my $w = PDL::IO::Image->format_can_write($_) ? 'W' : '-';
      my $e = PDL::IO::Image->format_extension_list($_);
      my $d = PDL::IO::Image->format_description($_);
      printf("% 7s  %s/%s  %s [extensions: %s]\n", $_, $r, $w, $d, $e);
    }

## Supported image types

This module can handle the following image types.

    BITMAP   Standard image: 1-, 4-, 8-, 16-, 24-, 32-bit
    UINT16   Array of unsigned short: unsigned 16-bit
    INT16    Array of short: signed 16-bit
    UINT32   Array of unsigned long: unsigned 32-bit
    INT32    Array of long: signed 32-bit
    FLOAT    Array of float: 32-bit IEEE floating point
    DOUBLE   Array of double: 64-bit IEEE floating point
    RGB16    48-bit RGB image: 3 x 16-bit
    RGBA16   64-bit RGBA image: 4 x 16-bit
    RGBF     96-bit RGB float image: 3 x 32-bit IEEE floating point
    RGBAF    128-bit RGBA float image: 4 x 32-bit IEEE floating point

Currently **NOT SUPPORTED**:

    COMPLEX  Array of FICOMPLEX: 2 x 64-bit IEEE floating point

Image type is important especially when you want to load image data from PDL piddle into a PDL::IO::Image object 
(and later save to a file). Based on piddle size and piddle type the image type is detected (in ["new\_from\_pdl"](#new_from_pdl)
and ["wimage"](#wimage)).

     <w>...image width
     <h>...image height
     PDL Byte    [<w>,<h>]         BITMAP 1-/4-/8-bits per pixel
     PDL Byte    [<w>,<h>,3]       BITMAP 24-bits per pixel (RGB)
     PDL Byte    [<w>,<h>,4]       BITMAP 32-bits per pixel (RGBA)    
     PDL Ushort  [<w>,<h>]         UINT16
     PDL Short   [<w>,<h>]         INT16
     PDL LongLong[<w>,<h>]         UINT32 (unfortunately there is no PDL Ulong type)
     PDL Long    [<w>,<h>]         INT32
     PDL Float   [<w>,<h>]         FLOAT
     PDL Double  [<w>,<h>]         DOUBLE
     PDL Ushort  [<w>,<h>,3]       RGB16
     PDL Ushort  [<w>,<h>,4]       RGBA16
     PDL Float   [<w>,<h>,3]       RGBf
     PDL Float   [<w>,<h>,4]       RGBAF
    

**IMPORTANT** the strings with type name (e.g. `'BITMAP'`, `'UINT16'`, `'RGBAF'`) are used as a image type 
identifier in mathod ["convert\_image\_type"](#convert_image_type) and a return value of method ["get\_image\_type"](#get_image_type).

Not all file formats support all imge formats above (especially those non-BITMAP image types). If you are in doubts use
`tiff` format for storing unusual image types.

# FUNCTIONS

The functional interface comprise of two functions ["rimage"](#rimage) and ["wimage"](#wimage) - both are exported by default.

## rimage

Loads image into a PDL piddle (or into two piddles in case of pallete-based images).

    my $pixels_pdl = rimage($filename);
    #or
    my $pixels_pdl = rimage($filename, \%options);
    #or
    my ($pixels_pdl, $palette_pdl) = rimage($filename, { palette=>1 });

Internally it works in these steps:

- Create PDL::IO::Image object from the input file.
- Do optional transformations (based on `%options`) with PDL::IO::Image object object.
- Export PDL::IO::Image object into a piddle(s) via ["pixels\_to\_pdl"](#pixels_to_pdl) and ["palette\_to\_pdl"](#palette_to_pdl).
- **IMPORTANT:** ["rimage"](#rimage) returns piddle(s) not a PDL::IO::Image object

Items supported in **options** hash:

- format

    String identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">), default 
    is `'AUTO'` which means that format is auto detected.

- format\_flag

    Optinal flag related to loading given file format - see ["new\_from\_file"](#new_from_file) method for more info.

- page

    Load specifig page from multi-page images (0-based index).

- flip

    Values `'H'`, `'V'` or `'HV'` specifying horizontal, vertical or horizontal+vertical flipping. 
    Default: do not flip.

- convert\_image\_type

    String identifying image type (e.g. `'BITMAP'` - for valid values see <L/"Supported image types">). 
    Default: no conversion.

- region

    An arrayref with a region specification like `[$x1,$x2,$y1,$y2]` - see ["pixels\_to\_pdl"](#pixels_to_pdl) method for more info.
    Default: create the output piddle from the whole image.

- palette

    Values `0` (default) or `1` - whether to load (or not) color lookup table (aka LUT).

## wimage

Write PDL piddle(s) into a image file.

    $pixels_pdl->wimage($filename);
    #or
    $pixels_pdl->wimage($filename, \%options);

    wimage($pixels_pdl, $filename);
    #or
    wimage($pixels_pdl, $filename, \%options);

Internally it works in these steps:

- Create PDL::IO::Image object from the `$pixels_piddle` (+ `$palette_piddle` passed as `palette` option).
- Dimensions and type of `$pixels_piddle` must comply with ["Supported image types"](#supported-image-types).
- Do optional transformations (based on `%options`) with PDL::IO::Image object object.
- Export PDL::IO::Image object into a image file via ["save"](#save) method.

Items supported in **options** hash:

- format

    String identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">), default 
    is `'AUTO'` which means that format is auto detected from extension of `$filename`.

- format\_flag

    Optinal flag related to saving given file format - see ["save"](#save) method for more info.

- palette

    Optional PDL piddle with color palette (has to be `PDL Byte[3,N]` where 0 < N <= 256) with RGB tripplets.

- flip

    Values `'H'`, `'V'` or `'HV'` specifying horizontal, vertical or horizontal+vertical flipping. 
    Default: do not flip.

- rotate

    Optional floating point value with rotation angle (in degrees) - see ["rotate"](#rotate) method for more info.
    Default: do not rotate.

- rescale

    Optional array ref with rescale specification (in pixels) e.g. `[$new_w, $new_h]` - see ["rescale"](#rescale) method for more info.
    Default: do not rescale.

- rescale\_pct

    Optional floating point value with rescale ratio in percent - see ["rescale\_pct"](#rescale_pct) method for more info.
    Default: do not rescale.

- convert\_image\_type

    String identifying image type (e.g. `'BITMAP'` - for valid values see <L/"Supported image types">). 
    Default: no conversion.

# METHODS

## new\_from\_file

Create PDL::IO::Image object from image file.

    my $pimage = IO::PDL::Image->new_from_file($filename);
    #or
    my $pimage = IO::PDL::Image->new_from_file($filename, $format);
    #or
    my $pimage = IO::PDL::Image->new_from_file($filename, $format, $format_flag);
    #or
    my $pimage = IO::PDL::Image->new_from_file($filename, $format, $format_flag, $page);

`$filename` - input image file name.

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">),
default is `'AUTO'` which means that format is auto detected (based on file header with fallback to detection based
on file extension).

`$format_flag` - optional flag related to loading given file format, default if `0` (no extra flags). The flag can be
created by OR-ing some of available constants:

    PDL::IO::Image::GIF_LOAD256        Load the image as a 256 color image with unused
                                       palette entries, if it's 16 or 2 color
    PDL::IO::Image::GIF_PLAYBACK       'Play' the GIF to generate each frame (as 32bpp)
                                       instead of returning raw frame data when loading
    PDL::IO::Image::ICO_MAKEALPHA      Convert to 32-bit and create an alpha channel from
                                       the ANDmask when loading
    PDL::IO::Image::JPEG_FAST          Load the file as fast as possible, sacrificing some quality
    PDL::IO::Image::JPEG_ACCURATE      Load the file with the best quality, sacrificing some speed
    PDL::IO::Image::JPEG_CMYK          This flag will load CMYK bitmaps as 32-bit separated CMYK
    PDL::IO::Image::JPEG_GREYSCALE     Load and convert to a 8-bit greyscale image (faster than
                                       loading as 24-bit and converting to 8-bit)
    PDL::IO::Image::JPEG_EXIFROTATE    Load and rotate according to Exif 'Orientation' tag if available
    PDL::IO::Image::PCD_BASE           This flag will load the one sized 768 x 512
    PDL::IO::Image::PCD_BASEDIV4       This flag will load the bitmap sized 384 x 256
    PDL::IO::Image::PCD_BASEDIV16      This flag will load the bitmap sized 192 x 128
    PDL::IO::Image::PNG_IGNOREGAMMA    Avoid gamma correction on loading
    PDL::IO::Image::PSD_CMYK           Reads tags for separated CMYK (default is conversion to RGB)
    PDL::IO::Image::PSD_LAB            Reads tags for CIELab (default is conversion to RGB)
    PDL::IO::Image::RAW_PREVIEW        Try to load the embedded JPEG preview with included Exif 
                                       data or default to RGB 24-bit
    PDL::IO::Image::RAW_DISPLAY        Load the file as RGB 24-bit
    PDL::IO::Image::RAW_HALFSIZE       Output a half-size color image
    PDL::IO::Image::TARGA_LOAD_RGB888  If set the loader converts RGB555 and ARGB8888 -> RGB888
    PDL::IO::Image::TIFF_CMYK          Load CMYK bitmaps as separated CMYK (default is conversion to RGB)

## new\_from\_pdl

Create PDL::IO::Image object from PDL piddle with pixel (+ optional palette) data.

    my $pimage = IO::PDL::Image->new_from_pdl($pixels_pdl);
    #or
    my $pimage = IO::PDL::Image->new_from_pdl($pixels_pdl, $palette_pdl);

## pixels\_to\_pdl

Export pixel data from PDL::IO::Image object into a piddle.

    my $pixels_pdl = $pimage->pixels_to_pdl;
    #or
    my $pixels_pdl = $pimage->pixels_to_pdl($x1, $x2, $y1, $y2);

## palette\_to\_pdl

Export palette (aka LUT - color lookup table) data from PDL::IO::Image object into a piddle.

    my $palette_pdl = $pimage->palette_to_pdl;

## save

Export PDL::IO::Image object into a image file.

    $pimage->save($filename, $format, $flags);
    #or
    $pimage->save($filename, $format);
    #or
    $pimage->save($filename);
    

`$filename` - output image file name.

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">),
default is `'AUTO'` which means that format is auto detected from extension of `$filename`.

`$format_flag` - optional flag related to saving given file format, default if `0` (no extra flags). The flag can be
created by OR-ing some of available constants:

    PDL::IO::Image::BMP_SAVE_RLE              Compress the bitmap using RLE when saving
    PDL::IO::Image::EXR_FLOAT                 Save data as float instead of as half (not recommended)
    PDL::IO::Image::EXR_NONE                  Save with no compression
    PDL::IO::Image::EXR_ZIP                   Save with zlib compression, in blocks of 16 scan lines
    PDL::IO::Image::EXR_PIZ                   Save with piz-based wavelet compression
    PDL::IO::Image::EXR_PXR24                 Save with lossy 24-bit float compression
    PDL::IO::Image::EXR_B44                   Save with lossy 44% float compression
    PDL::IO::Image::EXR_LC                    Save with one luminance and two chroma channels, rather than RGB (lossy)
      for J2K format: integer X in [1..512]   Save with a X:1 rate (default = 16)
      for JP2 format: integer X in [1..512]   Save with a X:1 rate (default = 16)
    PDL::IO::Image::JPEG_QUALITYSUPERB        Saves with superb quality (100:1)
    PDL::IO::Image::JPEG_QUALITYGOOD          Saves with good quality (75:1 - default)
    PDL::IO::Image::JPEG_QUALITYNORMAL        Saves with normal quality (50:1)
    PDL::IO::Image::JPEG_QUALITYAVERAGE       Saves with average quality (25:1)
    PDL::IO::Image::JPEG_QUALITYBAD           Saves with bad quality (10:1)
      for JPEG format: integer X in [0..100]  Save with quality X:1
    PDL::IO::Image::JPEG_PROGRESSIVE          Saves as a progressive JPEG file
    PDL::IO::Image::JPEG_SUBSAMPLING_411      Save with high 4x1 chroma subsampling (4:1:1)
    PDL::IO::Image::JPEG_SUBSAMPLING_420      Save with medium 2x2 chroma subsampling (4:2:0) - default value
    PDL::IO::Image::JPEG_SUBSAMPLING_422      Save with low 2x1 chroma subsampling (4:2:2)
    PDL::IO::Image::JPEG_SUBSAMPLING_444      Save with no chroma subsampling (4:4:4)
    PDL::IO::Image::JPEG_OPTIMIZE             On saving, compute optimal Huffman coding tables
    PDL::IO::Image::JPEG_BASELINE             Save basic JPEG, without metadata or any markers
      for JXR format: integer X in [1..100)   Save with quality X:1 (default = 80), using X=100 means lossless
    PDL::IO::Image::JXR_LOSSLESS              Save lossless (quality = 100)
    PDL::IO::Image::JXR_PROGRESSIVE           Saves as a progressive JPEG-XR file
    PDL::IO::Image::PNG_Z_BEST_SPEED          Save using ZLib level 1 compression (default value is 6)
    PDL::IO::Image::PNG_Z_DEFAULT_COMPRESSION Save using ZLib level 6 compression (default)
    PDL::IO::Image::PNG_Z_BEST_COMPRESSION    Save using ZLib level 9 compression (default value is 6)
    PDL::IO::Image::PNG_Z_NO_COMPRESSION      Save without ZLib compression
    PDL::IO::Image::PNG_INTERLACED            Save using Adam7 interlacing
    PDL::IO::Image::PNM_SAVE_RAW              Saves the bitmap as a binary file
    PDL::IO::Image::PNM_SAVE_ASCII            Saves the bitmap as an ASCII file
    PDL::IO::Image::TIFF_CMYK                 Stores tags for separated CMYK
    PDL::IO::Image::TIFF_PACKBITS             Save using PACKBITS compression
    PDL::IO::Image::TIFF_DEFLATE              Save using DEFLATE compression (also known as ZLIB compression)
    PDL::IO::Image::TIFF_ADOBE_DEFLATE        Save using ADOBE DEFLATE compression
    PDL::IO::Image::TIFF_NONE                 Save without any compression
    PDL::IO::Image::TIFF_CCITTFAX3            Save using CCITT Group 3 fax encoding
    PDL::IO::Image::TIFF_CCITTFAX4            Save using CCITT Group 4 fax encoding
    PDL::IO::Image::TIFF_LZW                  Save using LZW compression
    PDL::IO::Image::TIFF_JPEG                 Save using JPEG compression (8-bit greyscale and 24-bit only)
    PDL::IO::Image::TIFF_LOGLUV               Save using LogLuv compression (only available with RGBF images
    PDL::IO::Image::TARGA_SAVE_RLE            Save with RLE compression

## get\_image\_type

    my $imtype = $pimage->get_image_type;

## get\_colors\_used

    my $colors = $pimage->get_colors_used;

## get\_bpp

    my $bpp = $pimage->get_bpp;

## get\_width

    my $w = $pimage->get_width;

## get\_height

    my $h = $pimage->get_height;

## get\_dots\_per\_meter\_x

    my $dpmx = $pimage->get_dots_per_meter_x;

## set\_dots\_per\_meter\_x

    $pimage->set_dots_per_meter_x($res);

## get\_dots\_per\_meter\_y

    my $dpmy = $pimage->get_dots_per_meter_y;

## set\_dots\_per\_meter\_y

    $pimage->set_dots_per_meter_y($res);

## get\_color\_type

    my $coltype = $pimage->get_color_type;

## is\_transparent

    my $bool = $pimage->is_transparent;

## get\_transparent\_index

    my $idx = $pimage->get_transparent_index;

## set\_transparent\_index

    $pimage->set_transparent_index($index);

## flip\_horizontal

    $pimage->flip_horizontal;

## flip\_vertical

    $pimage->flip_vertical;

## rotate

    $pimage->rotate($angle);

## rescale

    $pimage->rescale($dst_width, $dst_height, $filter);
    #or
    $pimage->rescale($dst_width, 0);
    #or
    $pimage->rescale(0, $dst_height);

## rescale\_pct

    $pimage->rescale($dst_width_pct, $dst_height_pct, $filter);
    #or
    $pimage->rescale($dst_width_pct, 0);
    #or
    $pimage->rescale(0, $dst_height_pct);

## convert\_image\_type

    $pimage->convert_image_type($image_type, $scale_linear);
    #or
    $pimage->convert_image_type($image_type);

`$image_type` - string identifying image type (e.g. `'BITMAP'` - for valid values see <L/"Supported image types">).

## adjust\_colors

    $pimage->adjust_colors($brightness, $contrast, $gamma, $invert);

## tone\_mapping

    $pimage->tone_mapping($tone_mapping_operator, $param1, $param2);
    # $tone_mapping_operator
    #    0 = Adaptive logarithmic mapping (F. Drago, 2003)
    #    1 = Dynamic range reduction inspired by photoreceptor physiology (E. Reinhard, 2005)
    #    2 = Gradient domain high dynamic range compression (R. Fattal, 2002)

## free\_image\_version

    my $v = PDL::IO::Image->free_image_version();

## format\_list

    my @f = PDL::IO::Image->format_list();

## format\_extension\_list

    my $ext = PDL::IO::Image->format_extension_list($format);
    

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).

## format\_mime\_type

    my $mtype = PDL::IO::Image->format_mime_type($format);

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).

## format\_description

    my $desc = PDL::IO::Image->format_description($format);

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).

## format\_can\_read

    my $bool = PDL::IO::Image->format_can_read($format);

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).

## format\_can\_write

    my $bool = PDL::IO::Image->format_can_write($format);

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).

## format\_can\_export\_type

    my $bool = PDL::IO::Image->format_can_export_type($format, $image_type);

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).

`$image_type` - string identifying image type (e.g. `'BITMAP'` - for valid values see <L/"Supported image types">).

## format\_can\_export\_bpp

    my $bool = PDL::IO::Image->format_can_export_bpp($format, $bpp);

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).

`$bpp` - bits per pixel (e.g. 1, 4, 8, 16, 24, 32)

## format\_from\_mime

    my $format = PDL::IO::Image->format_from_mime($mime_type);

## format\_from\_file

    my $format = PDL::IO::Image->format_from_file($filename);

`$format` - string identifying file format (e.g. `'JPEG'` - for valid values see <L/"Supported file formats">).
