#include "unique-perl.h"


MODULE = Gtk2::UniqueMessageData  PACKAGE = Gtk2::UniqueMessageData  PREFIX = unique_message_data_

gchar*
unique_message_data_get_text (UniqueMessageData *message_data)


GdkScreen*
unique_message_data_get_screen (UniqueMessageData *message_data)


const gchar*
unique_message_data_get_startup_id (UniqueMessageData *message_data)


guint
unique_message_data_get_workspace (UniqueMessageData *message_data)
