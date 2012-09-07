use strict;
use warnings;

use Test::More;
use Data::Dumper;

# App::Transcode::Acxi3::Config also uses App::Transcode::Acxi3::Util, and so it's tested implicitly

BEGIN {
   use_ok('App::Transcode::Acxi3::Config');
}
require_ok('App::Transcode::Acxi3::Config');
my $cfg = App::Transcode::Acxi3::Config->new();
ok(defined($cfg), ' new() returned something');
ok($cfg->isa('App::Transcode::Acxi3::Config'), ' and it is of the right class');
$cfg->save("/tmp/acxi.conf");
#print(Dumper($cfg));

done_testing();
