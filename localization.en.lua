-- Version : English (default) ( by LenweSaralonde )
-- Last Update : 22/05/2006


ECHOPULSE_LOAD = "EchoPulse VERSION loaded. Type /pulsehelp for help."

ECHOPULSE_STATS = "\"MESSAGE\" is sent every RATE seconds in channel /CHANNEL."

ECHOPULSE_MESSAGE = "The message is now \"MESSAGE\"."
ECHOPULSE_RATE = "The message is now sent every RATE seconds."
ECHOPULSE_CHANNEL = "The message is now sent in channel /CHANNEL."
ECHOPULSE_CHANNEL_LIST = "Active channels: CHANNELS"
ECHOPULSE_CHANNEL_ADD = "Channel /CHANNEL added to the list."
ECHOPULSE_CHANNEL_REM = "Channel /CHANNEL removed from the list."

ECHOPULSE_ACTIVE = "EchoPulse is enabled."
ECHOPULSE_INACTIVE = "EchoPulse is disabled."

ECHOPULSE_ERR_CHAN = "The channel /CHANNEL doesn't exist."
ECHOPULSE_ERR_RATE = "You can't send messages less than every RATE seconds."
ECHOPULSE_HELP = {
	"===================== Echo Pulse =====================",
	"/pulse [on|off] : Start / stops sending the message.",
	"/pulsemsg <message> : Sets the message.",
	"/pulsechan <channel> : Adds / removes the channel from the list.",
	"/pulserate <duration> : Sets the period (in seconds).",
	"/pulseinfo : Displays parameters.",
	"/pulsehelp : Displays this help message.",
	"/pulseconfig : Opens the configuration panel.",
}

ECHOPULSE_CONFIG_TITLE = "EchoPulse Configuration"
ECHOPULSE_CONFIG_DESC = "Manage multiple messages and channels."
ECHOPULSE_ADD = "Add New Entry"
ECHOPULSE_DELETE = "Delete"
ECHOPULSE_COL_ACTIVE = "On"
ECHOPULSE_COL_CHAN = "Channel"
ECHOPULSE_COL_MSG = "Message"
ECHOPULSE_COL_RATE = "Rate (s)"

ECHOPULSE_OPT_COMBAT = "Pause in Combat"
ECHOPULSE_OPT_INSTANCE = "Pause in Instances"
ECHOPULSE_TIP_COMBAT = "Automatically pauses message sending while in combat."
ECHOPULSE_TIP_INSTANCE = "Automatically pauses message sending while inside a dungeon, raid, or arena."

ECHOPULSE_OPT_AFK = "Pause when AFK"
ECHOPULSE_TIP_AFK = "Automatically pauses message sending when you are Away from Keyboard."

ECHOPULSE_COL_CITY = "City"
ECHOPULSE_TIP_CITY = "If checked, this message will only be sent while you are in a Capital City (Sanctuary/Inn)."

ECHOPULSE_OPT_RNG = "Humanize (RNG)"
ECHOPULSE_TIP_RNG = "Adds a random variation (in seconds) to each message delay to simulate a human and bypass anti-spam algorithms."
ECHOPULSE_OPT_VARIANCE = "Variance (s)"
ECHOPULSE_TIP_VARIANCE = "Maximum amount of seconds (+ or -) the timer can vary for each dispatch."
