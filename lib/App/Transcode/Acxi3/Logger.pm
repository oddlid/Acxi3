package App::Transcode::Acxi3::Logger;

use 5.012;
use strict;
use warnings;
use mro 'c3';

use Carp;

use constant ERR    => 0;
use constant WARN   => 1;
use constant NOTICE => 2;
use constant INFO   => 3;
use constant DEBUG  => 4;

my @_lstr = ('ERROR: ', 'WARNING: ', 'NOTICE: ', 'INFO: ', 'DEBUG: ',);

sub new {
   my $class = shift;
   my $level = shift || NOTICE;
   my $fh    = shift;

   return bless({ _level => $level, _fh => $fh }, $class);
}

sub fh {
   my $self = shift;
   if (@_) {
      $self->{_fh} = shift;
   }
   # Set and return current or default in one fell swoop
   return $self->{_fh} //= *STDOUT{IO};
}

sub level {
   my $self = shift;
   if (@_) {
      my $lvl = shift;
      if ($lvl >= ERR && $lvl <= DEBUG) {
         $self->{_level} = $lvl;
      }
   }
   return $self->{_level} //= WARN;
}

sub is {
   # Use like this:
   # if ($self->is(DEBUG)) ...
   my $self  = shift;
   my $level = shift;
   return $self->{_level} == $level;
}

sub is_debug {
   return shift()->is(DEBUG);
}

sub is_info {
   return shift()->is(INFO);
}

sub is_notice {
   return shift()->is(NOTICE);
}

sub is_warn {
   return shift()->is(WARN);
}

sub is_err {
   return shift()->is(ERR);
}

sub log_time {
   my $self = shift;
   my $fmt = shift || "%04d-%02d-%02d_%02d:%02d:%02d: ";
   my ($sec, $min, $hour, $day, $mon, $year) = localtime;
   return sprintf($fmt, $year + 1900, $mon + 1, $day, $hour, $min, $sec);
}

sub print {
   my $self = shift;
   my $fh   = $self->fh();
   printf($fh @_);
}

sub log {
   my $self  = shift;
   my $level = shift || confess("Usage: \$obj->log(>level<, message, ...): $!");
   my $msg   = shift || confess("Usage: \$obj->log(level, >message<, ...): $!");

   return if ($level > $self->level());

   $self->print($self->log_time() . $_lstr[$level] . $msg, @_);
}

sub debug {
   shift()->log(DEBUG, @_);
}

sub info {
   shift()->log(INFO, @_);
}

sub notice {
   shift()->log(NOTICE, @_);
}

sub warn {
   shift()->log(WARN, @_);
}

sub error {
   shift()->log(ERR, @_);
}

1;

__END__
