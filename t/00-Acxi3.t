use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
   use_ok('App::Transcode::Acxi3');
}
require_ok('App::Transcode::Acxi3');

my $ata = App::Transcode::Acxi3->new(gris => 'godt', bacon => 'nam');
print(Dumper($ata));

done_testing();
