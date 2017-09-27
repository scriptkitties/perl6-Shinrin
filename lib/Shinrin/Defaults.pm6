#! /usr/bin/env false

use v6.c;

class Shinrin::Defaults
{
	my Hash $.config = {
		shinrin => {
			debug => False,
			bind-ip => "127.1",
			bind-port => 17344,
		},
		database => {
			connection => "mongodb://127.1",
			database => "shinrin",
		},
	};
}
