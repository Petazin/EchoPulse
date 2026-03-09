# 🗺️ ROADMAP - EchoPulse

Este documento detalla las próximas características, mejoras y correcciones planeadas para EchoPulse, divididas en categorías lógicas. El objetivo es mantener un desarrollo organizado y priorizado hacia las futuras versiones (v2.3.0+).

## 🎯 v2.3.0 - Utilidad y Seguridad (Anti-Ban)

### 🤖 1. "Pausa Inteligente" (Smart Spamming)

- [x] **Pausa Automática en Combate/Instancias**: El addon pausa automáticamente el envío de mensajes al entrar en combate o al acceder a una instacia (Mazmorra, Banda o Arena).
- [x] **Detección AFK**: Pausa automática de los anuncios cuando el estado del jugador pasa a `Ausente (AFK)`.
- [x] **Restricción por Zonas Inteligente**: Configuración por entrada para que un mensaje solo se mande estando en Ciudades Capitales (Shattrath, Orgrimmar, Stormwind). Si el jugador sale a otras zonas, se pausa automáticamente.

### 🛡️ 2. Seguridad Anti-Spam (Humanización)

- [x] **Variación de Tiempo Aleatoria (Anti-bot)**: En vez de usar intervalos matemáticamente exactos (ej. 60.0s), añadir una opción de "Variación" (ej. +/- 5s). Los mensajes se mandarán entre 55 y 65 segundos de forma aleatoria para imitar comportamiento humano.
- [ ] **Respuesta Automática a Susurros (Auto-Reply)**: Si el addon manda un mensaje comercial/reclutamiento, y recibe un susurro por una palabra clave configurada ("invite", "info", "precio") poco después, enviará una respuesta en automático al jugador o emitirá una alerta sonora fuerte para no perder la interacción.

---

## 🧊 Futuras Versiones (Backlog)

### 🎭 3. Gestión Avanzada de Mensajes

- [ ] **Sistema de Perfiles**: Permitir guardar configuraciones bajo nombres específicos (ej. "Reclutamiento", "Vendedor", "Busco Grupo") para intercambiar rápidamente toda la lista de anuncios. Capacidad de compartir perfiles a nivel de cuenta (Account-wide).
- [ ] **Rotación / Secuencias de Anuncios**: Capacidad de añadir múltiples mensajes a una sola "Entrada" para que roten de forma secuencial, previniendo los bloqueos por spam repetitivo.
- [ ] **Macros Dinámicos en Mensajes**: Uso de pseudo-variables en el texto (ej. `<zona>`, `<oro>`, `<nombre>`) que se autocompleten dinámicamente al momento de enviar el anuncio.
- [ ] **Contador de Caracteres en Vivo**: Indicador y advertencia en la GUI si el mensaje configurado superará el límite estricto de 255 caracteres de WoW TBC, previniendo cortes inesperados (especialmente útil al usar enlaces de objetos).

### 🕹️ 4. Mejoras de Interfaz (GUI) y Accesibilidad

- [ ] **Soporte LibDataBroker (Botón Minimapa)**: Integración de un icono en el minimapa (y soporte para Titan Panel/Fubar). Clic izquierdo para habilitar/deshabilitar los anuncios globalmente, clic derecho para abrir configuración.
- [ ] **Controles Visuales Rápidos**: Reemplazo o complemento de los "checkboxes" por botones "Play/Pause" estéticos para cada entrada en la tabla.
- [ ] **Historial y Estadísticas**: Nueva columna en la GUI que registre la cantidad total de veces que se ha enviado un anuncio ("Enviado X veces") o la hora exacta de la última emisión ("Último envío").
