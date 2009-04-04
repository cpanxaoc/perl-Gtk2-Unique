#include "unique-perl.h"


MODULE = Gtk2::UniqueMessageData  PACKAGE = Gtk2::UniqueMessageData  PREFIX = unique_message_data_

PROTOTYPES: DISABLE


UniqueMessageData*
unique_message_data_new (class)
	C_ARGS: /* No args */


UniqueMessageData*
unique_message_data_copy (UniqueMessageData *message_data)


void
unique_message_data_free (UniqueMessageData *message_data)

void
unique_message_data_set (UniqueMessageData *message_data, const guchar *data, gsize length)


#const guchar*
#unique_message_data_get (UniqueMessageData *message_data, gsize *length)


gboolean
unique_message_data_set_text (UniqueMessageData *message_data, const gchar *str, gssize length)


gchar *
unique_message_data_get_text (UniqueMessageData *message_data)


#gboolean
#unique_message_data_set_uris (UniqueMessageData *message_data, gchar **uris)


#gchar **
#unique_message_data_get_uris (UniqueMessageData *message_data)


void
unique_message_data_set_filename (UniqueMessageData *message_data, const gchar *filename)


gchar *
unique_message_data_get_filename (UniqueMessageData *message_data)


GdkScreen *
unique_message_data_get_screen (UniqueMessageData *message_data)


const gchar *
unique_message_data_get_startup_id (UniqueMessageData *message_data)


guint
unique_message_data_get_workspace (UniqueMessageData *message_data)
