# NAME

PDL::IO::Image - Load/save bitmap from/to PDL (via FreeImage library)

# SYNOPSIS

XXX some code examples

# DESCRIPTION

XXX

## Supported image formats

XXX png, gif, tif, ...

## Supported image types

XXX BITMAP, RGB, RGBA, FLOAT, DOUBLE, ...

# FUNCTIONS

## rimage

    my $pixels_pdl = rimage($filename);
    #or
    my $pixels_pdl = rimage($filename, \%options);
    

## rimage\_pal

    my ($pixels_pdl, $palette_pdl) = rimage($filename);
    #or
    my ($pixels_pdl, $palette_pdl) = rimage($filename, \%options);

## wimage

    $pixels_pdl->wimage($filename);
    #or
    $pixels_pdl->wimage($filename, \%options);
    #or
    $pixels_pdl->wimage($palette_pdl, $filename);
    #or
    $pixels_pdl->wimage($palette_pdl, $filename, \%options);

    wimage($pixels_pdl, $filename);
    #or
    wimage($pixels_pdl, $filename, \%options);
    #or
    wimage($pixels_pdl, $palette_pdl, $filename);
    #or
    wimage($pixels_pdl, $palette_pdl, $filename, \%options);
    

# METHODS

## new\_from\_file

    my $pimage = IO::PDL::Image->new_from_file($filename);
    #or
    my $pimage = IO::PDL::Image->new_from_file($filename, $filetype);
    #or
    my $pimage = IO::PDL::Image->new_from_file($filename, $filetype, $flags);
    #or
    my $pimage = IO::PDL::Image->new_from_file($filename, $filetype, $flags, $page);

## new\_from\_pdl

    my $pimage = IO::PDL::Image->new_from_pdl($pixels_pdl);
    #or
    my $pimage = IO::PDL::Image->new_from_pdl($pixels_pdl, $palette_pdl);
    

## pixels\_to\_pdl

    my $pixels_pdl = $pimage->pixels_to_pdl;
    #or
    my $pixels_pdl = $pimage->pixels_to_pdl($x1, $x2, $y1, $y2);

## palette\_to\_pdl

    my $palette_pdl = $pimage->palette_to_pdl;
    

## save

    $pimage->save($filename, $format, $flags);
    #or
    $pimage->save($filename, $format);
    #or
    $pimage->save($filename);

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

    $self->set_dots_per_meter_x($res);

## get\_dots\_per\_meter\_y

    my $dpmy = $pimage->get_dots_per_meter_y;

## set\_dots\_per\_meter\_y

    $self->set_dots_per_meter_y($res);

## get\_color\_type

    my $coltype = $pimage->get_color_type;

## is\_transparent

    my $bool = $pimage->is_transparent;

## get\_transparent\_index

    my $idx = $pimage->get_transparent_index;

## set\_transparent\_index

    $self->set_transparent_index($index);

## flip\_horizontal

    $self->flip_horizontal;

## flip\_vertical

    $self->flip_vertical;

## rotate

    $pimage->rotate($angle);

## rescale

    $pimage->rescale($dst_width, $dst_height, $filter);
    #or
    $pimage->rescale($dst_width);
    #or
    $pimage->rescale(undef, $dst_height);

## convert\_image\_type

    $pimage->convert_image_type($dst_image_type, $scale_linear);
    #or
    $pimage->convert_image_type($dst_image_type);
    

## tone\_mapping

    $pimage->tone_mapping($tone_mapping_operator, $param1, $param2);

## free\_image\_version

    my $v = PDL::IO::Image->free_image_version();

## format\_list

    my @f = PDL::IO::Image->format_list();

## format\_extension\_list

    my $ext = PDL::IO::Image->format_extension_list($format); 

## format\_mime\_type

    my $mtype = PDL::IO::Image->format_mime_type($format);

## format\_description

    my $desc = PDL::IO::Image->format_description($format);

## format\_can

    my $bool = PDL::IO::Image->format_can($format);

## format\_can\_read

    my $bool = PDL::IO::Image->format_can_read($format);

## format\_can\_write

    my $bool = PDL::IO::Image->format_can_write($format);

## format\_can\_export\_type

    my $bool = PDL::IO::Image->format_can_export_type($format, $imgtype);

## format\_can\_export\_bpp

    my $bool = PDL::IO::Image->format_can_export_bpp($format, $bpp);

## format\_from\_mime

    my $format = PDL::IO::Image->format_from_mime($mime_type);

## format\_from\_file

    my $format = PDL::IO::Image->format_from_file($filename);
