-- Version : French ( by LenweSaralonde )
-- Last Update : 24/02/2026

if (GetLocale() == "frFR") then
	ECHOPULSE_LOAD = "EchoPulse VERSION chargé. Tapez /pulsehelp pour obtenir de l'aide."

	ECHOPULSE_STATS = "\"MESSAGE\" est envoyé toutes les RATE secondes dans le canal /CHANNEL."

	ECHOPULSE_MESSAGE = "Le message est maintenant \"MESSAGE\"."
	ECHOPULSE_RATE = "Le message est envoyé toutes les RATE secondes."
	ECHOPULSE_CHANNEL = "Le message est envoyé dans le canal /CHANNEL."
	ECHOPULSE_CHANNEL_LIST = "Canaux actifs : CHANNELS"
	ECHOPULSE_CHANNEL_ADD = "Le canal /CHANNEL a été ajouté à la liste."
	ECHOPULSE_CHANNEL_REM = "Le canal /CHANNEL a été retiré de la liste."

	ECHOPULSE_ACTIVE = "EchoPulse est activé."
	ECHOPULSE_INACTIVE = "EchoPulse est désactivé."

	ECHOPULSE_ERR_CHAN = "Le canal /CHANNEL est invalide."
	ECHOPULSE_ERR_RATE = "Vous ne pouvez pas envoyer de messages à moins de RATE secondes d'intervalle."

	ECHOPULSE_HELP = {
		"===================== Echo Pulse =====================",
		"/pulse [on|off] : Démarre / arrête l'envoi du message.",
		"/pulsemsg <message> : Définit le message à envoyer.",
		"/pulsechan <canal> : Ajoute / retire el canal de la liste.",
		"/pulserate <durée> : Définit la période (en secondes) d'envoi du message.",
		"/pulseinfo : Affiche les paramètres.",
		"/pulsehelp : Affiche ce message d'aide.",
		"/pulseconfig : Ouvre le panneau de configuration.",
	}

	ECHOPULSE_CONFIG_TITLE = "Configuration d'EchoPulse"
	ECHOPULSE_CONFIG_DESC = "Gérer plusieurs messages et canaux."
	ECHOPULSE_ADD = "Ajouter une entrée"
	ECHOPULSE_DELETE = "Supprim."
	ECHOPULSE_COL_ACTIVE = "Actif"
	ECHOPULSE_COL_CHAN = "Canal"
	ECHOPULSE_COL_MSG = "Message"
	ECHOPULSE_COL_RATE = "Freq (s)"

	ECHOPULSE_OPT_COMBAT = "Pause en Combat"
	ECHOPULSE_OPT_INSTANCE = "Pause en Instance"
	ECHOPULSE_TIP_COMBAT = "Met automatiquement en pause l'envoi de messages pendant un combat."
	ECHOPULSE_TIP_INSTANCE = "Met automatiquement en pause l'envoi de messages dans un donjon, raid, ou arène."

	ECHOPULSE_OPT_AFK = "Pause si absent (AFK)"
	ECHOPULSE_TIP_AFK = "Met automatiquement en pause l'envoi de messages lorsque vous êtes Abs."

	ECHOPULSE_COL_CITY = "Ville"
	ECHOPULSE_TIP_CITY = "Si coché, ce message ne sera envoyé que lorsque vous êtes dans une capitale (Sanctuaire/Auberge)."

	ECHOPULSE_OPT_RNG = "Humaniser (RNG)"
	ECHOPULSE_TIP_RNG = "Ajoute une variation aléatoire (en secondes) à chaque message pour simuler un humain et déjouer les anti-spams."
	ECHOPULSE_OPT_VARIANCE = "Variance (s)"
	ECHOPULSE_TIP_VARIANCE = "Nombre maximum de secondes (+ ou -) dont le délai peut différer à chaque envoi."
end
