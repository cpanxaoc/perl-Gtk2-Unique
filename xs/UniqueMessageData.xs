#include "unique-perl.h"


/**
 * Since UniqueMessageData ais not a registered type, we create a hasref that
 * contains the message data.
 */


SV*
newSVUniqueMessageData (UniqueMessageData *message) {
	HV *h;
	SV *sv;
	HV *stash;
	SV *value;
	gchar *text;
	
	if (! message) {
		return newSVsv(&PL_sv_undef);
	}
	
	h = newHV ();
	sv = newRV_noinc((SV *) h);	/* safe */
	
	/* Copy all data members of the struct to the hash */
	text = unique_message_data_get_text(message);
	g_print("text = %p\n", text);
	if (text) {
		value = newSVGChar(text);
		g_print("text = %p\n", value);
		hv_store(h, "text", 4, value, 0);
	}
	/*hv_store(h, "uris", 4, newSVGChar(unique_message_data_get_text(message)), 0);*/
	hv_store(h, "filename", 8, newSVGChar(unique_message_data_get_filename(message)), 0);
	hv_store(h, "screen", 6, newSVGdkScreen(unique_message_data_get_screen(message)), 0);
	hv_store(h, "startup_id", 10, newSVGChar(unique_message_data_get_startup_id(message)), 0);
	/*hv_store(h, "workspace", 9, newSVGUInt(unique_message_data_get_workspace(message)), 0);*/

	/* Bless this stuff */
	stash = gv_stashpv("Gtk2::UniqueMessageData", TRUE);
	sv_bless(sv, stash);
	
	return sv;
}


UniqueMessageData*
SvUniqueMessageData (SV *data) {
	HV *h;
	SV **s;
	UniqueMessageData *message;
	gboolean is_valid = FALSE;

	if ((!data) || (!SvOK(data)) || (!SvRV(data)) || (SvTYPE(SvRV(data)) != SVt_PVHV)) {
		croak("SvUniqueMessageData: value must be an hashref");
	}

	h = (HV *) SvRV(data);
	
	/*
	 * We must set at least one of the following keys:
	 *   - text
	 *   - uris
	 *   - filename
	 */
	message = unique_message_data_new();
	if (! ((s = hv_fetch(h, "text", 4, 0)) && SvOK(*s))) {
		is_valid = TRUE;
		unique_message_data_set_text(message, SvGChar(*s), sv_len(*s));
	}
	if (! ((s = hv_fetch(h, "uris", 4, 0)) && SvOK(*s))) {
		is_valid = TRUE;
		/* unique_message_data_set_uris(message, SvGChar(*s)); */
	}
	if (! ((s = hv_fetch(h, "filename", 8, 0)) && SvOK(*s))) {
		is_valid = TRUE;
		unique_message_data_set_filename(message, SvGChar(*s));
	}
	
	if (! is_valid) {
		unique_message_data_free(message);
		croak("SvUniqueMessageData: requires at least one of the following keys: 'text', 'uris' or 'filename'");
	}

	return message;
}



MODULE = Gtk2::UniqueMessageData  PACKAGE = Gtk2::UniqueMessageData  PREFIX = unique_message_data_

PROTOTYPES: DISABLE


UniqueMessageData*
unique_message_data_new (class)
	C_ARGS: /* No args */


UniqueMessageData*
unique_message_data_copy (UniqueMessageData *message_data)

#FIXME have perl unref the message through this function
#void
#unique_message_data_free (UniqueMessageData *message_data)


void
# FIXME guchar_ornull doesn't exist
unique_message_data_set (UniqueMessageData *message_data, const guchar *data, gsize length)


#const guchar_ornull*
#unique_message_data_get (UniqueMessageData *message_data, gsize *length)


gboolean
unique_message_data_set_text (UniqueMessageData *message_data, const gchar *str, gssize length)


gchar*
unique_message_data_get_text (UniqueMessageData *message_data)


#gboolean
#unique_message_data_set_uris (UniqueMessageData *message_data, gchar **uris)
# SEE: gtk_about_dialog_set_authors

#gchar**
#unique_message_data_get_uris (UniqueMessageData *message_data)
# SEE: g_key_file_get_groups

void
unique_message_data_set_filename (UniqueMessageData *message_data, const gchar *filename)


gchar*
unique_message_data_get_filename (UniqueMessageData *message_data)


GdkScreen*
unique_message_data_get_screen (UniqueMessageData *message_data)


const gchar*
unique_message_data_get_startup_id (UniqueMessageData *message_data)


guint
unique_message_data_get_workspace (UniqueMessageData *message_data)
