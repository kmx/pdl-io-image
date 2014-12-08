use strict;
use warnings;

use Test::More;
use PDL;
use PDL::IO::Image;
use Test::Number::Delta within => 0.0000001;

my $expected = [
  [0 .. 12],
  [13 .. 25],
  [26 .. 38],
  [39 .. 51],
  [52 .. 64],
  [65 .. 77],
  [78 .. 90],
];

my $expected_region = [
  [27 .. 34],
  [40 .. 47],
];

for my $file (<t/bpp-8/*.*>) {
  my $pimage = PDL::IO::Image->new_from_file($file);
  is($pimage->get_image_type , "BITMAP", "get_image_type: $file");
  is($pimage->get_color_type , "PALETTE", "get_color_type: $file");
  is($pimage->get_colors_used,256, "get_colors_used: $file");
  is($pimage->get_width      , 13, "get_width: $file");
  is($pimage->get_height     ,  7, "get_height: $file");
  is($pimage->get_bpp        ,  8, "get_bpp: $file");
  my $pix = $pimage->pixels_to_pdl;
  is($pix->info, 'PDL: Byte D [13,7]', "info: $file");
  is($pix->sum, 4095, "sum: $file");
  delta_ok($pix->unpdl, $expected, "pixels: $file");
  #wread
  delta_ok(rimage($file)->unpdl, $expected, "pixels: $file");
  #region
  $pix = $pimage->pixels_to_pdl(1,8,2,3);
  is($pix->info, 'PDL: Byte D [8,2]',     "reg.info: $file");
  is($pix->sum, 592,                       "reg.sum: $file");
  delta_ok($pix->unpdl, $expected_region, "reg.pixels: $file");
  $pix = $pimage->pixels_to_pdl(1,-4,2,-3);
  is($pix->info, 'PDL: Byte D [8,2]',     "regneg.info: $file");
  is($pix->sum, 592,                       "regneg.sum: $file");
  delta_ok($pix->unpdl, $expected_region, "regneg.pixels: $file");
}

done_testing();