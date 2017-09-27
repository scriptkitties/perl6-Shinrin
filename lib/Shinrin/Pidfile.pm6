#! /usr/bin/env false

use v6.c;

unit module Shinrin::Pidfile;

my IO::Path $pidfile = "/var/run/shinrin/shinrind.pid".IO;

sub cleanup-pidfile() is export
{
	if (! $pidfile.e) {
		# No pidfile, exit immediately
		exit 0;
	}

	# Check if this pidfile is ours
	my Str $pid = slurp $pidfile;

	if ($pid.Int == $*PID) {
		# Remove the pidfile
		$pidfile.unlink;
	}

	# Exit gracefully at last
	exit 0;
}
