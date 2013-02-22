use strict;
use warnings;

use Test::More;
use Data::Dumper;
use Carp;

BEGIN {
   use_ok('App::Transcode::Acxi3::Convertor');
}
require_ok('App::Transcode::Acxi3::Convertor');

my $cvt = App::Transcode::Acxi3::Convertor->new(
   decoder      => '/usr/bin/flac',
   decoder_args => '-s -d -c',
   infile       => '/home/oddee/gris.flac',
   encoder      => '/usr/bin/lame',
   encoder_args => '-h -V 6 --ta "Madder Mortem" --tl "Desiderata" --tt "The Flood to Come" - -o',
   outfile      => '/home/oddee/pikk.mp3',
);
ok(defined($cvt), ' new() returned something');
ok($cvt->isa('App::Transcode::Acxi3::Convertor'), ' ...and it is of the right class');

#print(Dumper($cvt->cmdline));
printf("Command: %s\n", $cvt->cmdline);

done_testing();
