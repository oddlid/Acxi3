use strict;
use warnings;

use Test::More;
use Data::Dumper;
use Carp;

BEGIN {
   use_ok('App::Transcode::Acxi3::Util');
}
require_ok('App::Transcode::Acxi3::Util');

my $u = App::Transcode::Acxi3::Util->new();
ok(defined($u), ' new() returned something');
ok($u->isa('App::Transcode::Acxi3::Util'), ' ...and it is of the right class');

done_testing();
