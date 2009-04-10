#include "unique-perl.h"


MODULE = Gtk2::UniqueApp  PACKAGE = Gtk2::UniqueApp  PREFIX = unique_app_

PROTOTYPES: DISABLE


UniqueApp*
unique_app_new (class, const gchar *name, const gchar_ornull *startup_id, ...)
	ALIAS:
		Gtk2::UniqueApp::new_with_commands = 1
	
	PREINIT:
		UniqueApp *app;
		
	CODE:
		PERL_UNUSED_VAR(ix);

		if (items == 3) {
			app = unique_app_new(name, startup_id);
		}
		else if (items > 3 && (items % 2 == 1)) {
			/* Calling unique_app_new_with_command(), First create a new app with
			   unique_app_new() and the populate the commands one by one with
			   unique_app_add_command().
			 */
			int i;
			app = unique_app_new(name, startup_id);

			for (i = 3; i < items; i += 2) {
				SV *command_name_sv = ST(i);
				SV *command_id_sv = ST(i + 1);
				gchar *command_name = NULL;
				gint command_id;

				if (! looks_like_number(command_id_sv)) {
					g_object_unref(G_OBJECT(app));
					croak("Invalid command_id at position %d, expected a number", i + 2);
				}
				command_name = SvGChar(command_name_sv);
				command_id = SvIV(command_id_sv);
				unique_app_add_command(app, command_name, command_id);
			}
		}
		else {
			croak("Usage: Gtk2::UniqueApp->new(name, startup_id) or Gtk2::UniqueApp->new_with_commands(name, startup_id, @commands)");
		}

		RETVAL = app;
	OUTPUT:
		RETVAL


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
	OUTPUT:
		RETVAL

