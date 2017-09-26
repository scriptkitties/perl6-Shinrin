#! /usr/bin/env false

use v6.c;

use BSON::Document;
use Config;
use JSON::Fast;
use MongoDB::Collection;
use MongoDB::Database;

class Shinrin::Controllers::V1
{
	has Config $.config;
	has MongoDB::Database $.database;

	method store(:%json)
	{
		# Set exception handler
		CATCH {
			default {
				.say;

				return to-json({
					ok => False,
					message => .Str,
				});
			}
		}

		# Get the data from the json request
		my %data = %json<data>;

		# Add timestamp if its missing
		if (%data<timestamp>:!exists) {
			%data<timestamp> = DateTime.now(formatter => {
				sprintf("%4d-%02d-%02dT%02d:%02d:%02dZ", .year, .month, .day, .hour, .minute, .second);
			}).utc.Str;
		}

		# TODO: Convert the "timestamp" string to something MongoDB interprets as a Date(Time)

		# Return debug data if requested
		if (%json<debug> && $!config.get("shinrin.debug", False)) {
			return to-json({
				ok => True,
				config => $!config.get,
				data => %data,
			});
		}

		# Create the new document to insert
		my BSON::Document $doc .= new((|%data));

		# Create a document to deal with the insertion
		my BSON::Document $insert .= new((
			insert => %json<collection>,
			documents => [ $doc ]
		));

		# Push document to the mongodb server
		my BSON::Document $response = $!database.run-command($insert);

		# Check for errors
		if (!$response<ok>) {
			return to-json({
				ok => False,
				message => $response
			});
		}

		# Return ok status
		to-json({
			ok => True,
			n => $response<n>
		});
	}
}
