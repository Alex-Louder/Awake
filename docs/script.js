/**
 * Awake! — Awwwards-Tier Interactive Client Engine
 * Written in Pure Vanilla JS with Zero Dependencies
 * Author: Alex Louder (@Alex-Louder)
 */

(function () {
  'use strict';

  // --- Complete Bilingual Dictionaries (English & Español) ---
  const i18n = {
    en: {
      page_title: "Awake! — Lid Down. Your Mac Keeps Working.",
      nav_overview: "Overview",
      nav_ecosystem: "Ecosystem",
      nav_comparison: "Comparison",
      nav_architecture: "Architecture",
      nav_creator: "Creator",
      nav_faq: "FAQ",
      nav_download: "Download DMG",

      hero_badge: "macOS 27 Golden Gate",
      hero_title: "Lid down.<br>Your Mac keeps working.",
      hero_desc: "Prevent macOS from putting your work to sleep when you close your laptop. Your background AI agents, downloads, and remote desktop sessions keep running at full speed, with automatic audio mute on lid shut.",
      hero_cta_dmg: "Download Awake! v1.0.1",
      hero_cta_github: "GitHub Repository",

      vd_title: "Virtual Display • Headless Stream",
      vd_badge: "60 FPS Active",
      vd_sill_status: "Active stream at 120 Hz",
      vd_ollama_status: "Inference at 48 tok/s",
      vd_footer_screen: "Physical screen: 0% brightness",
      vd_footer_shh: "Audio: Muted with Shh!",
      vd_footer_usb: "USB: 5V continuous",

      capsule_awake_label: "Awake!",
      capsule_awake_sub: "Keep your Mac awake",
      capsule_shh_label: "Shh!",
      capsule_shh_sub: "Mute on lid close",
      hud_audio_label: "NowPlaying: Active",
      hud_audio_muted: "NowPlaying: Muted & Paused",
      hud_lid_open: "Lid: Open (135°)",
      hud_lid_closed: "Lid: Closed (0°)",
      hud_usb_active: "USB: Active (5V)",
      hud_usb_unprotected: "USB: Sleep Risk",

      sim_slider_title: "Simulate Lid Angle:",
      hint_click_close: "👆 Click to close lid",
      hint_click_open: "👆 Click to open lid",
      clamshell_badge_open: "Lid open (135°) • Scroll down or click to close",
      clamshell_badge_closed: "Lid closed (0°) • Virtual Display active in background",
      demo_btn_close: "Close screen",
      demo_btn_open: "Open screen",
      demo_btn_running: "Simulating...",
      status_lid_open: "Screen open (135°)",
      status_lid_closed: "Screen closed (0°)",

      tagline_eyebrow: "Continuous Compute",
      tagline_text: "Close the lid. Your AI agents, local servers, and remote connections keep running.",

      eco_badge: "Ecosystem",
      eco_title: "Engineered for Background AI & Remote Workflows",
      eco_sub: "Awake! keeps your background tasks alive without external displays or complex terminal hacks.",
      eco_ai_title: "Background AI Agents & Compute",
      eco_ai_badge: "Never Interrupted",
      eco_ai_desc: "Autonomous coding agents, local model inference, and background tasks run without interruption at full Apple Silicon performance with the screen shut.",
      app_claude_role: "Autonomous Coding",
      app_agy_role: "Agentic Pair Programmer",
      app_codex_role: "Terminal & Build Pipelines",
      app_ollama_role: "Local LLMs (Llama, DeepSeek)",
      eco_remote_title: "Remote Access & Control",
      eco_remote_badge: "Zero Black Screens",
      eco_remote_desc: "Your physical screen turns off to conserve power, while the GPU framebuffer remains active at 60 FPS for instant remote access.",
      app_sills_role: "iOS to Mac Streaming",
      app_rustdesk_role: "Open Source Remote Access",
      app_anydesk_role: "Low Latency Control",
      app_tv_role: "Headless Desktop",

      duel_badge: "Architecture",
      duel_title: "Standard Sleep vs. The Awake! Protocol",
      duel_sub: "macOS suspends all user tasks when you lower the screen. Awake! gives you effortless control over when your Mac actually sleeps.",
      trap_title: "Default macOS Behavior",
      trap_badge: "Disruptive",
      trap_1_b: "Background tasks freeze:",
      trap_1_t: " Video renders, AI agents, Docker containers, and large downloads halt immediately.",
      trap_2_b: "USB bus power cuts:",
      trap_2_t: " External NVMe drives and audio interfaces abruptly disconnect, risking data corruption.",
      trap_3_b: "Remote Desktop black screens:",
      trap_3_t: " The WindowServer framebuffer shuts down. Remote sessions via Sill and AnyDesk go completely dark.",
      trap_4_b: "Audio blares in quiet spaces:",
      trap_4_t: " Media keeps playing out loud if you lower the lid quickly in quiet rooms or meetings.",

      awake_protocol_title: "The Awake! Protocol",
      awake_protocol_badge: "Seamless",
      awake_1_b: "Uninterrupted compute:",
      awake_1_t: " CPU and GPU continue operating at full capacity. AI agents and renders finish without stopping.",
      awake_2_b: "Guaranteed USB bus power:",
      awake_2_t: " External NVMe drives and USB audio interfaces stay reliably powered at 5V DC.",
      awake_3_b: "Fluid Remote Desktop:",
      awake_3_t: " Screen backlight drops to zero to save battery, while the GPU framebuffer streams at 60 FPS.",
      awake_4_b: "Shh! Auto-Mute Guardian:",
      awake_4_t: " Instantly pauses media playback and mutes audio output when the lid is closed. Restores volume on open.",

      bento_badge: "Capabilities",
      bento_title: "Built for power users. Refined for everyone.",
      bento_sub: "Engineered in pure native Swift. No Electron, no background bloat, and zero idle overhead.",
      bento_shh_title: "Shh! Smart Audio & Media Curtain",
      bento_shh_desc: "Hooks directly into macOS CoreAudio and MediaRemote. Whether you listen via internal speakers, AirPods, or an external USB audio interface, closing the lid mutes sound instantly and pauses playback. It seamlessly restores your previous volume when you open the lid.",
      bento_remote_title: "Continuous Remote Desktop",
      bento_remote_desc: "Connect from your iPad or secondary machine via Sill, RustDesk, or AnyDesk without black screens or disconnects. Display brightness dims to zero to save battery while 60 FPS streaming stays active.",
      bento_security_title: "One-Click Setup",
      bento_security_desc: "Only requires authorization once during initial setup. Toggle it anytime from the menu bar without repetitive password prompts.",
      bento_ram_title: "Native Swift & Lightweight",
      bento_ram_desc: "Zero Electron, zero background bloat. A lean menu bar utility that uses no CPU cycles while idling.",

      pipe_badge: "How It Operates",
      pipe_title: "The 3-Step Hardware Pipeline",
      pipe_sub: "Transparent, clean Swift execution directly interfacing with macOS system frameworks.",
      pipe_step1_title: "1. IOKit Magnetic Sensor",
      pipe_step1_desc: "Listens for physical clamshell state changes directly through AppleACPIPlatformExpert and IOPMrootDomain.",
      pipe_step2_title: "2. Scoped pmset Assertion",
      pipe_step2_desc: "Applies disablesleep 1 with zero password prompt, telling macOS power management to ignore the clamshell trigger.",
      pipe_step3_title: "3. Display & Audio Hooks",
      pipe_step3_desc: "Dims screen backlight to 0 while preserving WindowServer, pauses active media, and mutes audio output.",

      matrix_badge: "Benchmark",
      matrix_title: "Awake! vs. Traditional Utilities",
      matrix_sub: "Why standard caffeinate scripts and older utilities fall short on modern macOS.",
      th_feature: "Feature",
      th_awake: "Awake!",
      th_amp: "Amphetamine",
      th_caff: "caffeinate (CLI)",
      row_1: "Lid closed without external monitor",
      row_2: "Continuous USB bus power",
      row_3: "Remote Desktop (Sill, VNC) without black screen",
      row_4: "Smart Mute on lid close (Shh!)",
      row_5: "Admin Privileges",
      row_6: "Idle Performance",
      row_7: "License & Telemetry",

      creator_bio: "Awake! is an independent, 100% open-source tool built with great care. No ads, no telemetry, no tracking. If it saved your downloads or streamlined your remote workflow, consider buying me a coffee to support continuous development!",
      tip_1_title: "Thanks for your support",
      tip_3_title: "Thank you so much!",
      tip_5_title: "Thank you very much!",
      tip_kofi_btn: "Support on Ko-fi",
      jar_header: "Ko-fi Direct Support",
      jar_tier1: "Coffee",
      jar_tier2: "Sponsor",
      jar_tier3: "Super Supporter",
      jar_footer: "Secure payments powered by Stripe & PayPal on Ko-fi",

      faq_badge: "Clarifications",
      faq_title: "Frequently Asked Questions",
      faq_q1: "Will my MacBook overheat with the lid closed in a backpack?",
      faq_a1: "Apple Silicon MacBooks (M1–M4) run exceptionally cool at moderate loads. However, if you are doing intensive 4K exports or training local AI models inside an airtight, insulated backpack, thermal dissipation is limited. We recommend toggling Awake! off before stowing your laptop in a bag for travel during heavy renders.",
      faq_q2: "Why does Awake! never prompt for my password during daily use?",
      faq_a2: "During the initial 1-click onboarding setup, Awake! configures a single rule in /etc/sudoers.d/awake granting your specific user account permission to execute pmset -a disablesleep without password prompts. The application itself never runs as root and never makes network connections.",
      faq_q3: "Does Shh! work with AirPods and USB audio interfaces?",
      faq_a3: "Yes. Shh! communicates with macOS CoreAudio and MediaRemote. Whether you are using internal MacBook speakers, AirPods, headphones, or external studio audio interfaces (Focusrite Scarlett, Universal Audio Apollo, SSL), playback is immediately paused and audio is muted on lid closure.",
      faq_q4: "How do I completely uninstall Awake!?",
      faq_a4: "Awake! leaves zero hidden daemons or orphaned background services. Simply drag Awake!.app to your Trash, and remove the sudoers rule with: sudo rm -f /etc/sudoers.d/awake.",

      final_title: "Lid down. Your Mac keeps working.",
      final_desc: "Download the universal macOS DMG or compile directly from source. 100% free, private, and open source.",
      final_download_btn: "Download Awake! v1.0.1 (DMG)",
      final_github_btn: "View Source on GitHub"
    },

    es: {
      page_title: "Awake! — Bajas la tapa. Tu Mac sigue trabajando.",
      nav_overview: "Inicio",
      nav_ecosystem: "Ecosistema",
      nav_comparison: "Comparativa",
      nav_architecture: "Arquitectura",
      nav_creator: "Creador",
      nav_faq: "FAQ",
      nav_download: "Descargar DMG",

      hero_badge: "macOS 27 Golden Gate",
      hero_title: "Bajas la tapa.<br>Tu Mac sigue trabajando.",
      hero_desc: "Evita que macOS suspenda tus procesos al cerrar la pantalla. Tus agentes de IA, descargas y sesiones de escritorio remoto continúan ejecutándose a toda velocidad, con silencio automático al bajar la pantalla.",
      hero_cta_dmg: "Descargar Awake! v1.0.1",
      hero_cta_github: "Repositorio en GitHub",

      vd_title: "Pantalla Virtual • Stream Headless",
      vd_badge: "60 FPS Activo",
      vd_sill_status: "Streaming activo a 120 Hz",
      vd_ollama_status: "Inferencia a 48 tok/s",
      vd_footer_screen: "Pantalla física: 0% brillo",
      vd_footer_shh: "Audio: Silenciado con Shh!",
      vd_footer_usb: "USB: 5V continuo",

      capsule_awake_label: "Awake!",
      capsule_awake_sub: "Mantén despierta tu mac",
      capsule_shh_label: "Shh!",
      capsule_shh_sub: "Silenciar al cerrar",
      hud_audio_label: "NowPlaying: Activo",
      hud_audio_muted: "NowPlaying: Silenciado y en Pausa",
      hud_lid_open: "Tapa: Abierta (135°)",
      hud_lid_closed: "Tapa: Cerrada (0°)",
      hud_usb_active: "USB: Activo (5V)",
      hud_usb_unprotected: "USB: En Riesgo",

      sim_slider_title: "Simular Ángulo de la Tapa:",
      hint_click_close: "👆 Haz clic para cerrar la tapa",
      hint_click_open: "👆 Haz clic para abrir la tapa",
      clamshell_badge_open: "Tapa abierta (135°) • Haz scroll o clic para cerrar",
      clamshell_badge_closed: "Tapa cerrada (0°) • Pantalla Virtual activa en segundo plano",
      demo_btn_close: "Cerrar pantalla",
      demo_btn_open: "Abrir pantalla",
      demo_btn_running: "Simulando...",
      status_lid_open: "Pantalla abierta (135°)",
      status_lid_closed: "Pantalla cerrada (0°)",

      tagline_eyebrow: "Cómputo Continuo",
      tagline_text: "Cierra la pantalla. Tus agentes de IA, servidores y conexiones no se detienen.",

      eco_badge: "Ecosistema",
      eco_title: "Diseñado para Agentes de IA y Escritorio Remoto",
      eco_sub: "Awake! mantiene tus tareas activas sin necesidad de pantallas externas ni comandos complicados de terminal.",
      eco_ai_title: "Agentes de IA y Cómputo en Segundo Plano",
      eco_ai_badge: "Nunca se Interrumpen",
      eco_ai_desc: "Agentes de programación autónomos de varias horas, inferencia de LLMs y compilaciones continúan al 100% de velocidad Apple Silicon con la pantalla cerrada.",
      app_claude_role: "Programación Autónoma",
      app_agy_role: "Programador Pair en Terminal",
      app_codex_role: "Pipelines y Terminal LLMs",
      app_ollama_role: "LLMs Locales (Llama, DeepSeek)",
      eco_remote_title: "Acceso Remoto y Control",
      eco_remote_badge: "Cero Pantallas Negras",
      eco_remote_desc: "El brillo físico se apaga para ahorrar batería, mientras el framebuffer GPU de WindowServer sigue activo a 60 FPS para conectarte al instante.",
      app_sills_role: "Streaming iOS a Mac",
      app_rustdesk_role: "P2P Remoto Código Abierto",
      app_anydesk_role: "Acceso de Ultra Baja Latencia",
      app_tv_role: "Control de Escritorio Headless",

      duel_badge: "Arquitectura",
      duel_title: "Suspensión Normal vs. El Protocolo Awake!",
      duel_sub: "macOS suspende todas tus tareas al bajar la pantalla. Awake! te devuelve el control total de cuándo tu Mac realmente duerme.",
      trap_title: "Comportamiento por Defecto en macOS",
      trap_badge: "Disruptivo",
      trap_1_b: "Las tareas en segundo plano se congelan:",
      trap_1_t: " Renders en 4K, agentes de IA, contenedores Docker y descargas pesadas se detienen de inmediato.",
      trap_2_b: "Corte de energía en puertos USB:",
      trap_2_t: " Las unidades NVMe externas e interfaces de audio se desconectan forzadamente, arriesgando datos y audio.",
      trap_3_b: "Pantalla negra en Escritorio Remoto:",
      trap_3_t: " WindowServer apaga el framebuffer. Sesiones de Sill, VNC y AnyDesk quedan en negro total.",
      trap_4_b: "Audio imprevisto en público:",
      trap_4_t: " La música o videos siguen sonando si bajas la pantalla apresuradamente en una reunión o biblioteca.",

      awake_protocol_title: "El Protocolo Awake!",
      awake_protocol_badge: "Impecable",
      awake_1_b: "Cómputo ininterrumpido:",
      awake_1_t: " CPU y GPU continúan operando al máximo. Servidores locales y agentes de IA terminan sin interrupciones.",
      awake_2_b: "Energía garantizada en puertos USB:",
      awake_2_t: " Discos NVMe, hubs USB e interfaces de audio se mantienen alimentados de forma continua.",
      awake_3_b: "Escritorio Remoto fluido:",
      awake_3_t: " El brillo del display baja a 0 para ahorrar batería, pero el framebuffer sigue transmitiendo a 60 FPS.",
      awake_4_b: "Guardián Shh! Silencio Inteligente:",
      awake_4_t: " Pausa la reproducción al instante y silencia altavoces/AirPods al cerrar la tapa. Restaura el volumen al abrirla.",

      bento_badge: "Capacidades",
      bento_title: "Creado para usuarios avanzados. Diseñado para todos.",
      bento_sub: "Ingeniería en Swift nativo puro. Sin Electron, sin sobrecarga y sin procesos innecesarios.",
      bento_shh_title: "Shh! Cortina Inteligente de Audio y Medios",
      bento_shh_desc: "Se conecta directamente a CoreAudio y MediaRemote. Ya sea que escuches con altavoces internos, AirPods o interfaces USB de audio, cerrar la tapa silencia el sonido y pausa la música al instante. Al volver a abrir la pantalla, restaura tu volumen automáticamente.",
      bento_remote_title: "Escritorio Remoto Continuo",
      bento_remote_desc: "Conéctate desde tu iPad o computadora secundaria con Sill, RustDesk o AnyDesk sin pantallas negras ni interrupciones. El brillo físico se apaga para no gastar batería, pero el streaming a 60 FPS continúa activo.",
      bento_security_title: "Configuración en un Clic",
      bento_security_desc: "Solo necesita autorización durante la instalación inicial. Después de eso, puedes activarla o pausarla directamente desde la barra de menús sin que vuelva a pedirte contraseña.",
      bento_ram_title: "Swift Nativo y Ligero",
      bento_ram_desc: "Cero Electron, cero procesos innecesarios. Una utilidad de barra de menús rápida que no consume recursos de tu procesador cuando está en espera.",

      pipe_badge: "Cómo Opera",
      pipe_title: "El Pipeline de Hardware en 3 Pasos",
      pipe_sub: "Ejecución transparente en Swift comunicándose con los frameworks nativos del sistema.",
      pipe_step1_title: "1. Sensor Magnético IOKit",
      pipe_step1_desc: "Escucha cambios físicos de la bisagra a través de AppleACPIPlatformExpert e IOPMrootDomain.",
      pipe_step2_title: "2. Aserción pmset Restringida",
      pipe_step2_desc: "Aplica disablesleep 1 sin pedir contraseña, indicando a la gestión de energía ignorar el cierre de tapa.",
      pipe_step3_title: "3. Control de Pantalla y Audio",
      pipe_step3_desc: "Baja la luz de pantalla a 0 conservando WindowServer, pausa la reproducción y silencia CoreAudio.",

      matrix_badge: "Comparativa",
      matrix_title: "Awake! frente a Utilidades Tradicionales",
      matrix_sub: "Por qué los scripts clásicos de caffeinate y apps antiguas fallan en macOS moderno.",
      th_feature: "Característica",
      th_awake: "Awake!",
      th_amp: "Amphetamine",
      th_caff: "caffeinate (CLI)",
      row_1: "Tapa cerrada sin monitor externo",
      row_2: "Energía USB continua",
      row_3: "Escritorio Remoto (Sill, VNC) sin pantalla negra",
      row_4: "Silencio inteligente al cerrar (Shh!)",
      row_5: "Permisos de Administrador",
      row_6: "Rendimiento en Reposo",
      row_7: "Licencia y Telemetría",

      creator_bio: "Awake! es un proyecto independiente y 100% código abierto desarrollado con mucho cariño. Sin anuncios, sin telemetría y sin rastreadores. Si te ahorró tiempo o cuidó tus descargas y servidores, ¡invítame un café para apoyar el desarrollo continuo!",
      tip_1_title: "Gracias por tu apoyo",
      tip_3_title: "¡Muchas gracias!",
      tip_5_title: "¡Muchísimas gracias!",
      tip_kofi_btn: "Apoyar en Ko-fi",
      jar_header: "Apoyo Directo en Ko-fi",
      jar_tier1: "Café",
      jar_tier2: "Patrocinador",
      jar_tier3: "Super Supporter",
      jar_footer: "Pagos seguros procesados por Stripe y PayPal en Ko-fi",

      faq_badge: "Respuestas",
      faq_title: "Preguntas Frecuentes",
      faq_q1: "¿Se sobrecalentará mi MacBook con la tapa cerrada dentro de una mochila?",
      faq_a1: "Los chips Apple Silicon (M1 a M4) operan extraordinariamente fríos en cargas moderadas. Sin embargo, si estás exportando video 4K o entrenando modelos de IA en una mochila cerrada y aislada, el calor no tiene cómo disiparse. Recomendamos desactivar Awake! antes de guardar la laptop para viajes con renders pesados.",
      faq_q2: "¿Por qué Awake! no me pide contraseña cada vez que la uso?",
      faq_a2: "Durante la configuración inicial con 1 clic en el onboarding, Awake! genera una regla en /etc/sudoers.d/awake que autoriza a tu usuario específico a ejecutar pmset -a disablesleep sin contraseña. La app nunca corre como root ni se conecta a internet.",
      faq_q3: "¿Funciona Shh! con AirPods e interfaces de audio USB?",
      faq_a3: "Sí. Shh! se comunica directamente con CoreAudio y MediaRemote. Ya sea que uses altavoces internos, AirPods, audífonos o tarjetas profesionales de audio (Focusrite Scarlett, Apollo, SSL), la música se pausa y el sonido se silencia de inmediato al cerrar la pantalla.",
      faq_q4: "¿Cómo desinstalo Awake! por completo?",
      faq_a4: "Awake! no deja ningún daemon oculto ni procesos en segundo plano. Simplemente arrastra Awake!.app a la Papelera y elimina la regla de sudoers con: sudo rm -f /etc/sudoers.d/awake.",

      final_title: "Bajas la tapa. Tu Mac sigue trabajando.",
      final_desc: "Descarga el DMG universal para macOS o compila directamente desde código fuente. 100% libre y seguro.",
      final_download_btn: "Descargar Awake! v1.0.1 (DMG)",
      final_github_btn: "Ver Código en GitHub"
    }
  };

  let currentLang = 'es';

  // --- Dynamic DOM Translation Engine ---
  function setLanguage(lang) {
    currentLang = lang;
    localStorage.setItem('awake_lang', lang);
    const dict = i18n[lang] || i18n.es;

    document.querySelectorAll('[data-i18n]').forEach((el) => {
      const key = el.getAttribute('data-i18n');
      if (dict[key]) {
        if (key.includes('_title') && dict[key].includes('<br>')) {
          el.innerHTML = dict[key];
        } else {
          el.textContent = dict[key];
        }
      }
    });

    // Update Lang Nav Button
    const langDisplay = document.getElementById('langDisplay');
    if (langDisplay) {
      langDisplay.innerHTML = lang === 'es' ? '<strong>🇲🇽 ES</strong> / 🇺🇸 EN' : '🇲🇽 ES / <strong>🇺🇸 EN</strong>';
    }

    const simLangToggle = document.getElementById('simLangToggle');
    if (simLangToggle) {
      simLangToggle.textContent = lang === 'es' ? '[ ES | EN ]' : '[ EN | ES ]';
    }

    document.title = dict.page_title || "Awake!";
    document.documentElement.setAttribute('lang', lang);

    // Rebuild Tagline reveal words with guaranteed spacing
    buildTaglineReveal();

    // Refresh simulation texts and auto demo button state
    updateSimulatorState();
  }

  // --- Apple Keynote Tagline Reveal (Word-by-word scroll trigger with explicit text spaces) ---
  function buildTaglineReveal() {
    const box = document.getElementById('taglineBox');
    if (!box) return;

    const dict = i18n[currentLang] || i18n.es;
    const fullText = dict.tagline_text;
    const words = fullText.split(' ');

    box.innerHTML = '';
    words.forEach((word) => {
      const span = document.createElement('span');
      span.className = 'tagline-word';
      span.textContent = word;
      box.appendChild(span);
      // Guarantee explicit space text node to avoid browser layout word concatenation
      box.appendChild(document.createTextNode(' '));
    });
  }

  function handleTaglineScroll() {
    const box = document.getElementById('taglineBox');
    if (!box) return;

    const rect = box.getBoundingClientRect();
    const windowHeight = window.innerHeight;

    if (rect.top < windowHeight * 0.88 && rect.bottom > 0) {
      const spans = box.querySelectorAll('.tagline-word');
      const progress = Math.min(1, Math.max(0, (windowHeight * 0.80 - rect.top) / (rect.height + 140)));
      const wordsToReveal = Math.floor(progress * spans.length * 1.35);

      spans.forEach((span, idx) => {
        if (idx <= wordsToReveal) {
          span.classList.add('revealed');
        } else {
          span.classList.remove('revealed');
        }
      });
    }
  }

  // --- Interactive MacBook & Awake! HUD Simulator Engine ---
  let isAwakeActive = true;
  let isShhActive = true;
  let isLaunchAtLogin = true;
  let lidAngle = 135; // degrees: 135 = fully open, 0 = fully closed
  let isAutoDemoRunning = false;

  function updateSimulatorState() {
    const dict = i18n[currentLang] || i18n.es;
    const heroStage = document.querySelector('.hero-stage');
    const lidAssembly = document.getElementById('macbookLidAssembly');
    const screenOverlay = document.getElementById('screenSleepOverlay');
    const hudCard = document.getElementById('hudCard');
    const virtualDisplay = document.getElementById('virtualDisplayHud');
    const menuBarIcon = document.getElementById('menuBarIcon');
    const lidDot = document.getElementById('simLidDot');
    const lidText = document.getElementById('simLidStatusText');
    const usbText = document.getElementById('simUsbStatusText');
    const portLeft = document.getElementById('portLeft');
    const portRight = document.getElementById('portRight');
    const waveformRow = document.getElementById('simWaveformRow');
    const audioLabel = waveformRow ? waveformRow.querySelector('span') : null;
    const lidSlider = document.getElementById('lidAngleSlider');
    const lidReadout = document.getElementById('lidReadout');
    const autoDemoBtn = document.getElementById('autoDemoBtn');
    const autoDemoText = document.getElementById('autoDemoText');

    // Telemetry Elements
    const telCpu = document.getElementById('telCpu');
    const telUsb = document.getElementById('telUsb');
    const telRemote = document.getElementById('telRemote');

    const isLidClosed = lidAngle <= 25;

    // Toggle container classes for Virtual Display & 3D Model
    if (heroStage) {
      heroStage.classList.toggle('is-lid-closed', isLidClosed);
    }

    const macbookModel = document.getElementById('macbookModel');
    if (macbookModel) {
      macbookModel.classList.toggle('is-closed', isLidClosed);
    }

    // 1. Physically apply 3D Lid Folding Transform via CSS 3D transition
    if (lidAssembly) {
      const lidRot = isLidClosed ? 0 : 115;
      lidAssembly.style.setProperty('--lid-rot', `${lidRot}deg`);
    }

    // 2. Synchronize Direct Click Hint Text
    const clickHintText = document.getElementById('macbookClickHintText');
    if (clickHintText) {
      clickHintText.textContent = isLidClosed ? dict.hint_click_open : dict.hint_click_close;
    }

    // 3. Synchronize Clamshell Status Badge
    const clamshellBadgeText = document.getElementById('clamshellBadgeText');
    const clamshellBadgeDot = document.getElementById('clamshellBadgeDot');
    if (clamshellBadgeText) {
      clamshellBadgeText.textContent = isLidClosed ? dict.clamshell_badge_closed : dict.clamshell_badge_open;
    }
    if (clamshellBadgeDot) {
      clamshellBadgeDot.className = isLidClosed ? 'clamshell-badge-dot closed' : 'clamshell-badge-dot open';
    }

    // Fallback sync for buttons/readouts if present
    const lidToggleBtn = document.getElementById('lidToggleBtn');
    const lidToggleBtnText = document.getElementById('lidToggleBtnText');
    const lidToggleIcon = document.getElementById('lidToggleIcon');
    const simStatusDot = document.getElementById('simStatusDot');

    if (lidToggleBtnText) {
      lidToggleBtnText.textContent = isLidClosed ? dict.demo_btn_open : dict.demo_btn_close;
    }

    if (lidToggleBtn) {
      lidToggleBtn.classList.toggle('is-closed', isLidClosed);
    }

    if (lidToggleIcon) {
      if (isLidClosed) {
        // Upward opening icon
        lidToggleIcon.innerHTML = '<rect x="3" y="10" width="18" height="10" rx="2"></rect><path d="M2 20h20"></path><path d="M9 8l3-3 3 3"></path><line x1="12" y1="5" x2="12" y2="12"></line>';
      } else {
        // Downward closing icon
        lidToggleIcon.innerHTML = '<rect x="3" y="4" width="18" height="12" rx="2"></rect><path d="M2 20h20"></path><path d="M9 16l3 3 3-3"></path>';
      }
    }

    if (simStatusDot) {
      simStatusDot.className = isLidClosed ? 'sim-status-dot closed' : 'sim-status-dot open';
    }

    if (lidReadout) {
      lidReadout.textContent = isLidClosed ? dict.status_lid_closed : dict.status_lid_open;
      lidReadout.style.color = isLidClosed ? 'var(--accent-blue)' : 'var(--accent-green)';
    }

    // Legacy auto-demo text sync (if present)
    if (autoDemoText) {
      autoDemoText.textContent = isLidClosed ? dict.demo_btn_open : dict.demo_btn_close;
    }

    // 4. Virtual Display HUD State (cleanly reset styles when open)
    if (virtualDisplay) {
      if (isLidClosed) {
        if (!isAwakeActive) {
          virtualDisplay.style.filter = 'grayscale(1) brightness(0.4)';
          virtualDisplay.style.opacity = '0.35';
        } else {
          virtualDisplay.style.filter = '';
          virtualDisplay.style.opacity = '';
        }
      } else {
        virtualDisplay.style.filter = '';
        virtualDisplay.style.opacity = '';
      }
    }

    // 5. Lid Status Pill & Dot
    if (lidDot && lidText) {
      if (isLidClosed) {
        lidDot.className = 'indicator-circle orange';
        lidText.textContent = dict.hud_lid_closed;
      } else {
        lidDot.className = 'indicator-circle';
        lidText.textContent = dict.hud_lid_open;
      }
    }

    // 6. USB Bus Power, Hardware LEDs & Ports
    if (usbText) {
      if (isAwakeActive) {
        usbText.textContent = dict.hud_usb_active;
        usbText.style.color = 'var(--text-secondary)';
      } else {
        usbText.textContent = isLidClosed ? dict.hud_usb_unprotected : dict.hud_usb_active;
        usbText.style.color = isLidClosed ? 'var(--accent-red)' : 'var(--text-secondary)';
      }
    }

    if (portLeft && portRight) {
      if (isAwakeActive) {
        portLeft.className = 'usb-port active';
        portRight.className = 'usb-port active';
      } else {
        const cls = isLidClosed ? 'usb-port sleep-risk' : 'usb-port active';
        portLeft.className = cls;
        portRight.className = cls;
      }
    }

    // 7. Screen Sleep Overlay & Internal HUD Visibility
    if (screenOverlay && hudCard) {
      if (isLidClosed) {
        if (isAwakeActive) {
          // Display backlight goes to 0 (power saving), but WindowServer & HUD stay active
          screenOverlay.className = 'screen-sleep-overlay dimmed';
          hudCard.style.opacity = '0.88';
          hudCard.style.transform = 'scale(0.97)';
        } else {
          // Without Awake!: macOS enters sleep mode, cutting all processes
          screenOverlay.className = 'screen-sleep-overlay dark-sleep';
          hudCard.style.opacity = '0.12';
          hudCard.style.transform = 'scale(0.92)';
        }
      } else {
        screenOverlay.className = 'screen-sleep-overlay';
        hudCard.style.opacity = '1';
        hudCard.style.transform = 'scale(1)';
      }
    }

    // 8. Menu Bar Icon State
    if (menuBarIcon) {
      menuBarIcon.classList.toggle('active', isAwakeActive);
    }

    // 9. Shh! Smart Audio & Waveform Meter
    if (waveformRow && audioLabel) {
      if (isShhActive && isLidClosed) {
        waveformRow.classList.add('muted');
        audioLabel.textContent = dict.hud_audio_muted;
      } else {
        waveformRow.classList.remove('muted');
        audioLabel.textContent = dict.hud_audio_label;
      }
    }

    // 10. Real-Time Hardware Telemetry Badges
    if (telCpu) {
      if (isAwakeActive) {
        telCpu.textContent = currentLang === 'es' ? '100% Sin Freno' : '100% Unthrottled';
        telCpu.className = 'telemetry-pill-val green';
      } else {
        if (isLidClosed) {
          telCpu.textContent = currentLang === 'es' ? '0% Suspendido (Sleep)' : '0% Frozen (Sleep)';
          telCpu.className = 'telemetry-pill-val red';
        } else {
          telCpu.textContent = currentLang === 'es' ? '100% Activo' : '100% Active';
          telCpu.className = 'telemetry-pill-val green';
        }
      }
    }

    if (telUsb) {
      if (isAwakeActive) {
        telUsb.textContent = currentLang === 'es' ? '5V DC Continuo' : '5V DC Continuous';
        telUsb.className = 'telemetry-pill-val green';
      } else {
        if (isLidClosed) {
          telUsb.textContent = currentLang === 'es' ? '0V Cortado (Sleep)' : '0V Cutoff (Sleep)';
          telUsb.className = 'telemetry-pill-val red';
        } else {
          telUsb.textContent = currentLang === 'es' ? '5V DC Activo' : '5V DC Active';
          telUsb.className = 'telemetry-pill-val green';
        }
      }
    }

    if (telRemote) {
      if (isAwakeActive) {
        telRemote.textContent = currentLang === 'es' ? '60 FPS Transmitiendo' : '60 FPS Streaming';
        telRemote.className = 'telemetry-pill-val green';
      } else {
        if (isLidClosed) {
          telRemote.textContent = currentLang === 'es' ? 'Pantalla Negra (0 FPS)' : 'Black Screen (0 FPS)';
          telRemote.className = 'telemetry-pill-val red';
        } else {
          telRemote.textContent = currentLang === 'es' ? '60 FPS Local' : '60 FPS Local';
          telRemote.className = 'telemetry-pill-val green';
        }
      }
    }
  }

  // --- Native Hardware-Accelerated Clamshell Animation Engine ---
  let isLidTransitioning = false;
  let userManualClickOverride = false;
  let manualOverrideTimer = null;

  function runAutoDemo() {
    // Notify scroll observer to pause overriding for 4.5 seconds
    userManualClickOverride = true;
    clearTimeout(manualOverrideTimer);
    manualOverrideTimer = setTimeout(() => {
      userManualClickOverride = false;
    }, 4500);

    if (isLidTransitioning) return;
    isLidTransitioning = true;
    setTimeout(() => {
      isLidTransitioning = false;
    }, 720);

    const shouldClose = lidAngle > 30;
    lidAngle = shouldClose ? 0 : 135;
    trackEvent('lid-toggle-trigger', shouldClose ? 'Lid: Cerrar Pantalla' : 'Lid: Abrir Pantalla');

    updateSimulatorState();

    showToast(
      shouldClose
        ? (currentLang === 'es' 
            ? 'Pantalla cerrada: Cómputo activo al 100% y sin suspensión' 
            : 'Screen closed: 100% compute active with zero sleep')
        : (currentLang === 'es' 
            ? 'Pantalla abierta: Brillo y audio restaurados' 
            : 'Screen opened: Brightness and audio restored')
    );
  }

  function animateLid(targetAngle, durationMs, onComplete) {
    lidAngle = targetAngle;
    updateSimulatorState();
    if (onComplete) onComplete();
  }

  // --- Dynamic 3D Perspective Tilt on Mouse Movement ---
  function init3DTilt() {
    const scene = document.getElementById('dualFloatingScene') || document.querySelector('.dual-floating-scene');
    const interactiveUnit = document.getElementById('interactiveMacUnit');
    const companionUnit = document.querySelector('.mac-unit-companion');
    if (!scene || !interactiveUnit) return;

    scene.addEventListener('mousemove', (e) => {
      const rect = scene.getBoundingClientRect();
      const x = e.clientX - rect.left - rect.width / 2;
      const y = e.clientY - rect.top - rect.height / 2;

      const tiltY = (x / (rect.width / 2)) * 4.5;
      const tiltX = -(y / (rect.height / 2)) * 3.5;

      interactiveUnit.style.transform = `perspective(1400px) rotateY(${-13 + tiltY}deg) rotateX(${14 + tiltX}deg) rotateZ(2deg) translateZ(30px)`;
      if (companionUnit) {
        companionUnit.style.transform = `perspective(1400px) rotateY(${16 + tiltY * 0.75}deg) rotateX(${12 + tiltX * 0.75}deg) rotateZ(-3deg) translateZ(-40px)`;
      }
    });

    scene.addEventListener('mouseleave', () => {
      interactiveUnit.style.transform = 'perspective(1400px) rotateY(-13deg) rotateX(14deg) rotateZ(2deg) translateZ(30px)';
      if (companionUnit) {
        companionUnit.style.transform = 'perspective(1400px) rotateY(16deg) rotateX(12deg) rotateZ(-3deg) translateZ(-40px)';
      }
    });
  }

  // --- Scroll-Driven Clamshell Auto-Fold Engine ---
  function initScrollDrivenClamshell() {
    let isScrollTicking = false;

    window.addEventListener('scroll', () => {
      if (userManualClickOverride || isScrollTicking) return;
      isScrollTicking = true;

      requestAnimationFrame(() => {
        const hero = document.getElementById('overview');
        if (hero) {
          const rect = hero.getBoundingClientRect();
          // As the user scrolls down through the hero content:
          if (rect.top < -70 && lidAngle > 25) {
            lidAngle = 0;
            updateSimulatorState();
          } else if (rect.top >= -30 && lidAngle <= 25) {
            lidAngle = 135;
            updateSimulatorState();
          }
        }
        isScrollTicking = false;
      });
    }, { passive: true });
  }

  function initSimulator() {
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('lid')) {
      const parsed = parseInt(urlParams.get('lid'), 10);
      if (!isNaN(parsed)) lidAngle = Math.max(0, Math.min(135, parsed));
    }

    const awakeCapsule = document.getElementById('simAwakeCapsule');
    const shhCapsule = document.getElementById('simShhCapsule');
    const powerBtn = document.getElementById('simPowerBtn');
    const simLangToggle = document.getElementById('simLangToggle');
    const lidSlider = document.getElementById('lidAngleSlider');
    const menuBarIcon = document.getElementById('menuBarIcon');
    const autoDemoBtn = document.getElementById('autoDemoBtn');

    // Awake mode toggle
    if (awakeCapsule) {
      awakeCapsule.addEventListener('click', () => {
        isAwakeActive = !isAwakeActive;
        awakeCapsule.classList.toggle('active', isAwakeActive);
        updateSimulatorState();
      });
    }

    // Menu bar icon toggle (quick toggle)
    if (menuBarIcon) {
      menuBarIcon.addEventListener('click', () => {
        isAwakeActive = !isAwakeActive;
        if (awakeCapsule) awakeCapsule.classList.toggle('active', isAwakeActive);
        updateSimulatorState();
      });
    }

    // Shh mode toggle
    if (shhCapsule) {
      shhCapsule.addEventListener('click', () => {
        isShhActive = !isShhActive;
        shhCapsule.classList.toggle('active', isShhActive);
        updateSimulatorState();
      });
    }

    // Power launch at login toggle
    if (powerBtn) {
      powerBtn.addEventListener('click', () => {
        isLaunchAtLogin = !isLaunchAtLogin;
        powerBtn.classList.toggle('active', isLaunchAtLogin);
        showToast(isLaunchAtLogin ? "Launch at Login: Enabled" : "Launch at Login: Disabled");
      });
    }

    // In-HUD Language toggle
    if (simLangToggle) {
      simLangToggle.addEventListener('click', () => {
        const nextLang = currentLang === 'en' ? 'es' : 'en';
        setLanguage(nextLang);
      });
    }

    // 1. Primary Lid Toggle Action Button (if present)
    const lidToggleBtn = document.getElementById('lidToggleBtn');
    if (lidToggleBtn) {
      lidToggleBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        runAutoDemo();
      });
    }

    // 2. Direct Click on Floating Studio Status Badge
    const clamshellBadge = document.getElementById('clamshellStatusBadge');
    if (clamshellBadge) {
      clamshellBadge.addEventListener('click', (e) => {
        e.stopPropagation();
        runAutoDemo();
      });
    }

    // 3. Centralized 3D Dual Scene Click Handler
    // Clicking anywhere on the 3D scene, laptop body, lid, keyboard, or virtual display toggles the clamshell
    const dualScene = document.getElementById('dualFloatingScene') || document.querySelector('.dual-floating-scene') || document.querySelector('.hero-stage');
    if (dualScene) {
      dualScene.addEventListener('click', (e) => {
        // Prevent toggle if clicking on interactive controls inside open screen HUD or links/buttons
        if (e.target.closest('#simPowerBtn, #simLangToggle, #simAwakeCapsule, #simShhCapsule, .hud-power-btn, .hud-lang-toggle, .hud-capsule, button, a')) {
          return;
        }
        runAutoDemo();
      });
    }

    // Legacy auto-demo and slider fallbacks (if present)
    if (lidSlider) {
      lidSlider.addEventListener('input', (e) => {
        lidAngle = parseInt(e.target.value, 10);
        updateSimulatorState();
      });
    }
    if (autoDemoBtn) {
      autoDemoBtn.addEventListener('click', () => {
        runAutoDemo();
      });
    }

    init3DTilt();
    updateSimulatorState();
  }

  // --- Privacy-First Analytics Event Dispatcher (GoatCounter) ---
  function trackEvent(name, title) {
    if (window.goatcounter && typeof window.goatcounter.count === 'function') {
      window.goatcounter.count({
        path: name,
        title: title || name,
        event: true
      });
    }
  }

  // --- Track Outbound Conversions (Downloads, GitHub, Ko-fi) ---
  function initLinkAnalytics() {
    document.querySelectorAll('a[href]').forEach((link) => {
      const href = link.getAttribute('href') || '';

      if (href.includes('releases/download')) {
        link.addEventListener('click', () => {
          trackEvent('download-dmg-click', 'Descarga de Awake! DMG');
        });
      } else if (href.includes('github.com/Alex-Louder/Awake')) {
        link.addEventListener('click', () => {
          trackEvent('github-repo-click', 'Visita a Repositorio GitHub');
        });
      } else if (href.includes('ko-fi.com/alexlouder')) {
        link.addEventListener('click', () => {
          const amount = href.includes('amount=') ? href.split('amount=')[1] : 'general';
          trackEvent('kofi-tip-click-' + amount, 'Apoyo en Ko-fi: ' + amount);
        });
      }
    });
  }

  // --- Terminal Command Copying & Toast ---
  function showToast(msg) {
    const toast = document.getElementById('toastNotice');
    const toastMsg = document.getElementById('toastMsg');
    if (!toast) return;

    if (toastMsg) toastMsg.textContent = msg;
    toast.classList.add('show');

    setTimeout(() => {
      toast.classList.remove('show');
    }, 2800);
  }

  function initCopyHandler() {
    const copyBtn = document.getElementById('copyCmdBtn');
    const cmdEl = document.getElementById('installCmd');

    if (copyBtn && cmdEl) {
      copyBtn.addEventListener('click', async () => {
        const text = cmdEl.textContent.trim();
        trackEvent('copy-terminal-command', 'Copiar Comando de Terminal');
        try {
          await navigator.clipboard.writeText(text);
          showToast(currentLang === 'es' ? "Comando copiado al portapapeles" : "Command copied to clipboard");
        } catch (err) {
          const ta = document.createElement('textarea');
          ta.value = text;
          document.body.appendChild(ta);
          ta.select();
          document.execCommand('copy');
          document.body.removeChild(ta);
          showToast(currentLang === 'es' ? "Comando copiado" : "Command copied");
        }
      });
    }
  }

  // --- Theme Controller (Dark / Light) ---
  function initTheme() {
    const savedTheme = localStorage.getItem('awake_theme') || 'dark';
    document.documentElement.setAttribute('data-theme', savedTheme);

    const toggleBtn = document.getElementById('themeToggleBtn');
    if (toggleBtn) {
      toggleBtn.addEventListener('click', () => {
        const current = document.documentElement.getAttribute('data-theme') || 'dark';
        const next = current === 'dark' ? 'light' : 'dark';
        document.documentElement.setAttribute('data-theme', next);
        localStorage.setItem('awake_theme', next);
      });
    }
  }

  // --- FAQ Accordion ---
  function initFaq() {
    const items = document.querySelectorAll('.faq-item');
    items.forEach((item) => {
      const btn = item.querySelector('.faq-toggle-btn');
      if (btn) {
        btn.addEventListener('click', () => {
          const isOpen = item.classList.contains('open');
          items.forEach((other) => other.classList.remove('open'));
          if (!isOpen) item.classList.add('open');
        });
      }
    });
  }

  // --- Rich Scroll-Driven Animations & Staggered Reveal Observer ---
  function initScrollTransitions() {
    // 1. Assign staggered indices to main grid children (skip nested items)
    const gridContainers = document.querySelectorAll('.duel-grid, .bento-grid, .pipeline-grid, .faq-list');
    gridContainers.forEach((grid) => {
      Array.from(grid.children).forEach((child, idx) => {
        child.style.setProperty('--stagger-i', idx % 4);
        if (!child.classList.contains('t-panel-slide') && !child.classList.contains('reveal-on-scroll')) {
          child.classList.add('reveal-on-scroll');
        }
      });
    });

    // 2. Assign staggered reveals to section headers
    document.querySelectorAll('.section-label, .section-title, .section-sub').forEach((hdr) => {
      hdr.classList.add('reveal-on-scroll');
      if (hdr.classList.contains('section-label')) hdr.style.setProperty('--stagger-i', '0');
      else if (hdr.classList.contains('section-title')) hdr.style.setProperty('--stagger-i', '1');
      else if (hdr.classList.contains('section-sub')) hdr.style.setProperty('--stagger-i', '2');
    });

    const revealElements = document.querySelectorAll('.t-panel-slide, .reveal-on-scroll');

    if (!('IntersectionObserver' in window)) {
      revealElements.forEach((el) => {
        el.classList.add('t-revealed', 'is-revealed');
        el.dataset.open = "true";
      });
      return;
    }

    const observer = new IntersectionObserver((entries, obs) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add('t-revealed', 'is-revealed');
          entry.target.dataset.open = "true";
          obs.unobserve(entry.target);
        }
      });
    }, {
      rootMargin: '120px 0px 40px 0px',
      threshold: 0.01
    });

    revealElements.forEach((el) => {
      observer.observe(el);
    });
  }

  // --- Dynamic Floating Navbar Condenser on Scroll ---
  function handleNavScroll() {
    const navIsland = document.querySelector('.nav-island');
    if (navIsland) {
      navIsland.classList.toggle('is-scrolled', (window.scrollY || 0) > 40);
    }
  }

  function handlePageScroll() {
    handleNavScroll();
    handleTaglineScroll();
  }

  // --- Global Initialization ---
  document.addEventListener('DOMContentLoaded', () => {
    // Default to Spanish (user preference) or saved choice
    const savedLang = localStorage.getItem('awake_lang');
    const defaultLang = savedLang || 'es';
    setLanguage(defaultLang);

    // Language Toggle Button in Nav
    const langBtn = document.getElementById('langToggleBtn');
    if (langBtn) {
      langBtn.addEventListener('click', () => {
        setLanguage(currentLang === 'en' ? 'es' : 'en');
      });
    }

    initTheme();
    initSimulator();
    initScrollDrivenClamshell();
    initCopyHandler();
    initFaq();
    initScrollTransitions();
    initLinkAnalytics();

    // Scroll listeners (throttled)
    window.addEventListener('scroll', handlePageScroll, { passive: true });
    handlePageScroll();
  });

})();