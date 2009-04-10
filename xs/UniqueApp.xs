#include "unique-perl.h"


MODULE = Gtk2::UniqueApp  PACKAGE = Gtk2::UniqueApp  PREFIX = unique_app_

PROTOTYPES: DISABLE


UniqueApp*
unique_app_new (class, const gchar *name, const gchar_ornull *startup_id)
	C_ARGS: name, startup_id


#UniqueApp*
#unique_app_new_with_commands (class, const gchar *name, const gchar_ornull *startup_id, const gchar *first_command_name, ...)
#	C_ARGS: name, startup_id, first_command_name, VA_ARGS


void
unique_app_add_command (UniqueApp *app, const gchar *command_name, gint command_id)


void
unique_app_watch_window (UniqueApp *app, GtkWindow *window)


gboolean
unique_app_is_running (UniqueApp *app)


UniqueResponse
unique_app_send_message (UniqueApp *app, gint command_id, HV *data)
	PREINIT:
		UniqueMessageData *message;
		SV **s;
	CODE:
		g_print("send_message()\n");
		if (data) {
			message = unique_message_data_new();
			if ((s = hv_fetch(data, "text", 4, 0)) && SvOK(*s)) {
				g_print("Set message text to: %s\n", SvGChar(*s));
				unique_message_data_set_text(message, SvGChar(*s), sv_len(*s));
			}
			else if ((s = hv_fetch(data, "uris", 4, 0)) && SvOK(*s)) {
				gchar **uris = NULL;
				gsize length;
				AV *av = NULL;
				int i;

				if (SvTYPE(SvRV(*s)) != SVt_PVAV) {
					croak("Field 'uris' must point to an hash ref");
				}

				/* Convert the Perl array into a C array of strings */
				av = (AV*) SvRV(*s);
				length = av_len(av) + 1;
				
				uris = g_new0(gchar *, length);
				g_print("Set message uris to: %s\n", SvGChar(*s));
				for (i = 0; i < length - 1; ++i) {
					SV **string = av_fetch(av, i, FALSE);
					uris[i] = SvGChar(*string);
				}
				uris[length - 1] = NULL;

				unique_message_data_set_uris(message, uris);
				g_free(uris);
			}
			else if ((s = hv_fetch(data, "filename", 8, 0)) && SvOK(*s)) {
				g_print("Set message filename to: %s\n", SvGChar(*s));
				unique_message_data_set_text(message, SvGChar(*s), sv_len(*s));
			}
		}
		else {
			message = NULL;		
		}
		RETVAL = unique_app_send_message(app, command_id, message);
		if (message) {
			unique_message_data_free(message);
		}

