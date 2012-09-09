package App::Transcode::Acxi3::Util;

use 5.012;
use strict;
use warnings;
use mro 'c3';

use Carp;
use Fcntl;
use IO::File;
use IO::Handle;
use File::Spec;
use IPC::Cmd qw(can_run run run_forked QUOTE);
use App::Transcode::Acxi3::Logger;

use constant F_BASE      => 0x0001;
use constant F_SRC_EXIST => F_BASE << 1;
use constant F_DST_EXIST => F_BASE << 2;
use constant F_SRC_AGE   => F_BASE << 3;
use constant F_DST_AGE   => F_BASE << 4;

my $_singleton;
my $_log;

sub new {
   my $class = shift;
   my %args  = @_;
   my %cfg   = (
      mime_types => [],
      xfile      => undef,
      #path       => [ split(/:/, $ENV{PATH}) ],
      cur_mime   => undef,
   );
   @cfg{ keys(%args) } = values(%args);    # merge defaults and params
   $_singleton //= bless(\%cfg, $class);   # only create if not already alive
   $_singleton->{xfile} = $_singleton->which($_singleton->{xfile});
   return $_singleton;
}

#sub log {
#   return $_log //= App::Transcode::Acxi3::Logger::get_instance();
#}

sub which {
   my $self = shift;
   my $app  = shift;
   my $ret  = IPC::Cmd::can_run($app);
#   if ($ret) {
#      $self->log()->debug(qq(Found app "%s" at "%s"\n), $app, $ret);
#   }
#   else {
#      $self->log()->warn(qq(Unable to find executable: "%s"\n), $app);
#   }
   return $ret;
}

sub mtime {
   my $self  = shift;
   my $sfile = shift;
   my $dfile = shift;
   my $flags = F_BASE;

   $self->{stat}{src} = my $s = stat($sfile);
   $self->{stat}{dst} = my $d = stat($dfile);

   $flags |= F_SRC_EXIST if ($s);
   $flags |= F_DST_EXIST if ($d);
   return $flags if (!$s);

   if ($s && $d && $s->{mtime} > $d->{mtime}) {
      $flags |= F_SRC_AGE;
   }
   elsif ($s && $d && $s->{mtime} == $d->{mtime}) {
      $flags |= F_SRC_AGE | F_DST_AGE;
   }
   elsif ($s && $d && $s->{mtime} < $d->{mtime}) {
      $flags |= F_DST_AGE;
   }
   return $flags;
}

sub statbuf {
   # Return cached result of the last stat, src or dst file, depending on arg $trg
   # Might be undef if mtime has not yet been run
   my $self = shift;
   my $trg = shift || 0;
   return $trg ? $self->{stat}{dst} : $self->{stat}{src};
}

sub fext {
   my $self   = shift;
   my $rfname = scalar reverse shift;
   my ($ext) = $rfname =~ /(\S*?)\./;
   return unless (defined($ext));
   return lc reverse $ext;
}

sub exec_read_kv {
   # Opens a pipe to the output of given command, and splits the output
   # in key / value format and returns it as a hash reference.
   # The most common denominator in reading tags.
   my $self  = shift;
   my $cmd   = shift;
   my $kvsep = shift;    # key/value separator in input from pipe
   my %ret;
   open(my $fh, "-|", $cmd) || croak;
   while (defined(my $line = <$fh>)) {
      chomp($line);
      my ($k, $v) = split(/$kvsep/, $line);
      $ret{$k} = $v;
   }
   close($fh) or croak;
   return \%ret;
}

sub cur_mime {
   return shift()->{cur_mime};
}

sub get_mime {
   my $self = shift;
   my $file = shift;
   chomp($self->{cur_mime} = qx/$self->{xfile} -bi "$file"/);
   $self->{cur_mime} =~ s/;.*//;
   return $self->{cur_mime};
}

sub check_mime {
   my $self = shift;
   my $type = shift;
   my $file = shift;
   return ($self->get_mime($file) eq $self->{mime_types}{$type});
}

sub spawn {
   my $self    = shift;
   my $coderef = shift;
   return unless (ref($coderef) eq 'CODE');
   my $pid;
   return unless (defined($pid = fork()));
   return if ($pid);
   #push(@{$self->{child_pids}}, $pid);
   exit($coderef->());
}


1;
__END__
