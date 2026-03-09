-- Version : Spanish ( by Gemini )
-- Last Update : 22/02/2026

if (GetLocale() == "esES" or GetLocale() == "esMX") then
	ECHOPULSE_LOAD = "EchoPulse VERSION cargado. Escribe /pulsehelp para ayuda."

	ECHOPULSE_STATS = "\"MESSAGE\" se envía cada RATE segundos en el canal /CHANNEL."

	ECHOPULSE_MESSAGE = "El mensaje es ahora \"MESSAGE\"."
	ECHOPULSE_RATE = "El mensaje se envía cada RATE segundos."
	ECHOPULSE_CHANNEL = "El mensaje se envía en el canal /CHANNEL."
	ECHOPULSE_CHANNEL_LIST = "Canales activos: CHANNELS"
	ECHOPULSE_CHANNEL_ADD = "Canal /CHANNEL añadido a la lista."
	ECHOPULSE_CHANNEL_REM = "Canal /CHANNEL eliminado de la lista."

	ECHOPULSE_ACTIVE = "EchoPulse está activado."
	ECHOPULSE_INACTIVE = "EchoPulse está desactivado."

	ECHOPULSE_ERR_CHAN = "El canal /CHANNEL no existe."
	ECHOPULSE_ERR_RATE = "No puedes enviar mensajes cada menos de RATE segundos."

	ECHOPULSE_HELP = {
		"===================== Echo Pulse =====================",
		"/pulse [on|off] : Inicia / detiene el envío del mensaje.",
		"/pulsemsg <mensaje> : Define el mensaje a enviar.",
		"/pulsechan <canal> : Añade / quita el canal de la lista.",
		"/pulserate <duración> : Define el periodo (en segundos).",
		"/pulseinfo : Muestra los parámetros.",
		"/pulsehelp : Muestra este mensaje de ayuda.",
		"/pulseconfig : Abre el panel de configuración.",
	}

	ECHOPULSE_CONFIG_TITLE = "Configuración de EchoPulse"
	ECHOPULSE_CONFIG_DESC = "Gestiona múltiples mensajes y canales."
	ECHOPULSE_ADD = "Añadir Entrada"
	ECHOPULSE_DELETE = "Eliminar"
	ECHOPULSE_COL_ACTIVE = "On"
	ECHOPULSE_COL_CHAN = "Canal"
	ECHOPULSE_COL_MSG = "Mensaje"
	ECHOPULSE_COL_RATE = "Freq (s)"

	ECHOPULSE_OPT_COMBAT = "Pausar en Combate"
	ECHOPULSE_OPT_INSTANCE = "Pausar en Instancias"
	ECHOPULSE_TIP_COMBAT = "Detiene automáticamente los envíos mientras estás en combate."
	ECHOPULSE_TIP_INSTANCE = "Detiene automáticamente los envíos mientras estás dentro de una mazmorra, banda o arena."

	ECHOPULSE_OPT_AFK = "Pausar Ausente (AFK)"
	ECHOPULSE_TIP_AFK = "Detiene automáticamente los envíos cuando estás Ausente."

	ECHOPULSE_COL_CITY = "Ciudad"
	ECHOPULSE_TIP_CITY = "Si está marcado, este anuncio solo se enviará si te encuentras en una Ciudad Capital (Santuario/Posada)."

	ECHOPULSE_OPT_RNG = "Humanizar (RNG)"
	ECHOPULSE_TIP_RNG = "Añade una variación aleatoria (en segundos) a cada mensaje para simular a un humano y burlar sistemas anti-spam."
	ECHOPULSE_OPT_VARIANCE = "Varianza (s)"
	ECHOPULSE_TIP_VARIANCE = "Cantidad máxima de segundos (+ o -) que el temporizador podrá variar en cada envío."
end
