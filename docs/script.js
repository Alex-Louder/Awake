/**
 * Awake! Landing Page Client Engine
 * Strict Anti-AI-Slop & elayadesign/ai-design-skills Compliance
 *
 * Architecture:
 * - Dynamic B11 Scroll Tagline Illuminator with Language Rebuild
 * - Zero-reload Bilingual Translation Engine (English & Spanish)
 * - Real Asset Swapping (popover_en.png <-> popover_es.png, tipjar_en.png <-> tipjar_es.png)
 * - Safe Non-destructive DOM Translation (preserves SVG icons in buttons)
 * - Interactive macOS Menu Bar & Hardware Telemetry Simulator
 * - Light/Dark Theme Controller with LocalStorage Persistence
 * - Apple Fluid Island Nav Scroll & Mobile Staggered Morph
 * - Accessible Privacy Modal & FAQ Accordion
 * - One-click Terminal Snippet Copying
 */

(function () {
  'use strict';

  // --- Complete Bilingual Dictionaries ---
  const i18n = {
    en: {
      page_title: "Awake! — Native macOS Clamshell Sleep Prevention & Smart Mute",
      page_desc: "Keep your MacBook fully awake with the lid closed without external monitors or dummy plugs. Preserves USB bus power, prevents remote desktop black screens, and automatically mutes audio on lid close.",

      nav_overview: "Overview",
      nav_features: "Features",
      nav_how_it_works: "How It Works",
      nav_compare: "Comparison",
      nav_security: "Security",
      nav_faq: "FAQ",
      nav_download_btn: "Download DMG",

      hero_badge: "macOS 14+ Sonoma • 15 Sequoia • Apple Silicon & Intel",
      hero_title_html: "Close the lid.<br>Your Mac stays awake.",
      hero_desc: "The lightweight native menu bar utility that prevents clamshell sleep without external displays, maintains continuous USB bus power, eliminates remote desktop black screens, and mutes audio the moment you close the screen.",
      hero_cta_download: "Download Awake! v1.0.0",
      hero_cta_secondary: "View on GitHub",

      sim_awake_label: "Awake! Mode",
      sim_awake_sub: "Keep running with lid closed",
      sim_shh_label: "Shh! Smart Mute",
      sim_shh_sub: "Pause media & mute on lid close",
      sim_status_awake_on: "100% Active • Screen Off • GPU Online",
      sim_status_awake_off: "Standard Sleep • Clamshell will suspend Mac",
      sim_status_usb_on: "Protected • Constant 5V/3A Bus Power",
      sim_status_usb_off: "At Risk • USB hubs eject on lid close",
      sim_status_remote_on: "Online • Sills / VNC / RustDesk Active",
      sim_status_remote_off: "Black Screen • WindowServer kills display",
      sim_status_audio_on: "Armed • Media paused & CoreAudio muted",
      sim_status_audio_off: "Standard • Audio keeps playing out loud",

      tagline_badge: "The Clamshell Problem Solved",
      tagline_text: "Engineered for creators, developers, and remote workers who refuse to let a closed lid interrupt a single render, server, or download.",

      prob_badge: "Why Traditional Tools Fail",
      prob_title: "What happens when you close your MacBook.",
      prob_desc: "Without an external monitor plugged in, macOS aggressively suspends hardware. Standard caffeinate commands keep CPU active but fail to prevent clamshell sleep.",
      prob_mac_title: "Default macOS Clamshell Sleep",
      prob_mac_1_b: "Terminates active background jobs:",
      prob_mac_1_t: " Video renders, ML training, downloads, and Docker containers halt instantly.",
      prob_mac_2_b: "Cuts USB bus power:",
      prob_mac_2_t: " External NVMe drives forcibly unmount, audio interfaces power off.",
      prob_mac_3_b: "Black screen in Remote Desktop:",
      prob_mac_3_t: " WindowServer shuts off display framebuffer; Sills, RustDesk, and VNC turn black.",
      prob_mac_4_b: "Embarrassing audio blunders:",
      prob_mac_4_t: " Music or videos continue blaring loudly if you close the lid hurriedly in quiet spaces.",

      sol_title: "The Awake! Native Solution",
      sol_1_b: "Zero Clamshell Sleep:",
      sol_1_t: " Your MacBook stays fully awake with lid shut, running headless without external dongles.",
      sol_2_b: "Uninterrupted USB Bus Power:",
      sol_2_t: " External SSDs, audio cards (Focusrite, Apollo), and hubs stay continuously powered.",
      sol_3_b: "Flawless Remote Desktop:",
      sol_3_t: " Internal screen brightness drops to 0 while GPU framebuffer stays active at 60 FPS.",
      sol_4_b: "Shh! Intelligent Mute:",
      sol_4_t: " Automatically pauses NowPlaying media and mutes system audio on close; restores on reopen.",

      cap_badge: "Native Architecture",
      cap_title: "Built with precision. Zero compromises.",
      cap_desc: "Written in pure Swift with zero external telemetry, no electron wrapper, and no background daemons running when idle.",
      bento_shh_title: "Shh! Smart Media & Volume Guardian",
      bento_shh_desc: "Detects lid angle through native IOKit hardware notifications. Instantly triggers MediaRemote pause and silences CoreAudio (internal speakers, AirPods, USB DACs). Your original volume level is seamlessly restored when you open your screen.",
      bento_remote_title: "Zero Black Screen on Remote Access",
      bento_remote_desc: "Unlike dummy HDMI plugs or hacky kexts, Awake! dims your backlight to 0 while maintaining the WindowServer framebuffer. Connect from anywhere via Sills, VNC, RustDesk, or AnyDesk without display failure.",
      bento_sudo_title: "Zero Password Prompts in Daily Use",
      bento_sudo_desc: "One single strictly scoped sudoers rule for pmset. The app itself never runs as root and never pesters you with admin prompts.",
      bento_footprint_title: "~15 MB Memory • 0% Idle CPU",
      bento_footprint_desc: "Native macOS menu bar footprint with zero background daemons. Leaves 99.9% of system memory free for your actual work.",

      steps_badge: "Engineering",
      steps_title: "How Awake! operates under the hood.",
      steps_desc: "Transparent, auditable Swift code leveraging native macOS kernel APIs without obsolete kernel extensions.",
      step_1_title: "1. IOKit Magnetic Sensor",
      step_1_desc: "Subscribes to AppleACPIPlatformExpert and IOPMrootDomain clamshell notifications. Wakes event loops only when the lid physically moves.",
      step_2_title: "2. Scoped pmset Assertion",
      step_2_desc: "Executes pmset -a disablesleep 1 with a dedicated sudoers entry. Tells macOS power management to bypass clamshell suspension safely.",
      step_3_title: "3. CoreAudio & Media Hooks",
      step_3_desc: "Hooks into MRMediaRemoteSendCommand to pause active audio/video players, mutes audio outputs, and saves volume state to restore on lid open.",

      comp_badge: "Comparison",
      comp_title: "Engineered for modern workflows.",
      comp_desc: "See how Awake! compares to traditional caffeinate scripts and legacy menu bar utilities.",
      comp_th_feature: "Feature",
      comp_th_awake: "Awake!",
      comp_th_amp: "Amphetamine",
      comp_th_caff: "macOS caffeinate",
      comp_r1: "Clamshell sleep prevention without external display",
      comp_r2: "Maintains USB bus power on lid close",
      comp_r3: "Remote Desktop (Sills, VNC) without black screen",
      comp_r4: "Smart Mute & Media Pause on close (Shh!)",
      comp_r5: "Password prompts during daily operation",
      comp_r6: "Memory footprint",
      comp_r7: "100% Open source & zero telemetry",

      sec_badge: "Security & Trust",
      sec_title: "Private by design. Open by principle.",
      sec_desc: "Awake! was created with a least privilege security model. No telemetry, no background analytics, and complete user ownership.",
      sec_f1: "Zero outbound network requests (no telemetry, no trackers).",
      sec_f2: "Runs in ordinary user space; only pmset is authorized via sudoers.",
      sec_f3: "100% clean uninstallation in a single Terminal command.",
      sec_code_title: "Strictly scoped /etc/sudoers.d/awake rule",

      creator_badge: "Open Source Creator",
      creator_name: "Alex Louder (@Alex-Louder)",
      creator_bio: "Independent software craftsman passionate about clean macOS native tools, performance, and respectful privacy. If Awake! saves your downloads or remote workflows, support further development with a coffee!",
      tier_1: "$1 Supporter",
      tier_3: "$3 Sponsor",
      tier_5: "$5 Power Sponsor",
      tier_kofi: "Support on Ko-fi",

      faq_badge: "Answers",
      faq_title: "Frequently Asked Questions",
      faq_desc: "Clear answers to hardware safety, thermal behavior, and security questions.",
      faq_q1: "Will my MacBook overheat with the lid closed in a bag?",
      faq_a1: "Modern Apple Silicon MacBooks (M1 through M4) are remarkably efficient and generate minimal heat at low to moderate loads. However, if you run heavy CPU/GPU tasks (like 4K video rendering or local LLM training) inside an airtight, insulated bag, heat cannot dissipate efficiently. We recommend toggling Awake! off before packing your laptop for travel during heavy renders.",
      faq_q2: "Why doesn't Awake! ask for my password every time?",
      faq_a2: "During first run onboarding, Awake! configures a single rule in /etc/sudoers.d/awake granting your user permission to run /usr/bin/pmset -a disablesleep * without password prompts. The app itself never runs as root. You can review or delete this file at any time.",
      faq_q3: "Does Shh! work with AirPods and external USB audio interfaces?",
      faq_a3: "Yes. Shh! monitors system default output devices via macOS CoreAudio and pauses playback across all media players using MediaRemote. Whether you use internal speakers, AirPods Max, or a professional USB DAC, audio is silenced immediately upon lid close.",
      faq_q4: "Does Awake! consume significant battery power?",
      faq_a4: "Awake! itself consumes approximately 15 MB of RAM and 0.0% idle CPU because it relies on kernel event notifications rather than polling loops. Battery consumption is entirely determined by the background tasks you choose to run (e.g. servers or downloads).",
      faq_q5: "Which macOS versions are supported?",
      faq_a5: "Awake! is officially tested and supported on macOS 14 Sonoma, macOS 15 Sequoia, and upcoming releases, across all Apple Silicon (M1, M2, M3, M4) and Intel architectures.",
      faq_q6: "How do I completely uninstall Awake!?",
      faq_a6: "Run two simple commands in Terminal: sudo rm -f /etc/sudoers.d/awake and rm -rf /Applications/Awake\\!.app. Zero hidden files, zero orphaned system launch daemons.",

      final_title: "Keep your Mac awake on your terms.",
      final_desc: "Download the universal macOS DMG or compile from source. 100% free and open source.",
      final_btn_download: "Download Awake! v1.0.0 (DMG)",
      final_btn_github: "View on GitHub",

      footer_copy: "Awake! by Alex Louder. Released under the MIT License.",
      footer_privacy: "Zero Telemetry Guarantee",
      footer_repo: "GitHub Repository",
      footer_kofi: "Ko-fi Tip Jar",

      modal_privacy_title: "Privacy & Security Guarantee",
      modal_p1: "100% Offline & Private: Awake! makes zero outbound network connections. It does not contain telemetry, crash reporters, analytics SDKs, or background trackers. Your workflow, computer name, and system activity never leave your Mac.",
      modal_p2: "Least Privilege Execution: Awake! runs entirely in unprivileged user space. It only calls macOS power management commands through a single, strictly scoped sudoers rule for pmset -a disablesleep. The app itself never runs as root.",
      modal_p3: "Auditable Source Code: Every line of Swift code is published under the open source MIT license at github.com/Alex-Louder/Awake. You can inspect, compile, or audit the software independently.",
      modal_p4: "Clean Uninstallation: Deleting Awake! leaves zero orphaned daemons or system hooks. Simply remove /Applications/Awake!.app and /etc/sudoers.d/awake.",

      toast_copied: "Copied to clipboard"
    },
    es: {
      page_title: "Awake! — Prevención Nativa de Suspensión con Tapa Cerrada en macOS",
      page_desc: "Mantén tu MacBook despierta con la tapa cerrada sin monitores externos ni adaptadores dummy. Mantiene energía en puertos USB, previene pantallas negras en escritorio remoto y silencia el audio automáticamente.",

      nav_overview: "Inicio",
      nav_features: "Funciones",
      nav_how_it_works: "Cómo Funciona",
      nav_compare: "Comparativa",
      nav_security: "Seguridad",
      nav_faq: "FAQ",
      nav_download_btn: "Descargar DMG",

      hero_badge: "macOS 14+ Sonoma • 15 Sequoia • Apple Silicon e Intel",
      hero_title_html: "Cierra la pantalla.<br>Tu Mac sigue despierta.",
      hero_desc: "La utilidad ligera y nativa para la barra de menús que evita la suspensión clamshell sin monitores externos, mantiene energía continua en puertos USB, elimina pantallas negras en escritorio remoto y silencia el sonido al instante.",
      hero_cta_download: "Descargar Awake! v1.0.0",
      hero_cta_secondary: "Ver en GitHub",

      sim_awake_label: "Modo Awake!",
      sim_awake_sub: "Continúa trabajando con la pantalla cerrada",
      sim_shh_label: "Silenciador Shh!",
      sim_shh_sub: "Pausa medios y silencia al cerrar la tapa",
      sim_status_awake_on: "100% Activo • Pantalla Apagada • GPU Online",
      sim_status_awake_off: "Suspensión Estándar • Clamshell suspenderá la Mac",
      sim_status_usb_on: "Protegido • Energía Continua 5V/3A en USB",
      sim_status_usb_off: "En Riesgo • Hubs USB se expulsan al cerrar tapa",
      sim_status_remote_on: "Online • Sills / VNC / RustDesk Activos",
      sim_status_remote_off: "Pantalla Negra • WindowServer apaga framebuffer",
      sim_status_audio_on: "Armado • Medios en pausa y CoreAudio silenciado",
      sim_status_audio_off: "Estándar • El audio continuará sonando",

      tagline_badge: "El Problema de Clamshell Resuelto",
      tagline_text: "Diseñada para creadores, desarrolladores y profesionales remotos que se niegan a que una pantalla cerrada interrumpa un render, servidor o descarga.",

      prob_badge: "Por Qué Fallan las Soluciones Clásicas",
      prob_title: "Qué ocurre cuando cierras tu MacBook.",
      prob_desc: "Sin una pantalla externa conectada, macOS suspende agresivamente los componentes. El comando caffeinate tradicional mantiene la CPU activa pero no evita la suspensión clamshell.",
      prob_mac_title: "Suspensión Clamshell por Defecto en macOS",
      prob_mac_1_b: "Interrumpe tareas activas en segundo plano:",
      prob_mac_1_t: " Los renders de video, entrenamientos de IA, descargas y contenedores Docker se detienen.",
      prob_mac_2_b: "Corta la energía de los puertos USB:",
      prob_mac_2_t: " Las unidades SSD externas se expulsan forzadamente y las interfaces de audio se apagan.",
      prob_mac_3_b: "Pantalla negra en Escritorio Remoto:",
      prob_mac_3_t: " WindowServer desconecta el framebuffer; Sills, RustDesk y VNC quedan a oscuras.",
      prob_mac_4_b: "Accidentes de audio inesperados:",
      prob_mac_4_t: " La música o videos continúan sonando a alto volumen si cierras la tapa apresuradamente en público.",

      sol_title: "La Solución Nativa de Awake!",
      sol_1_b: "Cero Suspensión Clamshell:",
      sol_1_t: " Tu MacBook permanece 100% activa con la tapa cerrada, funcionando como servidor sin dongles.",
      sol_2_b: "Energía Continua en Puertos USB:",
      sol_2_t: " Los discos NVMe externos, tarjetas de sonido (Focusrite, Apollo) y hubs se mantienen encendidos.",
      sol_3_b: "Acceso Remoto Impecable:",
      sol_3_t: " El brillo del panel interno baja a cero mientras la GPU sostiene el framebuffer activo a 60 FPS.",
      sol_4_b: "Silenciador Inteligente Shh!:",
      sol_4_t: " Pausa automáticamente reproductores NowPlaying y silencia el audio del sistema; lo restaura al reabrir.",

      cap_badge: "Arquitectura Nativa",
      cap_title: "Ingeniería de precisión. Cero compromisos.",
      cap_desc: "Escrita en Swift puro sin telemetría, sin capas Electron y sin procesos en segundo plano cuando está inactiva.",
      bento_shh_title: "Shh! Guardián Inteligente de Audio y Medios",
      bento_shh_desc: "Detecta el ángulo de la tapa con notificaciones nativas de IOKit. Dispara una pausa instantánea vía MediaRemote y silencia CoreAudio (altavoces, AirPods, DACs USB). Restaura tu volumen original al abrir la pantalla.",
      bento_remote_title: "Cero Pantallas Negras en Escritorio Remoto",
      bento_remote_desc: "A diferencia de conectores HDMI dummy o kexts invasivos, Awake! apaga la retroiluminación manteniendo intacto el framebuffer de WindowServer. Conéctate vía Sills, VNC o RustDesk con total fluidez.",
      bento_sudo_title: "Cero Contraseñas en el Uso Diario",
      bento_sudo_desc: "Una única regla estrictamente delimitada en sudoers para pmset. La app jamás corre como root ni te solicita permisos continuamente.",
      bento_footprint_title: "~15 MB de Memoria • 0% CPU en Reposo",
      bento_footprint_desc: "Huella ultraligera nativa de la barra de menús sin daemons permanentes. Deja el 99.9% de los recursos para tu verdadero trabajo.",

      steps_badge: "Ingeniería",
      steps_title: "Cómo opera Awake! bajo el chasis.",
      steps_desc: "Código en Swift auditable que aprovecha las APIs del kernel de macOS sin extensiones obsoletas.",
      step_1_title: "1. Sensor Magnético de IOKit",
      step_1_desc: "Se suscribe a eventos de AppleACPIPlatformExpert e IOPMrootDomain. Solo despierta ciclos de ejecución cuando la pantalla se mueve.",
      step_2_title: "2. Aserción Delimitada de pmset",
      step_2_desc: "Ejecuta pmset -a disablesleep 1 mediante una regla dedicada en sudoers. Le indica al gestor de energía que evite la suspensión clamshell.",
      step_3_title: "3. Ganchos en CoreAudio y MediaRemote",
      step_3_desc: "Llama a MRMediaRemoteSendCommand para pausar reproductores, silencia las salidas CoreAudio y memoriza el volumen para restaurarlo.",

      comp_badge: "Comparativa",
      comp_title: "Diseñada para flujos de trabajo modernos.",
      comp_desc: "Observa cómo Awake! supera los scripts clásicos de caffeinate y utilidades heredadas.",
      comp_th_feature: "Característica",
      comp_th_awake: "Awake!",
      comp_th_amp: "Amphetamine",
      comp_th_caff: "macOS caffeinate",
      comp_r1: "Evita suspensión con tapa cerrada sin monitor externo",
      comp_r2: "Mantiene energía en puertos USB al cerrar",
      comp_r3: "Escritorio Remoto (Sills, VNC) sin pantalla negra",
      comp_r4: "Silenciador y pausa automática de medios (Shh!)",
      comp_r5: "Solicitudes de contraseña en el uso diario",
      comp_r6: "Consumo de memoria RAM",
      comp_r7: "100% Código abierto y cero telemetría",

      sec_badge: "Seguridad y Confianza",
      sec_title: "Privado por diseño. Abierto por convicción.",
      sec_desc: "Awake! fue concebida bajo el principio de mínimo privilegio. Sin telemetría, sin analíticas y con control total para el usuario.",
      sec_f1: "Cero peticiones hacia servidores externos (sin analíticas ni rastreadores).",
      sec_f2: "Corre en tu espacio de usuario común; solo pmset tiene permiso en sudoers.",
      sec_f3: "Desinstalación 100% limpia con un único comando de Terminal.",
      sec_code_title: "Regla restringida en /etc/sudoers.d/awake",

      creator_badge: "Desarrollador Open Source",
      creator_name: "Alex Louder (@Alex-Louder)",
      creator_bio: "Desarrollador independiente apasionado por las herramientas nativas para macOS, el rendimiento limpio y la privacidad del usuario. Si Awake! te ahorró dolores de cabeza con descargas o servidores, ¡invítame un café!",
      tier_1: "$1 USD (Apoyar)",
      tier_3: "$3 USD (Sponsor)",
      tier_5: "$5 USD (Sponsor Pro)",
      tier_kofi: "Apoyar en Ko-fi",

      faq_badge: "Respuestas",
      faq_title: "Preguntas Frecuentes",
      faq_desc: "Respuestas claras sobre seguridad del hardware, temperatura y permisos.",
      faq_q1: "¿Mi MacBook se sobrecalentará con la tapa cerrada en una mochila?",
      faq_a1: "Las MacBooks modernas con procesadores Apple Silicon (M1 a M4) son extraordinariamente eficientes y generan poco calor en tareas moderadas. Sin embargo, si ejecutas renders en 4K o entrenas modelos de IA dentro de una mochila hermética, el calor no puede escapar. Te recomendamos desactivar Awake! antes de guardar la laptop si vas a realizar tareas de alto rendimiento.",
      faq_q2: "¿Por qué Awake! no me pide contraseña cada vez que la uso?",
      faq_a2: "Durante la configuración inicial de un clic, Awake! genera una regla en /etc/sudoers.d/awake que autoriza únicamente la ejecución de /usr/bin/pmset -a disablesleep * sin pedir clave. La app jamás corre como root. Puedes revisar o borrar esa regla en cualquier momento.",
      faq_q3: "¿Shh! funciona con AirPods y tarjetas de sonido USB?",
      faq_a3: "Sí. Shh! monitorea el dispositivo de salida predeterminado mediante CoreAudio de macOS y pausa la reproducción en reproductores compatibles con MediaRemote. Ya uses altavoces internos, AirPods o un DAC USB externo, el audio se silencia de inmediato al cerrar la pantalla.",
      faq_q4: "¿Awake! consume mucha batería?",
      faq_a4: "Awake! consume aproximadamente 15 MB de memoria RAM y 0.0% de CPU en reposo gracias a que responde a eventos del kernel en lugar de hacer comprobaciones continuas. El gasto de batería dependerá de las aplicaciones que dejes corriendo en segundo plano (renders, descargas, etc.).",
      faq_q5: "¿Qué versiones de macOS son compatibles?",
      faq_a5: "Awake! está probada y optimizada para macOS 14 Sonoma, macOS 15 Sequoia y versiones venideras, tanto en Apple Silicon (M1, M2, M3, M4) como en procesadores Intel.",
      faq_q6: "¿Cómo desinstalo Awake! por completo?",
      faq_a6: "Ejecuta dos comandos simples en tu Terminal: sudo rm -f /etc/sudoers.d/awake y rm -rf /Applications/Awake\\!.app. Sin archivos residuales ni daemons ocultos en el sistema.",

      final_title: "Mantén tu Mac despierta bajo tus reglas.",
      final_desc: "Descarga el instalador DMG universal o compila desde el código fuente. 100% gratuito y de código abierto.",
      final_btn_download: "Descargar Awake! v1.0.0 (DMG)",
      final_btn_github: "Ver en GitHub",

      footer_copy: "Awake! por Alex Louder. Publicado bajo la Licencia MIT.",
      footer_privacy: "Garantía de Cero Telemetría",
      footer_repo: "Repositorio en GitHub",
      footer_kofi: "Apoyar en Ko-fi",

      modal_privacy_title: "Garantía de Privacidad y Seguridad",
      modal_p1: "100% Fuera de Línea y Privada: Awake! no realiza conexiones hacia el exterior. No contiene telemetría, monitores de fallos, paquetes de analíticas ni rastreadores. Tus datos y actividad jamás abandonan tu equipo.",
      modal_p2: "Ejecución con Mínimo Privilegio: Awake! corre enteramente en el espacio de usuario común. Solo envía directivas de energía mediante una única regla de sudoers para pmset -a disablesleep. La aplicación jamás se ejecuta como administrador.",
      modal_p3: "Código Fuente Auditable: Cada línea en Swift está abierta bajo la licencia MIT en github.com/Alex-Louder/Awake. Puedes revisarla, compilarla o auditarla con total libertad.",
      modal_p4: "Desinstalación Impecable: Eliminar Awake! no deja archivos residuales. Simplemente borra /Applications/Awake!.app y /etc/sudoers.d/awake.",

      toast_copied: "Copiado al portapapeles"
    }
  };

  let currentLang = 'en';

  // --- Dynamic B11 Tagline Reveal Builder ---
  let taglineWordSpans = [];

  function buildTaglineSpans(lang) {
    const taglineEl = document.getElementById('taglineRevealText');
    if (!taglineEl) return;

    const rawText = i18n[lang].tagline_text;
    const words = rawText.split(/\s+/);
    taglineEl.innerHTML = words.map(w => `<span class="reveal-word">${w}</span>`).join(' ');
    taglineWordSpans = Array.from(taglineEl.querySelectorAll('.reveal-word'));
    onTaglineScroll();
  }

  function onTaglineScroll() {
    const taglineEl = document.getElementById('taglineRevealText');
    if (!taglineEl || taglineWordSpans.length === 0) return;

    const rect = taglineEl.getBoundingClientRect();
    const viewportHeight = window.innerHeight;

    // Trigger window: begins at 85% of screen height, completes at 35%
    const startTrigger = viewportHeight * 0.85;
    const endTrigger = viewportHeight * 0.35;

    const progress = Math.min(Math.max((startTrigger - rect.top) / (startTrigger - endTrigger), 0), 1);
    const activeCount = Math.floor(progress * taglineWordSpans.length);

    taglineWordSpans.forEach((span, index) => {
      if (index <= activeCount) {
        span.classList.add('active');
      } else {
        span.classList.remove('active');
      }
    });
  }

  // --- Bilingual Localization Engine ---
  function setLanguage(lang) {
    if (!i18n[lang]) return;
    currentLang = lang;
    document.documentElement.lang = lang;
    localStorage.setItem('clamawake_lang', lang);

    const dict = i18n[lang];

    // Document Meta
    document.title = dict.page_title;
    const metaDesc = document.querySelector('meta[name="description"]');
    if (metaDesc) metaDesc.setAttribute('content', dict.page_desc);

    // Hero title with meaningful line breaks (elayadesign B5)
    const heroTitle = document.getElementById('heroTitle');
    if (heroTitle) {
      heroTitle.innerHTML = dict.hero_title_html;
    }

    // Update all elements with data-i18n safely
    const elements = document.querySelectorAll('[data-i18n]');
    elements.forEach(el => {
      const key = el.getAttribute('data-i18n');
      if (dict[key]) {
        // If element contains an inner .btn-text span, update that to preserve SVGs
        const textSpan = el.querySelector('.btn-text');
        if (textSpan) {
          textSpan.textContent = dict[key];
        } else if (el.tagName === 'INPUT' && el.type === 'button') {
          el.value = dict[key];
        } else {
          el.textContent = dict[key];
        }
      }
    });

    // Update Language Toggle Button Label
    const langLabel = document.getElementById('langLabelText');
    const langBtn = document.getElementById('langToggleBtn');
    if (langLabel) {
      langLabel.innerHTML = lang === 'en' ? '<strong>EN</strong> / ES' : 'EN / <strong>ES</strong>';
    }
    if (langBtn) {
      langBtn.setAttribute('aria-label', lang === 'en' ? 'Switch to Spanish' : 'Cambiar a Inglés');
    }

    // Switch Real Asset Screenshots Dynamically
    const heroPopoverImg = document.getElementById('heroPopoverImg');
    if (heroPopoverImg) {
      heroPopoverImg.src = lang === 'es' ? 'screenshots/popover_es.png' : 'screenshots/popover_en.png';
      heroPopoverImg.alt = lang === 'es' ? 'Captura de Awake! Popover en macOS' : 'Awake! Menu Bar Popover Screenshot';
    }

    const tipjarScreenshotImg = document.getElementById('tipjarScreenshotImg');
    if (tipjarScreenshotImg) {
      tipjarScreenshotImg.src = lang === 'es' ? 'screenshots/tipjar_es.png' : 'screenshots/tipjar_en.png';
      tipjarScreenshotImg.alt = lang === 'es' ? 'Ventana de Propinas de Awake! en macOS' : 'Awake! Tip Jar Interface Screenshot';
    }

    // Rebuild Tagline Spans in new language
    buildTaglineSpans(lang);

    // Update Hardware Simulator Telemetry texts
    updateSimulatorTelemetry();
  }

  // --- Theme Controller (Dark / Light) ---
  function initTheme() {
    const savedTheme = localStorage.getItem('clamawake_theme') || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);
    updateThemeIcon(savedTheme);

    const themeBtn = document.getElementById('themeToggleBtn');
    if (themeBtn) {
      themeBtn.addEventListener('click', () => {
        const currentTheme = document.documentElement.getAttribute('data-theme');
        const nextTheme = currentTheme === 'light' ? 'dark' : 'light';
        document.documentElement.setAttribute('data-theme', nextTheme);
        localStorage.setItem('clamawake_theme', nextTheme);
        updateThemeIcon(nextTheme);
      });
    }
  }

  function updateThemeIcon(theme) {
    const themeBtn = document.getElementById('themeToggleBtn');
    if (!themeBtn) return;
    if (theme === 'light') {
      themeBtn.innerHTML = '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg>';
      themeBtn.setAttribute('aria-label', 'Switch to Dark Mode');
    } else {
      themeBtn.innerHTML = '<svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg>';
      themeBtn.setAttribute('aria-label', 'Switch to Light Mode');
    }
  }

  // --- Hardware Telemetry Simulator ---
  const simAwakeSwitch = document.getElementById('simAwakeToggle');
  const simShhSwitch = document.getElementById('simShhToggle');
  const simMenuBarIcon = document.getElementById('simMenuBarIcon');
  const simWaveform = document.getElementById('simWaveform');

  function updateSimulatorTelemetry() {
    const isAwake = simAwakeSwitch ? simAwakeSwitch.checked : true;
    const isShh = simShhSwitch ? simShhSwitch.checked : true;

    // Menu bar active indicator
    if (simMenuBarIcon) {
      if (isAwake) {
        simMenuBarIcon.classList.add('active');
      } else {
        simMenuBarIcon.classList.remove('active');
      }
    }

    const dict = i18n[currentLang];
    const clamshellStatus = document.getElementById('simClamshellStatus');
    const usbStatus = document.getElementById('simUsbStatus');
    const remoteStatus = document.getElementById('simRemoteStatus');
    const audioStatus = document.getElementById('simAudioStatus');

    if (clamshellStatus) {
      clamshellStatus.textContent = isAwake ? dict.sim_status_awake_on : dict.sim_status_awake_off;
      clamshellStatus.className = isAwake ? 'telemetry-value' : 'telemetry-value alert';
    }

    if (usbStatus) {
      usbStatus.textContent = isAwake ? dict.sim_status_usb_on : dict.sim_status_usb_off;
      usbStatus.className = isAwake ? 'telemetry-value' : 'telemetry-value alert';
    }

    if (remoteStatus) {
      remoteStatus.textContent = isAwake ? dict.sim_status_remote_on : dict.sim_status_remote_off;
      remoteStatus.className = isAwake ? 'telemetry-value' : 'telemetry-value alert';
    }

    if (audioStatus) {
      audioStatus.textContent = isShh ? dict.sim_status_audio_on : dict.sim_status_audio_off;
      audioStatus.className = isShh ? 'telemetry-value warning' : 'telemetry-value';
    }

    // Audio waveform animation toggle
    if (simWaveform) {
      if (isShh) {
        simWaveform.classList.add('muted');
      } else {
        simWaveform.classList.remove('muted');
      }
    }
  }

  // --- Scroll Reveals via IntersectionObserver (B7) ---
  function initScrollReveals() {
    const revealElements = document.querySelectorAll('.reveal-on-scroll');
    if (!('IntersectionObserver' in window)) {
      revealElements.forEach(el => el.classList.add('in-view'));
      return;
    }

    const observer = new IntersectionObserver((entries, obs) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('in-view');
          obs.unobserve(entry.target);
        }
      });
    }, {
      rootMargin: '0px 0px -40px 0px',
      threshold: 0.1
    });

    revealElements.forEach(el => observer.observe(el));
  }

  // --- Sticky Floating Island Scroll State ---
  function initNavScroll() {
    const navWrapper = document.getElementById('navIslandWrapper');
    if (!navWrapper) return;

    window.addEventListener('scroll', () => {
      if (window.scrollY > 30) {
        navWrapper.classList.add('scrolled');
      } else {
        navWrapper.classList.remove('scrolled');
      }
    }, { passive: true });
  }

  // --- Mobile Menu Toggle with Hamburger Morph ---
  function initMobileMenu() {
    const toggleBtn = document.getElementById('mobileNavToggle');
    const overlay = document.getElementById('mobileNavOverlay');
    if (!toggleBtn || !overlay) return;

    toggleBtn.addEventListener('click', () => {
      const isOpen = toggleBtn.getAttribute('aria-expanded') === 'true';
      toggleBtn.setAttribute('aria-expanded', !isOpen);
      overlay.classList.toggle('open', !isOpen);
      overlay.setAttribute('aria-hidden', isOpen ? 'true' : 'false');
    });

    overlay.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        toggleBtn.setAttribute('aria-expanded', 'false');
        overlay.classList.remove('open');
        overlay.setAttribute('aria-hidden', 'true');
      });
    });
  }

  // --- Accessible FAQ Accordion ---
  function initFaq() {
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
      const btn = item.querySelector('.faq-question-btn');
      if (!btn) return;

      btn.addEventListener('click', () => {
        const isActive = item.classList.contains('active');
        // Accordion behavior: close others
        faqItems.forEach(other => {
          other.classList.remove('active');
          const otherBtn = other.querySelector('.faq-question-btn');
          if (otherBtn) otherBtn.setAttribute('aria-expanded', 'false');
        });

        if (!isActive) {
          item.classList.add('active');
          btn.setAttribute('aria-expanded', 'true');
        }
      });
    });
  }

  // --- One-Click Clipboard Copy ---
  function initCopyButtons() {
    const toast = document.getElementById('toastNotice');
    const copyButtons = document.querySelectorAll('[data-copy-target]');

    copyButtons.forEach(btn => {
      btn.addEventListener('click', () => {
        const targetId = btn.getAttribute('data-copy-target');
        const targetEl = document.getElementById(targetId);
        const textToCopy = targetEl ? targetEl.textContent.trim() : '';

        if (!textToCopy) return;

        navigator.clipboard.writeText(textToCopy).then(() => {
          showToast(i18n[currentLang].toast_copied);
        }).catch(() => {
          // ExecCommand fallback
          const tempInput = document.createElement('textarea');
          tempInput.value = textToCopy;
          document.body.appendChild(tempInput);
          tempInput.select();
          document.execCommand('copy');
          document.body.removeChild(tempInput);
          showToast(i18n[currentLang].toast_copied);
        });
      });
    });

    function showToast(msg) {
      if (!toast) return;
      toast.querySelector('.toast-msg').textContent = msg;
      toast.classList.add('visible');
      setTimeout(() => {
        toast.classList.remove('visible');
      }, 2200);
    }
  }

  // --- Privacy & Security Modal Controller (B10 Ship Requirement) ---
  function initPrivacyModal() {
    const modal = document.getElementById('privacyModal');
    const openBtn = document.getElementById('privacyModalOpenBtn');
    const closeBtn = document.getElementById('privacyModalCloseBtn');

    if (!modal) return;

    function openModal() {
      modal.classList.add('open');
      document.body.style.overflow = 'hidden';
      if (closeBtn) closeBtn.focus();
    }

    function closeModal() {
      modal.classList.remove('open');
      document.body.style.overflow = '';
      if (openBtn) openBtn.focus();
    }

    if (openBtn) openBtn.addEventListener('click', openModal);
    if (closeBtn) closeBtn.addEventListener('click', closeModal);

    modal.addEventListener('click', (e) => {
      if (e.target === modal) closeModal();
    });

    window.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && modal.classList.contains('open')) {
        closeModal();
      }
    });
  }

  // --- DOM Ready Initialization ---
  document.addEventListener('DOMContentLoaded', () => {
    initTheme();

    const savedLang = localStorage.getItem('clamawake_lang') || (navigator.language && navigator.language.startsWith('es') ? 'es' : 'en');
    setLanguage(savedLang);

    const langToggleBtn = document.getElementById('langToggleBtn');
    if (langToggleBtn) {
      langToggleBtn.addEventListener('click', () => {
        setLanguage(currentLang === 'en' ? 'es' : 'en');
      });
    }

    if (simAwakeSwitch) {
      simAwakeSwitch.addEventListener('change', updateSimulatorTelemetry);
    }
    if (simShhSwitch) {
      simShhSwitch.addEventListener('change', updateSimulatorTelemetry);
    }

    // Scroll-driven tagline reveal throttled with requestAnimationFrame
    window.addEventListener('scroll', () => {
      window.requestAnimationFrame(onTaglineScroll);
    }, { passive: true });

    initScrollReveals();
    initNavScroll();
    initMobileMenu();
    initFaq();
    initCopyButtons();
    initPrivacyModal();
  });
})();
