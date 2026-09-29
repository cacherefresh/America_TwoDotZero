import * as THREE from './three.module.min.js';

const scenes = new Map();

function buildScene(container) {
  const canvas = document.createElement('canvas');
  canvas.style.display = 'block';
  canvas.style.width = '100%';
  canvas.style.height = '100%';
  container.appendChild(canvas);

  const renderer = new THREE.WebGLRenderer({ canvas, alpha: true, antialias: true });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));

  const scene = new THREE.Scene();
  const camera = new THREE.PerspectiveCamera(60, 1, 0.1, 100);
  camera.position.z = 12;

  const particleCount = 900;
  const positions = new Float32Array(particleCount * 3);
  for (let i = 0; i < particleCount * 3; i++) {
    positions[i] = (Math.random() - 0.5) * 40;
  }
  const particleGeometry = new THREE.BufferGeometry();
  particleGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
  const particleMaterial = new THREE.PointsMaterial({
    color: 0x66e0ff,
    size: 0.08,
    transparent: true,
    opacity: 0.85,
    blending: THREE.AdditiveBlending,
    depthWrite: false,
  });
  const particles = new THREE.Points(particleGeometry, particleMaterial);
  scene.add(particles);

  const shapeDefs = [
    { geo: new THREE.IcosahedronGeometry(2, 0), color: 0x8a5cff },
    { geo: new THREE.TorusKnotGeometry(1.4, 0.4, 100, 16), color: 0x00e5ff },
    { geo: new THREE.OctahedronGeometry(1.8, 0), color: 0xff5cf0 },
  ];
  const shapes = shapeDefs.map(({ geo, color }, i) => {
    const material = new THREE.MeshBasicMaterial({
      color,
      wireframe: true,
      transparent: true,
      opacity: 0.35,
    });
    const mesh = new THREE.Mesh(geo, material);
    mesh.position.set((i - 1) * 6, Math.sin(i) * 3, -5 - i * 2);
    scene.add(mesh);
    return mesh;
  });

  const state = { pointer: { x: 0, y: 0 }, scroll: 0, focus: -1 };
  let rafId = null;
  let running = false;

  function resize() {
    const w = container.clientWidth || 1;
    const h = container.clientHeight || 1;
    renderer.setSize(w, h, false);
    camera.aspect = w / h;
    camera.updateProjectionMatrix();
  }

  const resizeObserver = new ResizeObserver(resize);
  resizeObserver.observe(container);
  resize();

  function tick() {
    if (!running) return;
    rafId = requestAnimationFrame(tick);

    particles.rotation.y += 0.0006;
    particles.rotation.x += 0.0002;

    shapes.forEach((mesh, i) => {
      mesh.rotation.x += 0.002 + i * 0.0005;
      mesh.rotation.y += 0.003;
      const focused = state.focus === i ? 0.75 : 0.35;
      mesh.material.opacity += (focused - mesh.material.opacity) * 0.05;
    });

    camera.position.x += (state.pointer.x * 2 - camera.position.x) * 0.02;
    camera.position.y += (-state.pointer.y * 1.5 - camera.position.y) * 0.02;
    camera.position.z = 12 + state.scroll * 0.002;
    camera.lookAt(0, 0, 0);

    renderer.render(scene, camera);
  }

  function start() {
    if (running) return;
    running = true;
    tick();
  }

  function stop() {
    running = false;
    if (rafId !== null) {
      cancelAnimationFrame(rafId);
      rafId = null;
    }
  }

  function dispose() {
    stop();
    resizeObserver.disconnect();
    particleGeometry.dispose();
    particleMaterial.dispose();
    shapes.forEach((mesh) => {
      mesh.geometry.dispose();
      mesh.material.dispose();
    });
    renderer.dispose();
  }

  return { state, start, stop, dispose };
}

function createHostElement(viewId) {
  const container = document.createElement('div');
  container.style.width = '100%';
  container.style.height = '100%';
  container.style.position = 'relative';
  container.style.overflow = 'hidden';

  const handle = buildScene(container);
  scenes.set(viewId, handle);
  handle.start();

  return container;
}

function setPointer(x, y) {
  for (const handle of scenes.values()) {
    handle.state.pointer.x = x;
    handle.state.pointer.y = y;
  }
}

function setScroll(offset) {
  for (const handle of scenes.values()) {
    handle.state.scroll = offset;
  }
}

function setFocus(index) {
  for (const handle of scenes.values()) {
    handle.state.focus = index;
  }
}

function pause() {
  for (const handle of scenes.values()) {
    handle.stop();
  }
}

function resume() {
  for (const handle of scenes.values()) {
    handle.start();
  }
}

function dispose(viewId) {
  const handle = scenes.get(viewId);
  if (!handle) return;
  handle.dispose();
  scenes.delete(viewId);
}

window.HoloBackground = { createHostElement, setPointer, setScroll, setFocus, pause, resume, dispose };
