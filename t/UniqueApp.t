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
	
	my $response = $app->send_message($COMMAND_TEST, undef);
	is ($response, 'invalid', "send_message()");
	
	return 0;
}
