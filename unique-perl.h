#ifndef _UNIQUE_PERL_H_

#include <gtk2perl.h>

#include <unique/unique.h>


/* Custom definitions for the bindings of Gtk2::UniqueMessageData */
typedef UniqueMessageData UniqueMessageData_ornull;
SV* newSVUniqueMessageData (UniqueMessageData *message);
UniqueMessageData* SvUniqueMessageData (SV *data);
# define SvUniqueMessageData_ornull(sv)	(gperl_sv_is_defined (sv) ? SvUniqueMessageData(sv) : NULL)
# define newSVUniqueMessageData_ornull(val)	(((val) == NULL) ? &PL_sv_undef : gperl_new_object (G_OBJECT (val), FALSE))


#include "unique-autogen.h"

#endif /* _UNIQUE_PERL_H_ */
