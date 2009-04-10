#!/usr/bin/perl

use strict;
use warnings;

use Gtk2::TestHelper tests => 18;

use Gtk2::Unique;

my $COMMAND_FOO = 1;
my $COMMAND_BAR = 2;


exit tests();


sub tests {
	tests_new();
	tests_new_with_commands();
	return 0;
}


sub tests_new {
	my $app = Gtk2::UniqueApp->new("org.example.Sample", undef);
	isa_ok($app, 'Gtk2::UniqueApp');
	
	$app->add_command(foo => $COMMAND_FOO);
	$app->add_command(bar => $COMMAND_BAR);
	
	generic_test($app);
}


sub tests_new_with_commands {

	my @commands = (
		foo => $COMMAND_FOO,
		bar => $COMMAND_BAR,
	);

	my $app = Gtk2::UniqueApp->new_with_commands("org.example.Sample", undef, @commands);
	isa_ok($app, 'Gtk2::UniqueApp');
	
	generic_test($app);

	my $pass;

	# Check that the constructor enforces ints for the command ID
	$app = undef;
	$pass = 1;	
	eval {
		$app = Gtk2::UniqueApp->new_with_commands("org.example.Sample", undef, foo => 'not-an-int');
		$pass = 0;
	};
	if (my $error = $@) {
		$pass = 1;	
	}
	ok($pass, "new_with_command() checks for IDs as int");


	# Check that the constructor enforces the argument count
	$app = undef;
	$pass = 1;	
	eval {
		$app = Gtk2::UniqueApp->new_with_commands("org.example.Sample", undef, foo => 1, 'bar');
		$pass = 0;
	};
	if (my $error = $@) {
		$pass = 1;	
	}
	ok($pass, "new_with_command() checks for argument count");

}


sub generic_test {
	my ($app) = @_;
	
	my $window = Gtk2::Window->new();
	$app->watch_window($window);
	
	ok(! $app->is_running(), "is_running()");

	my $response;
#	$response = $app->send_message($COMMAND_TEST);
#	isa_ok($response, 'Gtk2::UniqueResponse');
#	is ($response, 'invalid', "send_message(undef)");

	$response = $app->send_message($COMMAND_FOO, {text => "hello"});
	isa_ok($response, 'Gtk2::UniqueResponse');
	is ($response, 'invalid', "send_message(text)");

	$response = $app->send_message($COMMAND_FOO, {filename => __FILE__});
	isa_ok($response, 'Gtk2::UniqueResponse');
	is ($response, 'invalid', "send_message(filename)");

	$response = $app->send_message($COMMAND_FOO, {uris => [
		'http://live.gnome.org/LibUnique',
		'http://gtk2-perl.sourceforge.net/',
	]});
	isa_ok($response, 'Gtk2::UniqueResponse');
	is ($response, 'invalid', "send_message(uris)");
}

