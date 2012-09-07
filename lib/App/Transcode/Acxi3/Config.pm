package App::Transcode::Acxi3::Config;

use 5.012;
use strict;
use warnings;
use mro 'c3';

use Carp;
use IO::Handle;
use IO::File;
use File::Basename;
use File::Spec;
use Data::Dumper;
use App::Transcode::Acxi3::Util;

my $_defaults = {
   cfgfile_system => '/etc/acxi.conf',
   cfgfile_user   => "$ENV{HOME}/.acxi.conf",
   user_settings  => {
      LOG_LEVEL         => 1,                          # See Logger for levels
      QUALITY           => 7,
      DIR_PREFIX_SOURCE => "$ENV{HOME}",
      DIR_PREFIX_DEST   => "$ENV{HOME}/acxi_output",
      INPUT_TYPE        => 'flac',
      OUTPUT_TYPE       => 'mp3',
      USER_TYPES        => 'png,jpg,jpeg',
      COMMAND_OGG       => 'oggenc',
      COMMAND_LAME      => 'lame',
      COMMAND_FLAC      => 'flac',
      COMMAND_METAFLAC  => 'metaflac',
      COMMAND_FILE      => 'file',
   },
   mime_types => {
      flac => 'audio/x-flac',
      ogg  => 'application/ogg',
      wav  => 'audio/x-wav',
      mp3  => 'audio/mpeg',
      #raw  => undef,
   },
   ok_in  => [qw/flac ogg wav/],
   ok_out => [qw/ogg mp3/],
};

sub new {
   my $class = shift;
   my $self = bless($_defaults, $class);
   return $self->_init();    # _init() returns a ref to $self
}

sub _init {
   my $self = shift;
   $self->load($self->{cfgfile_system});
   $self->load($self->{cfgfile_user});
   $self->{_util} = App::Transcode::Acxi3::Util->new(
      mime_types => $self->{mime_types},
      xfile      => $self->{user_settings}{COMMAND_FILE}
   );
   return $self->_locate_ext_binaries();
}

sub _locate_ext_binaries {
   my $self = shift;
   foreach my $cmd (qw/FLAC METAFLAC OGG LAME FILE/) {
      my $k = 'COMMAND_' . $cmd;
      my $v = \$self->{user_settings}{$k};
      next unless (defined($$v));
      next if (-x $$v);
      $$v = $self->{_util}->which($$v);
   }
   return $self;
}

sub load {
   my $self = shift;
   my $cfile = shift || $self->{cfgfile_system};
   return unless (-r $cfile);
   my $fh = IO::File->new($cfile, O_RDONLY);
   return unless (defined($fh));

   my $rx_valid_line = qr/\s*([A-Z_]+)\s*=\s*(\S+)/;
   while (<$fh>) {
      chomp;
      my ($k, $v) = $_ =~ /$rx_valid_line/;
      next unless (defined($k) && defined($v));
      $self->{user_settings}{$k} = $v;
   }
   undef $fh;    # closes the file

   # make USER_TYPES an array for easier use later
   my $ut = \$self->{user_settings}{USER_TYPES};
   if (defined($$ut)) {
      $$ut = [ split(/,/, $$ut) ];
   }
}

sub save {
   my $self = shift;
   my $cfile = shift || $self->{cfgfile_user};
   my @cfg;
   my $fh = IO::File->new($cfile, O_WRONLY | O_TRUNC | O_CREAT);
   return unless (defined($fh));

   while (my ($k, $v) = each(%{ $self->{user_settings} })) {
      if (ref($v) eq 'ARRAY') {
         $v = join(',', @$v);
      }
      $fh->print("$k = $v\n");
   }
   undef $fh;
}

1;
__END__
