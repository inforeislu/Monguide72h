/**
 * Service Worker for Mon Guide 72h
 * Caches core assets to enable 100% offline autonomy during network blackouts.
 */

const CACHE_NAME = "mon-guide-72h-v5";
const ASSETS_TO_CACHE = [
  "./",
  "./index.html",
  "./styles/main.css",
  "./js/i18n.js",
  "./js/qrcode.js",
  "./js/app.js",
  "./manifest.webmanifest",
  "./favicon.png",
  "./assets/icon-192.png",
  "./assets/icon-512.png",
  "./assets/logo.png"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(ASSETS_TO_CACHE);
    })
  );
  self.skipWaiting();
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys => {
      return Promise.all(
        keys.map(key => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    })
  );
  self.clients.claim();
});

self.addEventListener("fetch", event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request).catch(() => caches.match("./index.html"));
    })
  );
});
