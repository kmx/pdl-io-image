use strict;
use warnings;

use Test::More;
use PDL::IO::Image;


like(PDL::IO::Image->free_image_version, qr/^\d+\.\d+\.\d+/);
my @l = PDL::IO::Image->format_list;
ok(scalar(@l) > 10);
ok(PDL::IO::Image->format_can_read("jpeg"));

done_testing();