use strict;
use warnings;

use Test::More;
use Data::Dumper;
use Carp;

# App::Transcode::Acxi3::Config also uses App::Transcode::Acxi3::Util, and so it's tested implicitly

BEGIN {
   use_ok('App::Transcode::Acxi3::Config');
   use_ok('App::Transcode::Acxi3::Logger');
}
require_ok('App::Transcode::Acxi3::Config');
require_ok('App::Transcode::Acxi3::Logger');

open(my $fh, ">", "/tmp/acxi_cfg_logger.out") or confess;
my $log = App::Transcode::Acxi3::Logger->new(4, $fh);
my $cfg = App::Transcode::Acxi3::Config->new();
ok(defined($cfg), 'new() (cfg) returned something');
ok(defined($log), 'new() (log) returned something');
ok($cfg->isa('App::Transcode::Acxi3::Config'), 'and it is of the right class');
ok($log->isa('App::Transcode::Acxi3::Logger'), 'and it is of the right class');
$cfg->save("/tmp/acxi.conf");
#print(Dumper($cfg));
close($fh);

done_testing();
