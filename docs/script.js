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
      page_title: "Awake! — Lid Down. Work Goes On.",
      nav_overview: "Overview",
      nav_comparison: "Comparison",
      nav_architecture: "Architecture",
      nav_creator: "Creator",
      nav_faq: "FAQ",
      nav_download: "Download DMG",

      hero_badge: "macOS 14+ Sonoma • 15 Sequoia • 27 Golden Gate",
      hero_title: "Lid down.<br>Work goes on.",
      hero_desc: "Your Mac sleeps when you say so, not when the hinge clicks. Keep downloads active, NVMe drives mounted, and remote desktop alive without dummy dongles. With smart auto-mute the moment you shut the screen.",
      hero_cta_dmg: "Download Awake! v1.0.0",
      hero_cta_github: "GitHub Repository",

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

      tagline_eyebrow: "The Clamshell Problem Solved",
      tagline_text: "Engineered for developers, creators, and remote teams who refuse to let a closed hinge interrupt a single server, render, or download.",

      duel_badge: "Architecture",
      duel_title: "The Clamshell Trap vs. The Awake! Protocol",
      duel_sub: "macOS assumes that closing your laptop means you have stopped working. Awake! gives you back total control.",
      trap_title: "Default macOS Behavior",
      trap_badge: "Disruptive",
      trap_1_b: "Background tasks freeze:",
      trap_1_t: " 4K video renders, Docker containers, database migrations, and large downloads halt immediately.",
      trap_2_b: "USB bus power cut:",
      trap_2_t: " External SSDs and audio interfaces abruptly disconnect, risking file corruption and audio glitches.",
      trap_3_b: "Remote Desktop black screens:",
      trap_3_t: " WindowServer kills the display framebuffer. Remote sessions via Sills, VNC, and RustDesk go dark.",
      trap_4_b: "Audio blares in public:",
      trap_4_t: " Podcasts, music, or videos keep playing if you lower the lid quickly in quiet rooms.",

      awake_protocol_title: "The Awake! Protocol",
      awake_protocol_badge: "Seamless",
      awake_1_b: "Uninterrupted compute:",
      awake_1_t: " CPU and GPU continue operating at full capacity. Local servers and renders finish without stopping.",
      awake_2_b: "Guaranteed USB bus power:",
      awake_2_t: " External NVMe drives, USB hubs, and audio DACs (Focusrite, Apollo) stay continuously powered.",
      awake_3_b: "Crystal-clear Remote Desktop:",
      awake_3_t: " Screen brightness drops to zero to save battery, but GPU framebuffer streams at 60 FPS.",
      awake_4_b: "Shh! Auto-Mute Guardian:",
      awake_4_t: " Instantly pauses playback and mutes speakers/AirPods on lid shut. Restores volume on open.",

      bento_badge: "Capabilities",
      bento_title: "Built for power users. Refined for everyone.",
      bento_sub: "Engineered in pure native Swift. No Electron, no Chromium overhead, and no background daemons when idle.",
      bento_shh_title: "Shh! Smart Audio & Media Curtain",
      bento_shh_desc: "Hooks directly into macOS CoreAudio and MediaRemote. Whether you listen via internal speakers, AirPods, or an external USB audio interface, closing the lid mutes sound instantly and pauses playback. It seamlessly restores your previous volume when you open the lid.",
      bento_remote_title: "No Dummy Plugs Needed",
      bento_remote_desc: "Awake! dims your physical display backlight to 0 via DisplayServices while maintaining the WindowServer framebuffer. Connect remotely via Sills, VNC, RustDesk, or AnyDesk without black screen errors.",
      bento_security_title: "Zero Daily Password Prompts",
      bento_security_desc: "Awake! executes with minimum privileges. It sets a single rule in /etc/sudoers.d/awake scoped strictly to pmset -a disablesleep. The app itself never runs as root.",
      bento_ram_title: "~15 MB RAM • 0.0% Idle CPU",
      bento_ram_desc: "No periodic polling loops. Awake! relies purely on IOKit kernel event interrupts, leaving your CPU, RAM, and battery completely free for actual compilation and creative work.",

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
      row_3: "Remote Desktop (Sills, VNC) without black screen",
      row_4: "Smart Mute on lid close (Shh!)",
      row_5: "Daily password prompts",
      row_6: "Memory footprint",
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

      final_title: "Lid down. Work goes on.",
      final_desc: "Download the universal macOS DMG or compile directly from source. 100% free, private, and open source.",
      final_download_btn: "Download Awake! v1.0.0 (DMG)",
      final_github_btn: "View Source on GitHub"
    },

    es: {
      page_title: "Awake! — Bajas la tapa. Nada se detiene.",
      nav_overview: "Inicio",
      nav_comparison: "Comparativa",
      nav_architecture: "Arquitectura",
      nav_creator: "Creador",
      nav_faq: "FAQ",
      nav_download: "Descargar DMG",

      hero_badge: "macOS 14+ Sonoma • 15 Sequoia • 27 Golden Gate",
      hero_title: "Bajas la tapa.<br>Nada se detiene.",
      hero_desc: "Tu Mac duerme cuando tú lo decides, no cuando la bisagra se cierra. Mantén descargas activas, discos NVMe conectados y escritorio remoto funcionando sin adaptadores dummy. Con silencio inteligente al cerrar la pantalla.",
      hero_cta_dmg: "Descargar Awake! v1.0.0",
      hero_cta_github: "Repositorio en GitHub",

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

      tagline_eyebrow: "El Problema de Clamshell Resuelto",
      tagline_text: "Diseñada para desarrolladores, creadores y profesionales remotos que se niegan a que una bisagra cerrada interrumpa un solo servidor, render o descarga.",

      duel_badge: "Arquitectura",
      duel_title: "La Trampa de Clamshell vs. El Protocolo Awake!",
      duel_sub: "macOS asume que bajar la pantalla significa dejar de trabajar. Awake! te devuelve el control absoluto.",
      trap_title: "Comportamiento por Defecto en macOS",
      trap_badge: "Disruptivo",
      trap_1_b: "Las tareas en segundo plano se congelan:",
      trap_1_t: " Renders en 4K, contenedores Docker, migraciones de base de datos y descargas pesadas se detienen de inmediato.",
      trap_2_b: "Corte de energía en puertos USB:",
      trap_2_t: " Las unidades SSD externas e interfaces de audio se desconectan forzadamente, arriesgando datos y audio.",
      trap_3_b: "Pantalla negra en Escritorio Remoto:",
      trap_3_t: " WindowServer apaga el framebuffer. Sesiones de Sills, VNC y RustDesk quedan en negro total.",
      trap_4_b: "Audio imprevisto en público:",
      trap_4_t: " La música o videos siguen sonando si bajas la pantalla apresuradamente en una biblioteca o reunión.",

      awake_protocol_title: "El Protocolo Awake!",
      awake_protocol_badge: "Impecable",
      awake_1_b: "Cómputo ininterrumpido:",
      awake_1_t: " CPU y GPU continúan operando al máximo. Servidores locales y renders terminan sin interrupciones.",
      awake_2_b: "Energía garantizada en puertos USB:",
      awake_2_t: " Discos NVMe, hubs USB e interfaces de audio (Focusrite, Apollo) se mantienen alimentados a 5V.",
      awake_3_b: "Escritorio Remoto fluido:",
      awake_3_t: " El brillo del display baja a 0 para ahorrar batería, pero el framebuffer sigue transmitiendo a 60 FPS.",
      awake_4_b: "Guardián Shh! Silencio Inteligente:",
      awake_4_t: " Pausa la reproducción al instante y silencia altavoces/AirPods al cerrar la tapa. Restaura el volumen al abrirla.",

      bento_badge: "Capacidades",
      bento_title: "Creado para usuarios avanzados. Diseñado para todos.",
      bento_sub: "Ingeniería en Swift nativo puro. Sin Electron, sin sobrecarga de Chromium y sin procesos fantasma.",
      bento_shh_title: "Shh! Cortina Inteligente de Audio y Medios",
      bento_shh_desc: "Se conecta directamente a CoreAudio y MediaRemote. Ya sea que escuches con altavoces internos, AirPods o interfaces USB de audio, cerrar la tapa silencia el sonido y pausa la música al instante. Al volver a abrir la pantalla, restaura tu volumen automáticamente.",
      bento_remote_title: "Cero Adaptadores Dummy HDMI",
      bento_remote_desc: "Awake! atenúa la retroiluminación a cero con DisplayServices mientras sostiene activo el framebuffer de WindowServer. Conéctate vía Sills, VNC o RustDesk sin pantallas negras.",
      bento_security_title: "Cero Contraseñas en el Día a Día",
      bento_security_desc: "Awake! opera con mínimo privilegio. Configura una sola regla en /etc/sudoers.d/awake limitada estrictamente a pmset -a disablesleep. La aplicación jamás corre como root.",
      bento_ram_title: "~15 MB RAM • 0.0% CPU Inactivo",
      bento_ram_desc: "Sin bucles de sondeo continuo. Awake! funciona con interrupciones de eventos del kernel IOKit, dejando el 99.9% de tus recursos libres para compilar y crear.",

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
      row_3: "Escritorio Remoto (Sills, VNC) sin pantalla negra",
      row_4: "Silencio inteligente al cerrar (Shh!)",
      row_5: "Solicitudes de contraseña diarias",
      row_6: "Consumo de memoria RAM",
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

      final_title: "Bajas la tapa. Nada se detiene.",
      final_desc: "Descarga el DMG universal para macOS o compila directamente desde código fuente. 100% libre y seguro.",
      final_download_btn: "Descargar Awake! v1.0.0 (DMG)",
      final_github_btn: "Ver Código en GitHub"
    }
  };

  let currentLang = 'en';

  // --- Dynamic DOM Translation Engine ---
  function setLanguage(lang) {
    currentLang = lang;
    const dict = i18n[lang] || i18n.en;

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

    // Update Lang Buttons
    const langDisplay = document.getElementById('langDisplay');
    if (langDisplay) {
      langDisplay.innerHTML = lang === 'en' ? '<strong>EN</strong> / ES' : 'EN / <strong>ES</strong>';
    }

    const simLangToggle = document.getElementById('simLangToggle');
    if (simLangToggle) {
      simLangToggle.textContent = lang === 'en' ? '[ EN | ES ]' : '[ ES | EN ]';
    }

    document.title = dict.page_title || "Awake!";

    // Rebuild Tagline reveal words
    buildTaglineReveal();

    // Refresh simulation texts
    updateSimulatorState();
  }

  // --- Apple Keynote Tagline Reveal (Word-by-word scroll trigger) ---
  function buildTaglineReveal() {
    const box = document.getElementById('taglineBox');
    if (!box) return;

    const dict = i18n[currentLang] || i18n.en;
    const fullText = dict.tagline_text;
    const words = fullText.split(' ');

    box.innerHTML = '';
    words.forEach((word) => {
      const span = document.createElement('span');
      span.className = 'tagline-word';
      span.textContent = word + ' ';
      box.appendChild(span);
    });
  }

  function handleTaglineScroll() {
    const box = document.getElementById('taglineBox');
    if (!box) return;

    const rect = box.getBoundingClientRect();
    const windowHeight = window.innerHeight;

    // Trigger reveal when section enters viewport
    if (rect.top < windowHeight * 0.8 && rect.bottom > 0) {
      const spans = box.querySelectorAll('.tagline-word');
      const progress = Math.min(1, Math.max(0, (windowHeight * 0.75 - rect.top) / (rect.height + 100)));
      const wordsToReveal = Math.floor(progress * spans.length * 1.5);

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
  let lidAngle = 135; // degrees

  function updateSimulatorState() {
    const dict = i18n[currentLang] || i18n.en;
    const desktop = document.getElementById('macbookDesktop');
    const menuBarIcon = document.getElementById('menuBarIcon');
    const lidDot = document.getElementById('simLidDot');
    const lidText = document.getElementById('simLidStatusText');
    const usbText = document.getElementById('simUsbStatusText');
    const waveformRow = document.getElementById('simWaveformRow');
    const audioLabel = waveformRow ? waveformRow.querySelector('span') : null;
    const lidReadout = document.getElementById('lidReadout');
    const hudCard = document.getElementById('hudCard');

    const isLidClosed = lidAngle <= 25;

    // Readout text
    if (lidReadout) {
      lidReadout.textContent = `${lidAngle}° (${isLidClosed ? (currentLang === 'es' ? 'Cerrada' : 'Closed') : (currentLang === 'es' ? 'Abierta' : 'Open')})`;
      lidReadout.style.color = isLidClosed ? 'var(--accent-orange)' : 'var(--accent-green)';
    }

    // Lid Indicator Dot & Text
    if (lidDot && lidText) {
      if (isLidClosed) {
        lidDot.className = 'indicator-circle orange';
        lidText.textContent = dict.hud_lid_closed;
      } else {
        lidDot.className = 'indicator-circle';
        lidText.textContent = dict.hud_lid_open;
      }
    }

    // USB & Sleep State
    if (usbText) {
      if (isAwakeActive) {
        usbText.textContent = dict.hud_usb_active;
        usbText.style.color = 'var(--text-secondary)';
      } else {
        usbText.textContent = isLidClosed ? dict.hud_usb_unprotected : dict.hud_usb_active;
        usbText.style.color = isLidClosed ? 'var(--accent-red)' : 'var(--text-secondary)';
      }
    }

    // Screen brightness & Clamshell behavior
    if (desktop && hudCard) {
      if (isLidClosed) {
        if (isAwakeActive) {
          // Display backlight goes to 0 (power saving), but Awake HUD remains transparently visible
          desktop.classList.add('lid-closed');
          hudCard.style.opacity = '0.9';
          hudCard.style.transform = 'scale(0.97)';
        } else {
          // Mac goes to sleep completely
          desktop.classList.add('lid-closed');
          hudCard.style.opacity = '0.15';
          hudCard.style.transform = 'scale(0.92)';
        }
      } else {
        desktop.classList.remove('lid-closed');
        hudCard.style.opacity = '1';
        hudCard.style.transform = 'scale(1)';
      }
    }

    // Menu Bar Icon State
    if (menuBarIcon) {
      if (isAwakeActive) {
        menuBarIcon.classList.add('active');
      } else {
        menuBarIcon.classList.remove('active');
      }
    }

    // Shh Audio & Waveform state
    if (waveformRow && audioLabel) {
      if (isShhActive && isLidClosed) {
        waveformRow.classList.add('muted');
        audioLabel.textContent = dict.hud_audio_muted;
      } else {
        waveformRow.classList.remove('muted');
        audioLabel.textContent = dict.hud_audio_label;
      }
    }
  }

  function initSimulator() {
    const awakeCapsule = document.getElementById('simAwakeCapsule');
    const shhCapsule = document.getElementById('simShhCapsule');
    const powerBtn = document.getElementById('simPowerBtn');
    const simLangToggle = document.getElementById('simLangToggle');
    const lidSlider = document.getElementById('lidAngleSlider');
    const menuBarIcon = document.getElementById('menuBarIcon');

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

    // Lid angle slider
    if (lidSlider) {
      lidSlider.addEventListener('input', (e) => {
        lidAngle = parseInt(e.target.value, 10);
        updateSimulatorState();
      });
    }
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
    }, 2400);
  }

  function initCopyHandler() {
    const copyBtn = document.getElementById('copyCmdBtn');
    const cmdEl = document.getElementById('installCmd');

    if (copyBtn && cmdEl) {
      copyBtn.addEventListener('click', async () => {
        const text = cmdEl.textContent.trim();
        try {
          await navigator.clipboard.writeText(text);
          showToast(currentLang === 'es' ? "Comando copiado al portapapeles" : "Command copied to clipboard");
        } catch (err) {
          // Fallback
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
          // Close others
          items.forEach((other) => other.classList.remove('open'));
          if (!isOpen) item.classList.add('open');
        });
      }
    });
  }

  // --- Global Initialization ---
  document.addEventListener('DOMContentLoaded', () => {
    // Detect Browser Language or default to English
    const userPrefersEs = navigator.language && navigator.language.startsWith('es');
    setLanguage(userPrefersEs ? 'es' : 'en');

    // Language Toggle Button in Nav
    const langBtn = document.getElementById('langToggleBtn');
    if (langBtn) {
      langBtn.addEventListener('click', () => {
        setLanguage(currentLang === 'en' ? 'es' : 'en');
      });
    }

    initTheme();
    initSimulator();
    initCopyHandler();
    initFaq();

    // Scroll listeners (throttled)
    window.addEventListener('scroll', handleTaglineScroll, { passive: true });
    handleTaglineScroll();
  });

})();
