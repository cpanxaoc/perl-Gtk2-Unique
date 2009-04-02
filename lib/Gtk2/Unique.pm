package Gtk2::Unique;

=head1 NAME

Gtk2::Unique - Use single instance applications

=head1 SYNOPSIS

	use Gtk2 '-init';
	use Gtk2::Unique;

=head1 DESCRIPTION

Gtk2::Unique is a Perl binding for the C library libunique which provides a
way for writing single instance application. If you launch a single instance
application twice, the second instance will either just quit or will send a
message to the running instance.

For more information about libunique see:
L<http://live.gnome.org/LibUnique>.

=head1 AUTHORS

Emmanuel Rodriguez E<lt>potyl@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 by Emmanuel Rodriguez.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

use warnings;
use strict;

our $VERSION = '0.01';

use base 'DynaLoader';

use Gtk2;


sub dl_load_flags { $^O eq 'darwin' ? 0x00 : 0x01 }

__PACKAGE__->bootstrap($VERSION);

1;

