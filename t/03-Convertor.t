use strict;
use warnings;

use Test::More;
use Data::Dumper;
use Carp;

BEGIN {
   use_ok('App::Transcode::Acxi3::Convertor');
}
require_ok('App::Transcode::Acxi3::Convertor');

my $cvt = App::Transcode::Acxi3::Convertor->new();
ok(defined($cvt), ' new() returned something');
ok($cvt->isa('App::Transcode::Acxi3::Convertor'), ' ...and it is of the right class');

done_testing();
