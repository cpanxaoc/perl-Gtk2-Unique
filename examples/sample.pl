#!/usr/bin/perl

use strict;
use warnings;

use Glib qw(TRUE FALSE);
use Gtk2 '-init';
use Gtk2::Unique;

my $COMMAND_WRITE = 1;


exit main();


sub main {
	die "Usage: message\n" unless @ARGV;
	my ($text) = @ARGV;

	# As soon as we create the UniqueApp instance we either have the name we
	# requested ("org.mydomain.MyApplication", in the example) or we don't because
	# there already is an application using the same name.
	my $app = Gtk2::UniqueApp->new(
		"org.mydomain.MyApplication", undef,
		write => $COMMAND_WRITE,
	);


	# If there already is an instance running, this will return TRUE; there's no
	# race condition because the check is already performed at construction time.
	if ($app->is_running) {
		my $response = $app->send_message($COMMAND_WRITE, {text => $text});
		print "Command sent\n";
		return 0;
	}


	# Create the single application instance and wait for other requests
	my $window = create_application($app, $text);
	eval {
		Gtk2->main();
	};
	if (my $error = $@) {
		warn "Error: $error";
	}
	
	return 0;
}


#
# Called when the application needs to be created. This happens when there's no
# other instance running.
#
sub create_application {
	my ($app, $text) = @_;

	# Standard window and windgets
	my $window = Gtk2::Window->new();
	$window->set_title("Unique - Example");
	$window->set_size_request(640, 480);
	my $textview = Gtk2::TextView->new();
	my $scroll = Gtk2::ScrolledWindow->new();
	my $buffer = $textview->get_buffer;

	$buffer->insert($buffer->get_end_iter, "$text\n");

	# Widget packing
	$scroll->add($textview);
	$window->add($scroll);
	$window->show_all();

	# Widget signals
	$window->signal_connect(destroy => sub {
		Gtk2->main_quit();
	});


	# Listen for new commands
	$app->watch_window($window);
	$app->signal_connect('message-received' => sub {
		my ($app, $command, $message, $time) = @_;
		$window->hide();
		print "Got a command @_\n";
		
		# Must return a "Gtk2::UniqueResponse"
		return "ok";
	});
	return $window;
}
