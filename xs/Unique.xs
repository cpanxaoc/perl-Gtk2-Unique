#include "unique-perl.h"


MODULE = Gtk2::Unique  PACKAGE = Gtk2::Unique  PREFIX = unique_

PROTOTYPES: DISABLE


BOOT:
#include "register.xsh"
#include "boot.xsh"


guint
MAJOR_VERSION ()
	CODE:
		RETVAL = UNIQUE_MAJOR_VERSION;

	OUTPUT:
		RETVAL


guint
MINOR_VERSION ()
	CODE:
		RETVAL = UNIQUE_MINOR_VERSION;

	OUTPUT:
		RETVAL


guint
MICRO_VERSION ()
	CODE:
		RETVAL = UNIQUE_MICRO_VERSION;

	OUTPUT:
		RETVAL


void
GET_VERSION_INFO (class)
	PPCODE:
		EXTEND (SP, 3);
		PUSHs (sv_2mortal (newSViv (UNIQUE_MAJOR_VERSION)));
		PUSHs (sv_2mortal (newSViv (UNIQUE_MINOR_VERSION)));
		PUSHs (sv_2mortal (newSViv (UNIQUE_MICRO_VERSION)));
		PERL_UNUSED_VAR (ax);


gboolean
CHECK_VERSION (class, guint major, guint minor, guint micro)
	CODE:
		RETVAL = UNIQUE_CHECK_VERSION (major, minor, micro);

	OUTPUT:
		RETVAL


const gchar*
VERSION ()

	CODE:
		RETVAL = UNIQUE_VERSION_S;

	OUTPUT:
		RETVAL


guint
VERSION_HEX ()

	CODE:
		RETVAL = UNIQUE_VERSION_HEX;

	OUTPUT:
		RETVAL


const gchar*
API_VERSION ()

	CODE:
		RETVAL = UNIQUE_API_VERSION_S;

	OUTPUT:
		RETVAL


const gchar*
PROTOCOL_VERSION ()

	CODE:
		RETVAL = UNIQUE_PROTOCOL_VERSION_S;

	OUTPUT:
		RETVAL


const gchar*
DEFAULT_BACKEND ()

	CODE:
		RETVAL = UNIQUE_DEFAULT_BACKEND_S;

	OUTPUT:
		RETVAL
