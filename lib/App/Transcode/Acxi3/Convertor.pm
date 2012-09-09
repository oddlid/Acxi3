package App::Transcode::Acxi3::Convertor;

use 5.012;
use strict;
use warnings;
use mro 'c3';

use Carp;
use IPC::Cmd qw(can_run run run_forked QUOTE);


sub new {
   my $class = shift;
   my %args  = @_;
   my %cfg = (
      decoder      => undef,
      decoder_args => [],
      encoder      => undef,
      encoder_args => [],
   );
   @cfg{ keys(%args) } = values(%args);    # merge defaults and params
   my $self = bless(\%cfg, $class);   # only create if not already alive
   return $self;
}




1;
__END__
