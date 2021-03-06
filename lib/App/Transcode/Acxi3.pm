#!/usr/bin/env perl

package App::Transcode::Acxi3;
# ABSTRACT: turns baubles into trinkets
use 5.012;
use strict;
use warnings;
use mro 'c3';

use Carp;
use Data::Dumper;
use Getopt::Long qw(:config auto_version auto_help no_ignore_case);
use App::Transcode::Acxi3::Util;
use App::Transcode::Acxi3::Config;
use App::Transcode::Acxi3::Logger;


our $VERSION = '3.0.1';

#__PACKAGE__->new()->run(@ARGV) unless caller;


#---

my $_opts = {};

sub new {
   my $class = shift;
   my $self = bless({}, $class);

   $self->{_log} = App::Transcode::Acxi3::Logger->new();
   $self->{_cfg} = App::Transcode::Acxi3::Config->new();
   $self->{_log}->level($self->{_cfg}->user_settings('LOG_LEVEL'));
   
   return $self;
}

sub _getopts {
}

sub run {
   my $self = shift;
}

1;
__END__
