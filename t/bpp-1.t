use strict;
use warnings;

use Test::More;
use PDL;
use PDL::IO::Image;
use Test::Number::Delta relative=>0.0001;

my $expected = [
  [1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0],
  [1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0],
  [1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0],
  [1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0],
  [0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0],
];

for my $file (<t/bpp-1/*.*>) {
  my $pimage = PDL::IO::Image->new_from_file($file);
  is($pimage->get_image_type , "BITMAP", "get_image_type: $file");
  is($pimage->get_color_type , "MINISBLACK", "get_color_type: $file");
  is($pimage->get_colors_used, 2 , "get_colors_used: $file");
  is($pimage->get_bpp        , 1 , "get_bpp: $file");
  is($pimage->get_width      , 13, "get_width: $file");
  is($pimage->get_height     , 7 , "get_height: $file");
  my $pix = $pimage->pixels_to_pdl;
  is($pix->info, 'PDL: Byte D [13,7]', "info: $file");
  delta_ok($pix->unpdl, $expected, "pixels: $file");
}

{ # special case: PSD has inverted 0/1 values
  my $file = 't/bpp-1/special/sample-bpp-1.psd';
  my $pimage = PDL::IO::Image->new_from_file($file);
  is($pimage->get_image_type , "BITMAP", "get_image_type: $file");
  is($pimage->get_color_type , "MINISWHITE", "get_color_type: $file");
  is($pimage->get_colors_used, 2 , "get_colors_used: $file");
  is($pimage->get_bpp        , 1 , "get_bpp: $file");
  is($pimage->get_width      , 13, "get_width: $file");
  is($pimage->get_height     , 7 , "get_height: $file");
  my $pix = $pimage->pixels_to_pdl;
  $pix = 1 - $pix; # invert values
  is($pix->info, 'PDL: Byte D [13,7]', "info: $file");
  delta_ok($pix->unpdl, $expected, "pixels: $file");
}

done_testing();