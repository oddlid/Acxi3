use strict;
use warnings;

use Test::More;
use Data::Dumper;

BEGIN {
   use_ok('App::Transcode::Acxi3::Logger');
}
require_ok('App::Transcode::Acxi3::Logger');

my $log = App::Transcode::Acxi3::Logger->new();
ok(defined($log), ' new() returned something');
ok($log->isa('App::Transcode::Acxi3::Logger'), ' and it is of the right class');
is($log->level(0), 0, ' level(0)');
is($log->level(1), 1, ' level(1)');
is($log->level(2), 2, ' level(2)');
is($log->level(3), 3, ' level(3)');
is($log->level(4), 4, ' level(4)');
# Now the level should be set to DEBUG (4)
ok($log->is_debug(), ' level set to DEBUG');

#$log->fh(*STDERR{IO});
#$log->debug("Logging at lvl DEBUG\n");

done_testing();

