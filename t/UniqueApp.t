#!/usr/bin/perl

use strict;
use warnings;

use Gtk2::TestHelper tests => 3;

use Gtk2::Unique;

my $COMMAND_TEST = 1;

exit tests();

sub tests {
	my $app = Gtk2::UniqueApp->new("org.example.Sample", undef);
	isa_ok($app, 'Gtk2::UniqueApp');
	
	$app->add_command("test", $COMMAND_TEST);
	
	my $window = Gtk2::Window->new();
	$app->watch_window($window);
	
	ok(! $app->is_running(), "is_running()");

	my $response;
#	$response = $app->send_message($COMMAND_TEST);
#	isa_ok($response, 'Gtk2::UniqueResponse');
#	is ($response, 'invalid', "send_message(undef)");

	$response = $app->send_message($COMMAND_TEST, {text => "hello"});
	isa_ok($response, 'Gtk2::UniqueResponse');
	is ($response, 'invalid', "send_message()");

	$response = $app->send_message($COMMAND_TEST, {filename => __FILE__});
	isa_ok($response, 'Gtk2::UniqueResponse');
	is ($response, 'invalid', "send_message()");

	$response = $app->send_message($COMMAND_TEST, {uris => [
		'http://live.gnome.org/LibUnique',
		'http://gtk2-perl.sourceforge.net/',
	]});
	isa_ok($response, 'Gtk2::UniqueResponse');
	is ($response, 'invalid', "send_message()");

	return 0;
}

