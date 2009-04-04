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
unique_app_send_message (UniqueApp *app, gint command_id, UniqueMessageData_ornull *message_data)
