#!/usr/bin/perl

use strict;
use warnings;

use Gtk2::TestHelper tests => 1;

use Gtk2::Unique;

exit tests();

sub tests {
	my $message = Gtk2::UniqueMessageData->new();
	isa_ok($message, 'Gtk2::UniqueMessageData');
	
	return 0;
}
