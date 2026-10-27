/**
 * Awake! — Aurora Flow WebGL Background Shader Engine
 * Inspired by Framer's Aurora Flow component (Artem Kireev / Sohail Ansari)
 * 
 * Features:
 * - Multi-octave Fractal Brownian Motion (FBM) with domain warping
 * - Smooth cursor reactivity with organic vortex/eddy distortion
 * - Anti-AI-slop obsidian palette: Deep obsidian/midnight black, electric sapphire, radiant cyan/teal, subtle emerald edge
 * - Integrated film grain / dither in GLSL to eliminate banding
 * - Performance: Clamped devicePixelRatio (max 1.75), IntersectionObserver auto-pause, visibilitychange auto-pause, prefers-reduced-motion
 * - Graceful CSS fallback if WebGL is unavailable
 */

(function () {
  'use strict';

  function initAuroraFlow() {
    const canvas = document.getElementById('auroraCanvas');
    if (!canvas) return;

    // Check prefers-reduced-motion media query
    const motionQuery = window.matchMedia('(prefers-reduced-motion: reduce)');
    let prefersReducedMotion = motionQuery.matches;

    // WebGL Context Initialization
    const glOptions = {
      alpha: false,
      antialias: false,
      depth: false,
      stencil: false,
      powerPreference: 'high-performance',
      preserveDrawingBuffer: false
    };

    let gl = canvas.getContext('webgl2', glOptions)
          || canvas.getContext('webgl', glOptions)
          || canvas.getContext('experimental-webgl', glOptions);

    if (!gl) {
      canvas.classList.add('aurora-fallback');
      console.warn('Awake: WebGL not supported or disabled. Using CSS Aurora fallback.');
      return;
    }

    // Vertex Shader: Fullscreen Quad
    const vsSource = `
      attribute vec2 a_position;
      void main() {
        gl_Position = vec4(a_position, 0.0, 1.0);
      }
    `;

    // Fragment Shader: Domain Warping FBM + Cursor Vortex + Obsidian Palette + Film Grain
    const fsSource = `
      #ifdef GL_FRAGMENT_PRECISION_HIGH
      precision highp float;
      #else
      precision mediump float;
      #endif

      uniform vec2 u_resolution;
      uniform vec2 u_mouse;
      uniform float u_time;

      // Analytical 2D gradient noise hash
      vec2 hash2(vec2 p) {
          p = vec2(dot(p, vec2(127.1, 311.7)),
                   dot(p, vec2(269.5, 183.3)));
          return -1.0 + 2.0 * fract(sin(p) * 43758.5453123);
      }

      // 2D Gradient Noise with quintic Hermite smoothing
      float gnoise(vec2 p) {
          vec2 i = floor(p);
          vec2 f = fract(p);
          vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
          return mix(
              mix(dot(hash2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
                  dot(hash2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
              mix(dot(hash2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
                  dot(hash2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x),
              u.y
          );
      }

      const mat2 mRot = mat2(0.85, 0.52, -0.52, 0.85);

      // Silky 4-octave FBM tuned for laminar fluid ribbons
      float fbm(vec2 p) {
          float f = 0.0;
          f += 0.52 * gnoise(p);
          p = mRot * p * 1.95;
          f += 0.28 * gnoise(p);
          p = mRot * p * 2.05;
          f += 0.14 * gnoise(p);
          p = mRot * p * 2.15;
          f += 0.06 * gnoise(p);
          return f;
      }

      void main() {
          vec2 uv = gl_FragCoord.xy / u_resolution.xy;
          vec2 p = (gl_FragCoord.xy * 2.0 - u_resolution.xy) / min(u_resolution.x, u_resolution.y);
          
          // Diagonal ribbon orientation
          p = mat2(0.95, -0.31, 0.31, 0.95) * p;
          p.x *= 0.70;
          p.y *= 1.10;

          // Mouse reactivity: organic vortex / eddy around cursor
          vec2 mousePos = (u_mouse * 2.0 - 1.0) * (u_resolution.xy / min(u_resolution.x, u_resolution.y));
          mousePos = mat2(0.95, -0.31, 0.31, 0.95) * mousePos;
          mousePos.x *= 0.70;
          mousePos.y *= 1.10;

          vec2 mDelta = p - mousePos;
          float mDist = length(mDelta);
          float mInfluence = smoothstep(0.95, 0.0, mDist);
          vec2 vortex = vec2(-mDelta.y, mDelta.x) * mInfluence * 0.40;
          vec2 push = normalize(mDelta + vec2(0.0001)) * mInfluence * 0.14;
          p += vortex + push;

          float t = u_time * 0.22;

          // Domain Warping (multi-octave FBM):
          // q = fbm(uv + t * 0.2)
          vec2 q = vec2(
              fbm(p + vec2(0.0, 0.0) + vec2(t * 0.20, t * 0.10)),
              fbm(p + vec2(3.7, 1.4) + vec2(-t * 0.12, t * 0.15))
          );

          // r = fbm(uv + 4.0 * q + t * 0.15)
          vec2 r = vec2(
              fbm(p + 3.2 * q + vec2(1.7, 9.2) + vec2(t * 0.15, -t * 0.08)),
              fbm(p + 3.2 * q + vec2(6.8, 2.9) + vec2(-t * 0.10, t * 0.12))
          );

          // f = fbm(uv + 4.0 * r)
          float f = fbm(p + 3.2 * r);

          // Anti-AI-slop obsidian palette
          vec3 c_obsidian1 = vec3(0.0235, 0.0314, 0.0549); // #06080e - Deep obsidian black base
          vec3 c_obsidian2 = vec3(0.0353, 0.0549, 0.0941); // #090e18 - Deep midnight base
          vec3 c_sapphire1 = vec3(0.0392, 0.2667, 0.4706); // #0a4478 - Deep electric sapphire
          vec3 c_sapphire2 = vec3(0.0941, 0.4667, 0.9490); // #1877f2 - Electric sapphire glow
          vec3 c_teal      = vec3(0.0000, 0.7059, 0.8471); // #00b4d8 - Radiant teal
          vec3 c_cyan      = vec3(0.0000, 0.8235, 0.7059); // #00d2b4 - Radiant cyan
          vec3 c_emerald   = vec3(0.0196, 0.4706, 0.3412); // #057857 - Subtle emerald undertone

          float fNorm = f * 0.5 + 0.5;
          float ribbon = smoothstep(0.28, 0.72, fNorm);
          float crest = smoothstep(0.55, 0.88, fNorm * 1.1 + length(q) * 0.4);

          // 1. Deep obsidian base
          vec3 col = mix(c_obsidian1, c_obsidian2, clamp(fNorm * 0.7, 0.0, 1.0));

          // 2. Sapphire flowing body
          float sapphire = smoothstep(0.18, 0.65, ribbon);
          col = mix(col, c_sapphire1, sapphire * 0.85);

          // 3. Vibrant electric sapphire glow
          float electric = smoothstep(0.25, 0.70, length(r)) * ribbon;
          col = mix(col, c_sapphire2, electric * 0.75);

          // 4. Radiant teal ribbon stream
          float teal = smoothstep(0.38, 0.78, fNorm * 0.9 + r.x * 0.5) * ribbon;
          col = mix(col, c_teal, teal * 0.80);

          // 5. Radiant cyan luminous crests (concentrated on the sharpest folds)
          col = mix(col, c_cyan, pow(crest, 2.2) * 0.90);

          // 6. Subtle emerald undertones on ribbon edges
          float emerald = pow(clamp(r.y * 0.85, 0.0, 1.0), 2.2) * (1.0 - crest) * ribbon;
          col += c_emerald * emerald * 0.32;

          // 7. Fine filament sheen
          float ridge = pow(clamp(1.0 - abs(f * 1.35), 0.0, 1.0), 3.0);
          col += c_cyan * ridge * 0.28 * ribbon;

          // Atmospheric vertical bleed and soft vignette
          float bottomFade = smoothstep(0.0, 0.20, uv.y);
          float topFade = smoothstep(1.0, 0.92, uv.y);
          col = mix(c_obsidian1, col, bottomFade * topFade);

          // Built-in procedural optical grain/dither in GLSL
          float grain = (fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453) - 0.5) * 0.035;
          col += grain;

          gl_FragColor = vec4(col, 1.0);
      }
    `;

    function compileShader(glContext, type, source) {
      const shader = glContext.createShader(type);
      glContext.shaderSource(shader, source);
      glContext.compileShader(shader);
      if (!glContext.getShaderParameter(shader, glContext.COMPILE_STATUS)) {
        console.error('Awake: Shader compilation failed:', glContext.getShaderInfoLog(shader));
        glContext.deleteShader(shader);
        return null;
      }
      return shader;
    }

    let program = null;
    let quadBuffer = null;
    let uResolutionLoc = null;
    let uMouseLoc = null;
    let uTimeLoc = null;
    let aPositionLoc = -1;

    function buildProgram() {
      const vs = compileShader(gl, gl.VERTEX_SHADER, vsSource);
      const fs = compileShader(gl, gl.FRAGMENT_SHADER, fsSource);
      if (!vs || !fs) return false;

      program = gl.createProgram();
      gl.attachShader(program, vs);
      gl.attachShader(program, fs);
      gl.linkProgram(program);

      if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
        console.error('Awake: Program link failed:', gl.getProgramInfoLog(program));
        return false;
      }

      gl.useProgram(program);

      // Create fullscreen quad buffer [-1..1]
      quadBuffer = gl.createBuffer();
      gl.bindBuffer(gl.ARRAY_BUFFER, quadBuffer);
      gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
        -1.0, -1.0,
         1.0, -1.0,
        -1.0,  1.0,
        -1.0,  1.0,
         1.0, -1.0,
         1.0,  1.0
      ]), gl.STATIC_DRAW);

      aPositionLoc = gl.getAttribLocation(program, 'a_position');
      gl.enableVertexAttribArray(aPositionLoc);
      gl.vertexAttribPointer(aPositionLoc, 2, gl.FLOAT, false, 0, 0);

      uResolutionLoc = gl.getUniformLocation(program, 'u_resolution');
      uMouseLoc = gl.getUniformLocation(program, 'u_mouse');
      uTimeLoc = gl.getUniformLocation(program, 'u_time');

      return true;
    }

    if (!buildProgram()) {
      canvas.classList.add('aurora-fallback');
      return;
    }

    // Coordinate & Interaction state
    // Resting position: center-right where the hardware simulator sits
    const mouse = { x: 0.65, y: 0.45 };
    const targetMouse = { x: 0.65, y: 0.45 };
    let startTime = performance.now();
    let isIntersecting = true;
    let isDocumentVisible = !document.hidden;
    let animationFrameId = null;

    // Handle Window Resize with DPR Clamping (max 1.75 to protect GPU fill rate)
    function resizeCanvas() {
      const dpr = Math.min(window.devicePixelRatio || 1, 1.75);
      const rect = canvas.getBoundingClientRect();
      const displayWidth = Math.max(1, Math.round(rect.width * dpr));
      const displayHeight = Math.max(1, Math.round(rect.height * dpr));

      if (canvas.width !== displayWidth || canvas.height !== displayHeight) {
        canvas.width = displayWidth;
        canvas.height = displayHeight;
        gl.viewport(0, 0, displayWidth, displayHeight);
      }
    }

    // Render single frame
    function drawFrame(elapsedSec) {
      gl.useProgram(program);
      gl.bindBuffer(gl.ARRAY_BUFFER, quadBuffer);
      gl.vertexAttribPointer(aPositionLoc, 2, gl.FLOAT, false, 0, 0);

      gl.uniform2f(uResolutionLoc, canvas.width, canvas.height);
      gl.uniform2f(uMouseLoc, mouse.x, mouse.y);
      gl.uniform1f(uTimeLoc, elapsedSec);

      gl.drawArrays(gl.TRIANGLES, 0, 6);
    }

    // Animation Loop
    function render(now) {
      animationFrameId = null;

      // Smooth mouse easing (lerp with 0.055 inertia)
      mouse.x += (targetMouse.x - mouse.x) * 0.055;
      mouse.y += (targetMouse.y - mouse.y) * 0.055;

      const elapsed = (now - startTime) * 0.001;
      drawFrame(elapsed);

      // Continue loop if conditions still satisfied
      if (isIntersecting && isDocumentVisible && !prefersReducedMotion) {
        animationFrameId = requestAnimationFrame(render);
      }
    }

    function updateAnimationState() {
      const shouldRun = isIntersecting && isDocumentVisible && !prefersReducedMotion;
      if (shouldRun) {
        if (!animationFrameId) {
          animationFrameId = requestAnimationFrame(render);
        }
      } else {
        if (animationFrameId) {
          cancelAnimationFrame(animationFrameId);
          animationFrameId = null;
        }
      }
    }

    // Mouse Tracking across viewport / hero
    window.addEventListener('pointermove', (e) => {
      const rect = canvas.getBoundingClientRect();
      const x = (e.clientX - rect.left) / rect.width;
      const y = 1.0 - (e.clientY - rect.top) / rect.height; // Invert for WebGL coordinates
      targetMouse.x = Math.max(0.0, Math.min(1.0, x));
      targetMouse.y = Math.max(0.0, Math.min(1.0, y));
    }, { passive: true });

    window.addEventListener('pointerleave', () => {
      // Smoothly drift back to resting position
      targetMouse.x = 0.65;
      targetMouse.y = 0.45;
    }, { passive: true });

    // IntersectionObserver to pause rendering when scrolled past hero section
    const observer = new IntersectionObserver((entries) => {
      for (const entry of entries) {
        isIntersecting = entry.isIntersecting;
        updateAnimationState();
      }
    }, { rootMargin: '120px 0px 120px 0px' });
    observer.observe(canvas);

    // Page Visibility API to pause rendering when tab is hidden / minimized
    document.addEventListener('visibilitychange', () => {
      isDocumentVisible = !document.hidden;
      updateAnimationState();
    });

    // Prefers-reduced-motion listener
    motionQuery.addEventListener('change', (e) => {
      prefersReducedMotion = e.matches;
      if (prefersReducedMotion) {
        // Draw static serene frame and pause RAF
        drawFrame(7.2);
      }
      updateAnimationState();
    });

    // WebGL Context Lost & Restored
    canvas.addEventListener('webglcontextlost', (e) => {
      e.preventDefault();
      if (animationFrameId) {
        cancelAnimationFrame(animationFrameId);
        animationFrameId = null;
      }
    }, false);

    canvas.addEventListener('webglcontextrestored', () => {
      if (buildProgram()) {
        resizeCanvas();
        updateAnimationState();
      }
    }, false);

    // Window Resize Observer
    window.addEventListener('resize', () => {
      resizeCanvas();
      if (prefersReducedMotion) {
        drawFrame(7.2);
      }
    }, { passive: true });

    // Initial sizing and frame render
    resizeCanvas();
    if (prefersReducedMotion) {
      drawFrame(7.2);
    } else {
      updateAnimationState();
    }
  }

  // Auto-initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAuroraFlow);
  } else {
    initAuroraFlow();
  }
})();
