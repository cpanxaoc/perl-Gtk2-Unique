#!/usr/bin/perl

use strict;
use warnings;

use Glib qw(TRUE FALSE);
use Gtk2 '-init';
use Gtk2::Unique;

my $COMMAND_PUSH = 1;
my $COMMAND_POP = 2;


exit main();


sub main {
	my ($command_id, $text) = parse_command(@ARGV);

	# As soon as we create the UniqueApp instance we either have the name we
	# requested ("org.mydomain.MyApplication", in the example) or we don't because
	# there already is an application using the same name.
	my $app = Gtk2::UniqueApp->new(
		"org.mydomain.MyApplication", undef,
		push => $COMMAND_PUSH,
		pop  => $COMMAND_POP,
	);


	# If there already is an instance running, this will return TRUE; there's no
	# race condition because the check is already performed at construction time.
	if ($app->is_running) {
		my $response = send_command($app, $command_id, $text);
		print "Command sent\n";
		return 0;
	}


	# Create the single application instance and wait for other requests
	my $window = create_application($app, $command_id, $text);
	Gtk2->main();
	
	return 0;
}


sub send_command {
	my ($app, $command_id, $text) = @_;
	my $response = $app->send_message($command_id, {text => $text});
}


#
# Called when the application needs to be created. This happens when there's no
# other instance running.
#
sub create_application {
	my ($app, $command_id, $text) = @_;

	# Standard window and windgets
	my $window = Gtk2::Window->new();
	$window->set_title("Unique - Example");
	$window->set_size_request(640, 480);
	my $textview = Gtk2::TextView->new();
	my $scroll = Gtk2::ScrolledWindow->new();
	my $buffer = $textview->get_buffer;

	if ($command_id == $COMMAND_PUSH) {
		$buffer->insert($buffer->get_end_iter, "$text\n");
	}

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


sub parse_command {
	die "Usage: --push text | --pop\n" unless @_;
	my ($operation, $text) = @_;
	
	my $command_id = 0;	
	if ($operation eq '--push') {
		die "Usage: --push text" unless defined $text;
		$command_id = $COMMAND_PUSH;
	}
	elsif ($operation eq '--pop') {
		$command_id = $COMMAND_POP;
	}
	else {
		die "Invalid command: $operation\n";
	}

	return ($command_id, $text);
}

