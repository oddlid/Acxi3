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
   my %cfg   = (
      decoder      => undef,
      decoder_args => [],
      infile       => undef,
      encoder      => undef,
      encoder_args => [],
      outfile      => undef,
   );
   @cfg{ keys(%args) } = values(%args);    # merge defaults and params
   my $self = bless(\%cfg, $class);        # only create if not already alive
   return $self;
}

sub cmdline {
   my $self = shift;
   return sprintf(
      "%s %s %s | %s %s %s",
      $self->{decoder}, $self->{decoder_args}, QUOTE . $self->{infile} . QUOTE,
      $self->{encoder}, $self->{encoder_args}, QUOTE . $self->{outfile} . QUOTE
   );
}

sub run {
   my $self = shift;
   return run_forked($self->cmdline, @_);
}

1;
__END__
