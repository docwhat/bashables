#!/usr/bin/env perl

# Use strict mode.
$| = 1;

use IO::Pty;

my $pty = new IO::Pty;
defined( my $child = fork ) or exit 126;

if ($child) {
  $pty->close_slave();
  while (<$pty>) { }
  wait();

  exit 126 if ( $? == -1 );
  exit( $? >> 8 );
}
else {
  POSIX::setsid();
  close($pty);

  STDOUT->fdopen( $pty->slave, '>' ) || die $!;
  STDERR->fdopen( \*STDOUT,    '>' ) || die $!;

  exec(@ARGV) || die "Can't exec @ARGV: $!";
}

# EOF
