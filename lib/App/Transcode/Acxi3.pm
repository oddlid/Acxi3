package App::Transcode::Acxi3;
# ABSTRACT: turns baubles into trinkets
use 5.012;
use strict;
use warnings;
use mro 'c3';

use Carp;
use Data::Dumper;
use App::Transcode::Acxi3::Util;
use App::Transcode::Acxi3::Config;
use App::Transcode::Acxi3::Logger;


our $VERSION = '3.0.1';

__PACKAGE__->new()->run() unless caller;


#---


sub new {
   my $class = shift;
   my $self = bless({@_}, $class);
   $self->init();
   return $self;
}

sub init {
   my $self = shift;
   $self->{_init_was_run} = 1;
   return $self;
}

sub run {
   my $self = shift;
}

1;
__END__
