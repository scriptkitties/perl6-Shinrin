#! /usr/bin/env false

use v6.c;

class Shinrin::Defaults
{
	my Hash $.config = {
		shinrin => {
			debug => True,
		},
		database => {
			connection => "mongodb://127.1",
			database => "shinrin",
		},
		bind => {
			ip => "127.1",
			port => 17344,
		}
	};
}
