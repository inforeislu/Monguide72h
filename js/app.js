/**
 * Mon Guide 72h d'Autonomie - Application Logic
 * Supports 7 languages: FR, EN, LU, DE, ES, IT, PT
 * Features:
 * - 72h Vital Supplies Calculator
 * - Interactive Persistent Checklists
 * - Full Personal Emergency Plan (Foyer, Maison, Quartier, Contacts)
 * - Web Audio API Siren Sound Simulator (100% offline acoustic synthesis)
 * - OLED Blackout Mode & Screen Flashlight
 * - JSON Export/Import & Official A4 Print Formatting
 */

// Application State
const COUNTRIES_CONFIG = {
  eu: {
    flag: "🇪🇺",
    name: "Union Européenne",
    title: "🇪🇺 URGENCES EU :",
    p112Text: "📞 112 Urgence Européenne",
    p112Tel: "tel:112",
    secText: "🛡️ 116 000 Enfants Disparus",
    secTel: "tel:116000",
    crisisText: "ℹ️ 116 117 Non-Urgent",
    crisisTel: "tel:116117"
  },
  lu: {
    flag: "🇱🇺",
    name: "Luxembourg",
    title: "🚨 LUXEMBOURG URGENCES :",
    p112Text: "📞 112 CGDIS (Secours)",
    p112Tel: "tel:112",
    secText: "🛡️ 113 Police",
    secTel: "tel:113",
    crisisText: "ℹ️ 8002 7788 Info-Crise",
    crisisTel: "tel:80027788"
  },
  pt: {
    flag: "🇵🇹",
    name: "Portugal",
    title: "🚨 PORTUGAL EMERGÊNCIAS :",
    p112Text: "📞 112 Emergência Nacional",
    p112Tel: "tel:112",
    secText: "🔥 117 Incêndios Florestais",
    secTel: "tel:117",
    crisisText: "🏥 808 24 24 24 SNS 24",
    crisisTel: "tel:808242424"
  },
  fr: {
    flag: "🇫🇷",
    name: "France",
    title: "🚨 FRANCE URGENCES :",
    p112Text: "📞 112 Urgences (ou 15/18)",
    p112Tel: "tel:112",
    secText: "🛡️ 17 Police Secours",
    secTel: "tel:17",
    crisisText: "🏥 15 SAMU Urgences",
    crisisTel: "tel:15"
  },
  de: {
    flag: "🇩🇪",
    name: "Deutschland",
    title: "🚨 DEUTSCHLAND NOTRUF :",
    p112Text: "📞 112 Feuerwehr & Rettung",
    p112Tel: "tel:112",
    secText: "🛡️ 110 Polizei",
    secTel: "tel:110",
    crisisText: "🩺 116 117 Ärztl. Bereitschaft",
    crisisTel: "tel:116117"
  },
  es: {
    flag: "🇪🇸",
    name: "España",
    title: "🚨 ESPAÑA EMERGENCIAS :",
    p112Text: "📞 112 Emergencias",
    p112Tel: "tel:112",
    secText: "🛡️ 091 Policía Nacional",
    secTel: "tel:091",
    crisisText: "🚑 061 Urgencias Sanitarias",
    crisisTel: "tel:061"
  },
  it: {
    flag: "🇮🇹",
    name: "Italia",
    title: "🚨 ITALIA EMERGENZA :",
    p112Text: "📞 112 Numero Unico Europeo",
    p112Tel: "tel:112",
    secText: "🚒 115 Vigili del Fuoco",
    secTel: "tel:115",
    crisisText: "🚑 118 Emergenza Sanitaria",
    crisisTel: "tel:118"
  },
  be: {
    flag: "🇧🇪",
    name: "Belgique",
    title: "🚨 BELGIQUE SECOURS :",
    p112Text: "📞 112 Pompiers & Ambulance",
    p112Tel: "tel:112",
    secText: "🛡️ 101 Police Fédérale",
    secTel: "tel:101",
    crisisText: "🩺 1733 Médecin de garde",
    crisisTel: "tel:1733"
  },
  nl: {
    flag: "🇳🇱",
    name: "Nederland",
    title: "🚨 NEDERLAND ALARM :",
    p112Text: "📞 112 Alarmcentrale",
    p112Tel: "tel:112",
    secText: "🛡️ 0900-8844 Politie",
    secTel: "tel:09008844",
    crisisText: "ℹ️ NL-Alert Noodinformatie",
    crisisTel: "tel:112"
  },
  pl: {
    flag: "🇵🇱",
    name: "Polska",
    title: "🚨 POLSKA NUMERY ALARMOWE :",
    p112Text: "📞 112 Numer Ratunkowy",
    p112Tel: "tel:112",
    secText: "🚒 998 Straż Pożarna",
    secTel: "tel:998",
    crisisText: "🛡️ 997 Policja",
    crisisTel: "tel:997"
  },
  se: {
    flag: "🇸🇪",
    name: "Sverige",
    title: "🚨 SVERIGE NÖDSITUATION :",
    p112Text: "📞 112 SOS Alarm",
    p112Tel: "tel:112",
    secText: "🛡️ 114 14 Polisen",
    secTel: "tel:11414",
    crisisText: "ℹ️ 113 13 Krisinformation",
    crisisTel: "tel:11313"
  },
  fi: {
    flag: "🇫🇮",
    name: "Suomi",
    title: "🚨 SUOMI HÄTÄNUMEROT :",
    p112Text: "📞 112 Hätäkeskus",
    p112Tel: "tel:112",
    secText: "🩺 116 117 Päivystysapu",
    secTel: "tel:116117",
    crisisText: "🛡️ 112 Suomi Aluehälytys",
    crisisTel: "tel:112"
  },
  at: {
    flag: "🇦🇹",
    name: "Österreich",
    title: "🚨 ÖSTERREICH NOTRUF :",
    p112Text: "📞 112 Euro-Notruf",
    p112Tel: "tel:112",
    secText: "🚒 122 Feuerwehr",
    secTel: "tel:122",
    crisisText: "🚑 144 Rettung",
    crisisTel: "tel:144"
  },
  ie: {
    flag: "🇮🇪",
    name: "Ireland",
    title: "🚨 IRELAND EMERGENCY :",
    p112Text: "📞 112 / 999 Emergency",
    p112Tel: "tel:112",
    secText: "🛡️ Gardaí Police",
    secTel: "tel:999",
    crisisText: "🏥 HSE National Health",
    crisisTel: "tel:112"
  },
  gr: {
    flag: "🇬🇷",
    name: "Ελλάδα",
    title: "🚨 ΕΛΛΑΔΑ ΕΚΤΑΚΤΗ ΑΝΑΓΚΗ :",
    p112Text: "📞 112 Ευρωπαϊκός Αριθμός",
    p112Tel: "tel:112",
    secText: "🚒 199 Πυροσβεστική",
    secTel: "tel:199",
    crisisText: "🛡️ 100 Αστυνομία",
    crisisTel: "tel:100"
  }
};

const state = {
  currentLang: localStorage.getItem("mg72_lang") || "fr",
  currentCountry: localStorage.getItem("mg72_country") || "lu",
  blackout: localStorage.getItem("mg72_blackout") === "true",
  nightVision: localStorage.getItem("mg72_nightvision") === "true",
  calculator: {
    adults: 2,
    children: 1,
    babies: 0,
    pets: 1,
    days: 3
  },
  expiryItems: JSON.parse(localStorage.getItem("mg72_expiry_items") || "null") || [
    { name: "Pack 6x 1.5L Eau minérale", date: new Date(Date.now() + 365*24*3600*1000).toISOString().split("T")[0] },
    { name: "Boîtes de conserves (Thon, Légumes, Plats)", date: new Date(Date.now() + 720*24*3600*1000).toISOString().split("T")[0] },
    { name: "Piles alcalines AA & AAA (Radio / Torche)", date: new Date(Date.now() + 1000*24*3600*1000).toISOString().split("T")[0] },
    { name: "Trousse premiers secours & Compresses stériles", date: new Date(Date.now() + 450*24*3600*1000).toISOString().split("T")[0] }
  ],
  kitChecked: JSON.parse(localStorage.getItem("mg72_kit_checked") || "{}"),
  bagChecked: JSON.parse(localStorage.getItem("mg72_bag_checked") || "{}"),
  plan: JSON.parse(localStorage.getItem("mg72_plan_data") || "null") || {
    head: { name: "", address: "", city: "", dateCompleted: "", dateUpdated: "" },
    members: [],
    meds: [],
    pets: [],
    house: {},
    neighborhood: { helpers: [], needHelp: [] },
    emergency: {},
    providers: {}
  }
};

// Web Audio API context for Siren Generation
let audioCtx = null;
let currentSiren = null;

function getAudioContext() {
  if (!audioCtx) {
    const AudioContext = window.AudioContext || window.webkitAudioContext;
    audioCtx = new AudioContext();
  }
  if (audioCtx.state === "suspended") {
    audioCtx.resume();
  }
  return audioCtx;
}

// Siren sound synthesis
function stopSiren() {
  if (currentSiren) {
    try {
      currentSiren.osc.stop();
      currentSiren.osc.disconnect();
      clearInterval(currentSiren.timer);
    } catch (e) {
      console.warn(e);
    }
    currentSiren = null;
  }
  document.querySelectorAll(".siren-audio-btn").forEach(btn => {
    btn.classList.remove("playing");
    btn.textContent = I18N[state.currentLang].playAudio;
  });
}

function playSiren(type, btnElement) {
  if (currentSiren) {
    stopSiren();
    return;
  }

  const ctx = getAudioContext();
  const osc = ctx.createOscillator();
  const gain = ctx.createGain();
  osc.type = "sawtooth"; // Gives that rich horn/acoustic siren overtone
  gain.gain.setValueAtTime(0.2, ctx.currentTime);
  osc.connect(gain);
  gain.connect(ctx.destination);

  btnElement.classList.add("playing");
  btnElement.textContent = I18N[state.currentLang].stopAudio;

  const startTime = ctx.currentTime;
  osc.start(startTime);

  if (type === "test" || type === "alert") {
    // Continuous tone at ~420 Hz
    osc.frequency.setValueAtTime(420, startTime);
    const duration = type === "test" ? 15 : 25; // Play 15s/25s in demo
    osc.stop(startTime + duration);
    osc.onended = () => stopSiren();
    currentSiren = { osc, timer: null };
  } else if (type === "alarm") {
    // Rising and falling tone (wail: 415Hz <-> 620Hz every 4 seconds)
    osc.frequency.setValueAtTime(415, startTime);
    let rising = true;
    let freq = 415;
    const interval = setInterval(() => {
      if (rising) {
        freq += 15;
        if (freq >= 620) rising = false;
      } else {
        freq -= 15;
        if (freq <= 415) rising = true;
      }
      osc.frequency.setValueAtTime(freq, ctx.currentTime);
    }, 50);

    const timer = setTimeout(() => {
      stopSiren();
    }, 20000);

    currentSiren = { osc, timer, interval };
    osc.onended = () => stopSiren();
  } else if (type === "end") {
    // Intermittent tone (alternating sound on / pause every 4 seconds)
    osc.frequency.setValueAtTime(440, startTime);
    let soundOn = true;
    const interval = setInterval(() => {
      soundOn = !soundOn;
      gain.gain.setValueAtTime(soundOn ? 0.2 : 0.001, ctx.currentTime);
    }, 2000);

    const timer = setTimeout(() => {
      stopSiren();
    }, 18000);

    currentSiren = { osc, timer, interval };
    osc.onended = () => stopSiren();
  }
}

// Calculator Logic
function updateCalculations() {
  const c = state.calculator;
  const totalPersons = c.adults + c.children + c.babies;
  const totalWaterLitres = (totalPersons * 3 * c.days) + (c.pets * 1 * c.days);
  const totalWaterBottles = Math.ceil(totalWaterLitres / 1.5);
  const totalMeals = totalPersons * 3 * c.days;

  const waterBadge = document.getElementById("water-total-litres");
  const waterBottlesEl = document.getElementById("water-total-bottles");
  const foodBadge = document.getElementById("food-total-meals");
  const babySection = document.getElementById("baby-result-card");
  const petSection = document.getElementById("pet-result-card");

  if (waterBadge) waterBadge.textContent = `${totalWaterLitres} L`;
  if (waterBottlesEl) waterBottlesEl.textContent = `~ ${totalWaterBottles} ${I18N[state.currentLang].waterBottles}`;
  if (foodBadge) foodBadge.textContent = `${totalMeals} ${I18N[state.currentLang].completed}`;

  if (babySection) babySection.style.display = c.babies > 0 ? "block" : "none";
  if (petSection) petSection.style.display = c.pets > 0 ? "block" : "none";

  updateKitChecklistProgress();
}

function updateKitChecklistProgress() {
  const totalItems = document.querySelectorAll("#kit-items-list .check-item").length;
  let checkedCount = 0;
  for (let key in state.kitChecked) {
    if (state.kitChecked[key]) checkedCount++;
  }
  const pct = totalItems > 0 ? Math.round((checkedCount / totalItems) * 100) : 0;
  const fill = document.getElementById("kit-progress-fill");
  const text = document.getElementById("kit-progress-text");
  if (fill) fill.style.width = `${pct}%`;
  if (text) text.textContent = `${pct}% (${checkedCount}/${totalItems})`;
}

// Country Switcher
function setCountry(countryCode) {
  const conf = COUNTRIES_CONFIG[countryCode] || COUNTRIES_CONFIG["eu"];
  state.currentCountry = countryCode;
  localStorage.setItem("mg72_country", countryCode);

  const select = document.getElementById("country-select");
  if (select) select.value = countryCode;

  const titleEl = document.getElementById("country-emergency-title");
  const link112 = document.getElementById("link-112");
  const linkSec = document.getElementById("link-secondary");
  const linkCrisis = document.getElementById("link-crisis");

  if (titleEl) titleEl.textContent = conf.title;
  if (link112) {
    link112.textContent = conf.p112Text;
    link112.href = conf.p112Tel;
  }
  if (linkSec) {
    linkSec.textContent = conf.secText;
    linkSec.href = conf.secTel;
  }
  if (linkCrisis) {
    linkCrisis.textContent = conf.crisisText;
    linkCrisis.href = conf.crisisTel;
  }
}

// Language Switcher & UI Render
function setLanguage(lang) {
  state.currentLang = lang;
  localStorage.setItem("mg72_lang", lang);
  document.documentElement.lang = lang;
  
  const select = document.getElementById("lang-select");
  if (select) select.value = lang;

  applyTranslations();
  renderHouseholdMembers();
  renderMedicalList();
  renderPetsList();
  renderNeighborhoodLists();
  renderExpiryTracker();
  updateCalculations();
}

function applyTranslations() {
  const t = I18N[state.currentLang] || I18N["fr"] || I18N["en"];
  const fallback = I18N["fr"] || I18N["en"];
  document.querySelectorAll("[data-i18n]").forEach(el => {
    const key = el.getAttribute("data-i18n");
    const val = (t && t[key]) ? t[key] : (fallback ? fallback[key] : "");
    if (val) {
      if (el.tagName === "INPUT" || el.tagName === "TEXTAREA") {
        el.placeholder = val;
      } else {
        el.textContent = val;
      }
    }
  });
}

// Tab Switching
function switchTab(tabId) {
  document.querySelectorAll(".tab-pane").forEach(pane => pane.classList.remove("active"));
  document.querySelectorAll(".nav-btn").forEach(btn => btn.classList.remove("active"));
  
  const target = document.getElementById(tabId);
  if (target) target.classList.add("active");

  const btn = document.querySelector(`[data-tab="${tabId}"]`);
  if (btn) btn.classList.add("active");
  
  window.scrollTo({ top: 0, behavior: "smooth" });
}

// Blackout & Flashlight Toggles
function toggleBlackout() {
  state.blackout = !state.blackout;
  document.body.classList.toggle("blackout-mode", state.blackout);
  localStorage.setItem("mg72_blackout", state.blackout);
  const btn = document.getElementById("blackout-toggle-btn");
  if (btn) {
    btn.classList.toggle("active", state.blackout);
    btn.textContent = state.blackout 
      ? I18N[state.currentLang].exitBlackout 
      : I18N[state.currentLang].blackoutMode;
  }
}

function toggleFlashlight(active) {
  const fl = document.getElementById("screen-flashlight");
  if (fl) {
    fl.classList.toggle("active", active);
  }
}

// Night Vision (Tactical Red Shield)
function toggleNightVision() {
  state.nightVision = !state.nightVision;
  document.body.classList.toggle("night-vision-mode", state.nightVision);
  localStorage.setItem("mg72_nightvision", state.nightVision);
  const btn = document.getElementById("nightvision-toggle-btn");
  if (btn) {
    btn.classList.toggle("active", state.nightVision);
    const span = btn.querySelector("span");
    const t = I18N[state.currentLang] || I18N["fr"];
    if (span) span.textContent = state.nightVision ? t.exitNightVision : t.nightVisionMode;
  }
}

// SOS Morse Screen Flasher
let morseTimeout = null;
let morseStep = 0;
const MORSE_SOS_STEPS = [
  // S: . . .
  { on: true, duration: 200 },
  { on: false, duration: 200 },
  { on: true, duration: 200 },
  { on: false, duration: 200 },
  { on: true, duration: 200 },
  { on: false, duration: 600 },
  // O: - - -
  { on: true, duration: 600 },
  { on: false, duration: 200 },
  { on: true, duration: 600 },
  { on: false, duration: 200 },
  { on: true, duration: 600 },
  { on: false, duration: 600 },
  // S: . . .
  { on: true, duration: 200 },
  { on: false, duration: 200 },
  { on: true, duration: 200 },
  { on: false, duration: 200 },
  { on: true, duration: 200 },
  { on: false, duration: 1600 }
];

function toggleSosMorse(active) {
  const overlay = document.getElementById("sos-morse-overlay");
  if (!overlay) return;

  if (!active) {
    overlay.classList.remove("active", "flash-on");
    if (morseTimeout) {
      clearTimeout(morseTimeout);
      morseTimeout = null;
    }
    return;
  }

  overlay.classList.add("active");
  morseStep = 0;

  function runMorse() {
    const step = MORSE_SOS_STEPS[morseStep];
    if (step.on) {
      overlay.classList.add("flash-on");
    } else {
      overlay.classList.remove("flash-on");
    }
    morseStep = (morseStep + 1) % MORSE_SOS_STEPS.length;
    morseTimeout = setTimeout(runMorse, step.duration);
  }

  runMorse();
}

// Expiry Tracker Functions
function renderExpiryTracker() {
  const tbody = document.getElementById("expiry-items-tbody");
  if (!tbody) return;

  const t = I18N[state.currentLang] || I18N["fr"];
  tbody.innerHTML = "";

  const now = new Date();

  state.expiryItems.forEach((item, index) => {
    const itemDate = new Date(item.date);
    const diffDays = Math.ceil((itemDate - now) / (1000 * 60 * 60 * 24));

    let statusClass = "ok";
    let statusText = t.expiryStatusOk;

    if (diffDays < 0) {
      statusClass = "expired";
      statusText = t.expiryStatusExpired;
    } else if (diffDays <= 60) {
      statusClass = "soon";
      statusText = `${t.expiryStatusSoon} (${diffDays} j)`;
    } else {
      statusText = `${t.expiryStatusOk} (${diffDays} j)`;
    }

    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td><strong>${escapeHtml(item.name)}</strong></td>
      <td>${item.date}</td>
      <td><span class="badge-status ${statusClass}">${statusText}</span></td>
      <td style="text-align: right;">
        <button type="button" class="remove-dynamic-btn" onclick="removeExpiryItem(${index})" title="Supprimer" style="background: none; border: none; cursor: pointer; color: var(--accent-red); font-size: 1.1rem;">🗑️</button>
      </td>
    `;
    tbody.appendChild(tr);
  });
}

function removeExpiryItem(index) {
  state.expiryItems.splice(index, 1);
  localStorage.setItem("mg72_expiry_items", JSON.stringify(state.expiryItems));
  renderExpiryTracker();
}

function addNewExpiryPrompt() {
  const name = prompt("Nom de la réserve / produit (ex: Eau minérale 1.5L) :");
  if (!name || !name.trim()) return;

  const defaultDate = new Date(Date.now() + 180 * 24 * 3600 * 1000).toISOString().split("T")[0];
  const date = prompt("Date de péremption (AAAA-MM-JJ) :", defaultDate);
  if (!date || !date.trim()) return;

  state.expiryItems.push({ name: name.trim(), date: date.trim() });
  state.expiryItems.sort((a, b) => new Date(a.date) - new Date(b.date));
  localStorage.setItem("mg72_expiry_items", JSON.stringify(state.expiryItems));
  renderExpiryTracker();
}

function escapeHtml(str) {
  if (!str) return "";
  return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

// ICE Medical Card & Wallpaper Generator
function generateAndDownloadICEWallpaper() {
  const canvas = document.getElementById("ice-wallpaper-canvas");
  if (!canvas) return;
  const ctx = canvas.getContext("2d");

  const name = document.getElementById("ice-name")?.value.trim() 
    || state.plan?.head?.name 
    || "Résident Luxembourg";
  const blood = document.getElementById("ice-blood")?.value || "Inconnu";
  const matricule = document.getElementById("ice-matricule")?.value.trim() || "Non renseigné";
  const allergies = document.getElementById("ice-allergies")?.value.trim() || "Aucune allergie connue";
  const meds = document.getElementById("ice-meds")?.value.trim() || "Aucun traitement régulier";
  const contact1 = document.getElementById("ice-contact1")?.value.trim() 
    || (state.plan?.emergency?.outCityName ? `${state.plan.emergency.outCityName} (${state.plan.emergency.outCityTel})` : "112 CGDIS Secours");
  const contact2 = document.getElementById("ice-contact2")?.value.trim() 
    || (state.plan?.emergency?.localName ? `${state.plan.emergency.localName} (${state.plan.emergency.localTel})` : "113 Police Grand-Ducale");

  const W = 1080;
  const H = 2340;
  canvas.width = W;
  canvas.height = H;

  // 1. Dark Gradient Background
  const bgGrad = ctx.createLinearGradient(0, 0, 0, H);
  bgGrad.addColorStop(0, "#031429");
  bgGrad.addColorStop(0.4, "#010811");
  bgGrad.addColorStop(1, "#000000");
  ctx.fillStyle = bgGrad;
  ctx.fillRect(0, 0, W, H);

  // 2. Official Emergency Header Banner
  ctx.fillStyle = "#EA141D";
  ctx.fillRect(0, 0, W, 220);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "900 48px -apple-system, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText("🚨 URGENCE MÉDICALE / EMERGENCY ICE", W / 2, 105);

  ctx.font = "600 30px -apple-system, sans-serif";
  ctx.fillStyle = "rgba(255, 255, 255, 0.9)";
  ctx.fillText("SECOURS (112) • ACCÈS IMMÉDIAT SANS DÉVERROUILLER", W / 2, 165);

  // 3. Blood Type Big Badge & Identity
  ctx.fillStyle = "#1e293b";
  roundRect(ctx, 60, 270, W - 120, 280, 24, true, false);

  ctx.fillStyle = "#EA141D";
  roundRect(ctx, 90, 305, 210, 210, 20, true, false);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "900 92px -apple-system, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText(blood, 195, 440);

  ctx.textAlign = "left";
  ctx.fillStyle = "#94a3b8";
  ctx.font = "700 30px -apple-system, sans-serif";
  ctx.fillText("GROUPE SANGUIN VITAL", 340, 360);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "900 52px -apple-system, sans-serif";
  ctx.fillText(name, 340, 430);

  ctx.fillStyle = "#00A3E0";
  ctx.font = "600 32px -apple-system, sans-serif";
  ctx.fillText(`Matricule CNS : ${matricule}`, 340, 485);

  // 4. Card: Allergies & Traitements
  ctx.fillStyle = "#111b27";
  roundRect(ctx, 60, 590, W - 120, 460, 24, true, false);

  ctx.fillStyle = "#f59e0b";
  ctx.font = "800 34px -apple-system, sans-serif";
  ctx.fillText("⚠️ ALLERGIES CRITIQUES", 100, 660);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "600 36px -apple-system, sans-serif";
  wrapText(ctx, allergies, 100, 725, W - 200, 48);

  ctx.fillStyle = "#00A3E0";
  ctx.font = "800 34px -apple-system, sans-serif";
  ctx.fillText("💊 TRAITEMENTS VITAUX QUOTIDIENS", 100, 860);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "600 36px -apple-system, sans-serif";
  wrapText(ctx, meds, 100, 925, W - 200, 48);

  // 5. Card: Emergency Contacts
  ctx.fillStyle = "#111b27";
  roundRect(ctx, 60, 1090, W - 120, 440, 24, true, false);

  ctx.fillStyle = "#EA141D";
  ctx.font = "800 34px -apple-system, sans-serif";
  ctx.fillText("📞 CONTACTS D'URGENCE (ICE)", 100, 1160);

  ctx.fillStyle = "#94a3b8";
  ctx.font = "600 28px -apple-system, sans-serif";
  ctx.fillText("CONTACT PRIORITAIRE 1 :", 100, 1225);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "800 40px -apple-system, sans-serif";
  ctx.fillText(contact1, 100, 1285);

  ctx.fillStyle = "#94a3b8";
  ctx.font = "600 28px -apple-system, sans-serif";
  ctx.fillText("CONTACT SECONDAIRE 2 :", 100, 1375);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "800 40px -apple-system, sans-serif";
  ctx.fillText(contact2, 100, 1435);

  // 6. National Resilience Notice Card
  ctx.fillStyle = "rgba(0, 43, 73, 0.7)";
  roundRect(ctx, 60, 1570, W - 120, 260, 24, true, false);

  ctx.fillStyle = "#FFFFFF";
  ctx.font = "800 34px -apple-system, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText("GRAND-DUCHÉ DE LUXEMBOURG", W / 2, 1640);

  ctx.font = "500 28px -apple-system, sans-serif";
  ctx.fillStyle = "#94a3b8";
  ctx.fillText("Lëtz prepare ! — Stratégie Nationale de Résilience", W / 2, 1695);
  ctx.fillText("Urgences Nationales : 112 (Secours) • 113 (Police) • 8002 7788", W / 2, 1750);

  // 7. Footer Notice
  ctx.fillStyle = "rgba(255, 255, 255, 0.45)";
  ctx.font = "500 26px -apple-system, sans-serif";
  ctx.fillText("Fond d'écran d'urgence généré par Mon Guide 72h • inforeis.lu", W / 2, 2240);

  // Trigger Download
  const link = document.createElement("a");
  link.download = `MonGuide72h_ICE_${name.replace(/\s+/g, "_")}.png`;
  link.href = canvas.toDataURL("image/png");
  link.click();
}

function roundRect(ctx, x, y, width, height, radius, fill, stroke) {
  ctx.beginPath();
  ctx.moveTo(x + radius, y);
  ctx.lineTo(x + width - radius, y);
  ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
  ctx.lineTo(x + width, y + height - radius);
  ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
  ctx.lineTo(x + radius, y + height);
  ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
  ctx.lineTo(x, y + radius);
  ctx.quadraticCurveTo(x, y, x + radius, y);
  ctx.closePath();
  if (fill) ctx.fill();
  if (stroke) ctx.stroke();
}

function wrapText(ctx, text, x, y, maxWidth, lineHeight) {
  const words = (text || "").split(" ");
  let line = "";
  for (let n = 0; n < words.length; n++) {
    const testLine = line + words[n] + " ";
    const metrics = ctx.measureText(testLine);
    if (metrics.width > maxWidth && n > 0) {
      ctx.fillText(line, x, y);
      line = words[n] + " ";
      y += lineHeight;
    } else {
      line = testLine;
    }
  }
  ctx.fillText(line, x, y);
}

// Plan Personnel Forms (Members, Meds, Pets, Neighborhood)
function savePlanData() {
  // Collect Header
  state.plan.head = {
    name: document.getElementById("plan-owner-name")?.value || "",
    address: document.getElementById("plan-owner-address")?.value || "",
    city: document.getElementById("plan-owner-city")?.value || "",
    dateCompleted: document.getElementById("plan-date-completed")?.value || "",
    dateUpdated: document.getElementById("plan-date-updated")?.value || ""
  };

  // Collect House Details
  state.plan.house = {
    water: document.getElementById("house-water")?.value || "",
    gas: document.getElementById("house-gas")?.value || "",
    elec: document.getElementById("house-elec")?.value || "",
    extinguisher: document.getElementById("house-extinguisher")?.value || "",
    garageManual: document.getElementById("house-garage")?.value || "",
    escapeRoute: document.getElementById("house-escape")?.value || "",
    notes: document.getElementById("house-notes")?.value || ""
  };

  // Collect Emergency & Meet Points
  state.plan.emergency = {
    meetPoint1: document.getElementById("meet-point-1")?.value || "",
    meetPoint2: document.getElementById("meet-point-2")?.value || "",
    schoolPickup: document.getElementById("school-pickup")?.value || "",
    outOfArea: document.getElementById("out-of-area-contact")?.value || "",
    shelterWith: document.getElementById("shelter-with-contact")?.value || "",
    workAlternative: document.getElementById("work-commute-alt")?.value || ""
  };

  // Collect Providers
  state.plan.providers = {
    telecom: document.getElementById("prov-telecom")?.value || "",
    elec: document.getElementById("prov-elec")?.value || "",
    gas: document.getElementById("prov-gas")?.value || "",
    water: document.getElementById("prov-water")?.value || "",
    insurance: document.getElementById("prov-insurance")?.value || "",
    doctor: document.getElementById("prov-doctor")?.value || "",
    school: document.getElementById("prov-school")?.value || "",
    bank: document.getElementById("prov-bank")?.value || ""
  };

  localStorage.setItem("mg72_plan_data", JSON.stringify(state.plan));
}

function loadPlanData() {
  if (!state.plan) return;
  const p = state.plan;

  if (p.head) {
    if (document.getElementById("plan-owner-name")) document.getElementById("plan-owner-name").value = p.head.name || "";
    if (document.getElementById("plan-owner-address")) document.getElementById("plan-owner-address").value = p.head.address || "";
    if (document.getElementById("plan-owner-city")) document.getElementById("plan-owner-city").value = p.head.city || "";
    if (document.getElementById("plan-date-completed")) document.getElementById("plan-date-completed").value = p.head.dateCompleted || "";
    if (document.getElementById("plan-date-updated")) document.getElementById("plan-date-updated").value = p.head.dateUpdated || "";
  }

  if (p.house) {
    if (document.getElementById("house-water")) document.getElementById("house-water").value = p.house.water || "";
    if (document.getElementById("house-gas")) document.getElementById("house-gas").value = p.house.gas || "";
    if (document.getElementById("house-elec")) document.getElementById("house-elec").value = p.house.elec || "";
    if (document.getElementById("house-extinguisher")) document.getElementById("house-extinguisher").value = p.house.extinguisher || "";
    if (document.getElementById("house-garage")) document.getElementById("house-garage").value = p.house.garageManual || "";
    if (document.getElementById("house-escape")) document.getElementById("house-escape").value = p.house.escapeRoute || "";
    if (document.getElementById("house-notes")) document.getElementById("house-notes").value = p.house.notes || "";
  }

  if (p.emergency) {
    if (document.getElementById("meet-point-1")) document.getElementById("meet-point-1").value = p.emergency.meetPoint1 || "";
    if (document.getElementById("meet-point-2")) document.getElementById("meet-point-2").value = p.emergency.meetPoint2 || "";
    if (document.getElementById("school-pickup")) document.getElementById("school-pickup").value = p.emergency.schoolPickup || "";
    if (document.getElementById("out-of-area-contact")) document.getElementById("out-of-area-contact").value = p.emergency.outOfArea || "";
    if (document.getElementById("shelter-with-contact")) document.getElementById("shelter-with-contact").value = p.emergency.shelterWith || "";
    if (document.getElementById("work-commute-alt")) document.getElementById("work-commute-alt").value = p.emergency.workAlternative || "";
  }

  if (p.providers) {
    if (document.getElementById("prov-telecom")) document.getElementById("prov-telecom").value = p.providers.telecom || "";
    if (document.getElementById("prov-elec")) document.getElementById("prov-elec").value = p.providers.elec || "";
    if (document.getElementById("prov-gas")) document.getElementById("prov-gas").value = p.providers.gas || "";
    if (document.getElementById("prov-water")) document.getElementById("prov-water").value = p.providers.water || "";
    if (document.getElementById("prov-insurance")) document.getElementById("prov-insurance").value = p.providers.insurance || "";
    if (document.getElementById("prov-doctor")) document.getElementById("prov-doctor").value = p.providers.doctor || "";
    if (document.getElementById("prov-school")) document.getElementById("prov-school").value = p.providers.school || "";
    if (document.getElementById("prov-bank")) document.getElementById("prov-bank").value = p.providers.bank || "";
  }
}

// Dynamic Household Members
function addHouseholdMember(member = { name: "", tel: "", blood: "", matricule: "", languages: "", handicap: "" }) {
  state.plan.members.push(member);
  savePlanData();
  renderHouseholdMembers();
}

function removeHouseholdMember(index) {
  state.plan.members.splice(index, 1);
  savePlanData();
  renderHouseholdMembers();
}

function renderHouseholdMembers() {
  const container = document.getElementById("members-container");
  if (!container) return;
  const t = I18N[state.currentLang];
  container.innerHTML = "";

  state.plan.members.forEach((m, idx) => {
    const card = document.createElement("div");
    card.className = "dynamic-card";
    card.innerHTML = `
      <button class="remove-dynamic-btn" type="button" onclick="removeHouseholdMember(${idx})" title="Supprimer">✕</button>
      <div class="form-grid">
        <div class="form-group">
          <label>${t.fullName}</label>
          <input type="text" value="${m.name || ""}" onchange="state.plan.members[${idx}].name = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>Téléphone</label>
          <input type="tel" value="${m.tel || ""}" onchange="state.plan.members[${idx}].tel = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>${t.matricule}</label>
          <input type="text" placeholder="19800101-12345" value="${m.matricule || ""}" onchange="state.plan.members[${idx}].matricule = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>${t.bloodType}</label>
          <select onchange="state.plan.members[${idx}].blood = this.value; savePlanData();">
            <option value="">--</option>
            ${["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"].map(bg => `<option value="${bg}" ${m.blood === bg ? "selected" : ""}>${bg}</option>`).join("")}
          </select>
        </div>
        <div class="form-group">
          <label>${t.languages}</label>
          <input type="text" placeholder="FR, LU, DE, EN, PT..." value="${m.languages || ""}" onchange="state.plan.members[${idx}].languages = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>${t.handicap}</label>
          <input type="text" value="${m.handicap || ""}" onchange="state.plan.members[${idx}].handicap = this.value; savePlanData();">
        </div>
      </div>
    `;
    container.appendChild(card);
  });
}

// Dynamic Medical List
function addMedicalEntry(entry = { name: "", allergy: "", meds: "", dose: "" }) {
  state.plan.meds.push(entry);
  savePlanData();
  renderMedicalList();
}

function removeMedicalEntry(index) {
  state.plan.meds.splice(index, 1);
  savePlanData();
  renderMedicalList();
}

function renderMedicalList() {
  const container = document.getElementById("meds-container");
  if (!container) return;
  const t = I18N[state.currentLang];
  container.innerHTML = "";

  state.plan.meds.forEach((med, idx) => {
    const card = document.createElement("div");
    card.className = "dynamic-card";
    card.innerHTML = `
      <button class="remove-dynamic-btn" type="button" onclick="removeMedicalEntry(${idx})">✕</button>
      <div class="form-grid">
        <div class="form-group">
          <label>${t.fullName}</label>
          <input type="text" value="${med.name || ""}" onchange="state.plan.meds[${idx}].name = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>${t.allergies}</label>
          <input type="text" value="${med.allergy || ""}" onchange="state.plan.meds[${idx}].allergy = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>${t.dailyMeds}</label>
          <input type="text" value="${med.meds || ""}" onchange="state.plan.meds[${idx}].meds = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>Posologie / Fréquence</label>
          <input type="text" value="${med.dose || ""}" onchange="state.plan.meds[${idx}].dose = this.value; savePlanData();">
        </div>
      </div>
    `;
    container.appendChild(card);
  });
}

// Dynamic Pets List
function addPetEntry(pet = { species: "", name: "", info: "" }) {
  state.plan.pets.push(pet);
  savePlanData();
  renderPetsList();
}

function removePetEntry(index) {
  state.plan.pets.splice(index, 1);
  savePlanData();
  renderPetsList();
}

function renderPetsList() {
  const container = document.getElementById("pets-container");
  if (!container) return;
  container.innerHTML = "";

  state.plan.pets.forEach((pet, idx) => {
    const card = document.createElement("div");
    card.className = "dynamic-card";
    card.innerHTML = `
      <button class="remove-dynamic-btn" type="button" onclick="removePetEntry(${idx})">✕</button>
      <div class="form-grid">
        <div class="form-group">
          <label>Espèce / Type (Chien, Chat...)</label>
          <input type="text" value="${pet.species || ""}" onchange="state.plan.pets[${idx}].species = this.value; savePlanData();">
        </div>
        <div class="form-group">
          <label>Nom de l'animal</label>
          <input type="text" value="${pet.name || ""}" onchange="state.plan.pets[${idx}].name = this.value; savePlanData();">
        </div>
        <div class="form-group" style="grid-column: 1 / -1;">
          <label>Informations médicales / Comportement / Traitements</label>
          <input type="text" value="${pet.info || ""}" onchange="state.plan.pets[${idx}].info = this.value; savePlanData();">
        </div>
      </div>
    `;
    container.appendChild(card);
  });
}

// Dynamic Neighborhood Helpers / Need Help
function addNeighborEntry(type) {
  if (type === "helper") {
    state.plan.neighborhood.helpers.push({ name: "", help: "", tel: "", address: "" });
  } else {
    state.plan.neighborhood.needHelp.push({ name: "", need: "", tel: "", address: "" });
  }
  savePlanData();
  renderNeighborhoodLists();
}

function removeNeighborEntry(type, index) {
  if (type === "helper") {
    state.plan.neighborhood.helpers.splice(index, 1);
  } else {
    state.plan.neighborhood.needHelp.splice(index, 1);
  }
  savePlanData();
  renderNeighborhoodLists();
}

function renderNeighborhoodLists() {
  const helperContainer = document.getElementById("helpers-container");
  const needHelpContainer = document.getElementById("needhelp-container");

  if (helperContainer) {
    helperContainer.innerHTML = "";
    state.plan.neighborhood.helpers.forEach((h, idx) => {
      const card = document.createElement("div");
      card.className = "dynamic-card";
      card.innerHTML = `
        <button class="remove-dynamic-btn" type="button" onclick="removeNeighborEntry('helper', ${idx})">✕</button>
        <div class="form-grid">
          <div class="form-group">
            <label>Nom & Prénom</label>
            <input type="text" value="${h.name || ""}" onchange="state.plan.neighborhood.helpers[${idx}].name = this.value; savePlanData();">
          </div>
          <div class="form-group">
            <label>Aide apportée / Compétences (bricolage, premier secours...)</label>
            <input type="text" value="${h.help || ""}" onchange="state.plan.neighborhood.helpers[${idx}].help = this.value; savePlanData();">
          </div>
          <div class="form-group">
            <label>Téléphone</label>
            <input type="tel" value="${h.tel || ""}" onchange="state.plan.neighborhood.helpers[${idx}].tel = this.value; savePlanData();">
          </div>
          <div class="form-group">
            <label>Adresse / N° maison</label>
            <input type="text" value="${h.address || ""}" onchange="state.plan.neighborhood.helpers[${idx}].address = this.value; savePlanData();">
          </div>
        </div>
      `;
      helperContainer.appendChild(card);
    });
  }

  if (needHelpContainer) {
    needHelpContainer.innerHTML = "";
    state.plan.neighborhood.needHelp.forEach((nh, idx) => {
      const card = document.createElement("div");
      card.className = "dynamic-card";
      card.innerHTML = `
        <button class="remove-dynamic-btn" type="button" onclick="removeNeighborEntry('needHelp', ${idx})">✕</button>
        <div class="form-grid">
          <div class="form-group">
            <label>Nom & Prénom</label>
            <input type="text" value="${nh.name || ""}" onchange="state.plan.neighborhood.needHelp[${idx}].name = this.value; savePlanData();">
          </div>
          <div class="form-group">
            <label>Aide nécessaire (mobilité, traitement, personne seule...)</label>
            <input type="text" value="${nh.need || ""}" onchange="state.plan.neighborhood.needHelp[${idx}].need = this.value; savePlanData();">
          </div>
          <div class="form-group">
            <label>Téléphone</label>
            <input type="tel" value="${nh.tel || ""}" onchange="state.plan.neighborhood.needHelp[${idx}].tel = this.value; savePlanData();">
          </div>
          <div class="form-group">
            <label>Adresse / N° maison</label>
            <input type="text" value="${nh.address || ""}" onchange="state.plan.neighborhood.needHelp[${idx}].address = this.value; savePlanData();">
          </div>
        </div>
      `;
      needHelpContainer.appendChild(card);
    });
  }
}

// Backup & Restore
function exportDataJSON() {
  savePlanData();
  const backup = {
    exportDate: new Date().toISOString(),
    calculator: state.calculator,
    kitChecked: state.kitChecked,
    bagChecked: state.bagChecked,
    plan: state.plan
  };

  const blob = new Blob([JSON.stringify(backup, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const a = document.createElement("a");
  a.href = url;
  a.download = `MonGuide72h_Plan_Urgence_${new Date().toISOString().slice(0, 10)}.json`;
  a.click();
  URL.revokeObjectURL(url);
}

function importDataJSON(event) {
  const file = event.target.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = e => {
    try {
      const imported = JSON.parse(e.target.result);
      if (imported.plan) state.plan = imported.plan;
      if (imported.calculator) state.calculator = imported.calculator;
      if (imported.kitChecked) state.kitChecked = imported.kitChecked;
      if (imported.bagChecked) state.bagChecked = imported.bagChecked;

      localStorage.setItem("mg72_plan_data", JSON.stringify(state.plan));
      localStorage.setItem("mg72_kit_checked", JSON.stringify(state.kitChecked));
      localStorage.setItem("mg72_bag_checked", JSON.stringify(state.bagChecked));

      loadPlanData();
      renderHouseholdMembers();
      renderMedicalList();
      renderPetsList();
      renderNeighborhoodLists();
      updateCalculations();
      alert("✅ Plan et données restaurés avec succès !");
    } catch (err) {
      alert("❌ Fichier JSON invalide.");
    }
  };
  reader.readAsText(file);
}

function resetAllData() {
  if (confirm("Êtes-vous sûr de vouloir réinitialiser toutes les données ?")) {
    localStorage.removeItem("mg72_plan_data");
    localStorage.removeItem("mg72_kit_checked");
    localStorage.removeItem("mg72_bag_checked");
    location.reload();
  }
}

// Initialize on DOM Ready
document.addEventListener("DOMContentLoaded", () => {
  // Apply saved blackout mode
  if (state.blackout) {
    document.body.classList.add("blackout-mode");
    const btn = document.getElementById("blackout-toggle-btn");
    if (btn) btn.classList.add("active");
  }

  // Set default initial members if empty
  if (state.plan.members.length === 0) {
    state.plan.members.push({ name: "", tel: "", blood: "", matricule: "", languages: "", handicap: "" });
  }

  // Navigation handlers
  document.querySelectorAll(".nav-btn").forEach(btn => {
    btn.addEventListener("click", () => {
      const tabId = btn.getAttribute("data-tab");
      switchTab(tabId);
    });
  });

  // Checklist Checkbox Handlers
  document.querySelectorAll("#kit-items-list .check-item input").forEach(input => {
    const id = input.id;
    if (state.kitChecked[id]) {
      input.checked = true;
      input.closest(".check-item").classList.add("completed");
    }
    input.addEventListener("change", () => {
      state.kitChecked[id] = input.checked;
      input.closest(".check-item").classList.toggle("completed", input.checked);
      localStorage.setItem("mg72_kit_checked", JSON.stringify(state.kitChecked));
      updateKitChecklistProgress();
    });
  });

  document.querySelectorAll("#bag-items-list .check-item input").forEach(input => {
    const id = input.id;
    if (state.bagChecked[id]) {
      input.checked = true;
      input.closest(".check-item").classList.add("completed");
    }
    input.addEventListener("change", () => {
      state.bagChecked[id] = input.checked;
      input.closest(".check-item").classList.toggle("completed", input.checked);
      localStorage.setItem("mg72_bag_checked", JSON.stringify(state.bagChecked));
    });
  });

  // Counter handlers
  document.querySelectorAll(".counter-btn").forEach(btn => {
    btn.addEventListener("click", () => {
      const targetKey = btn.getAttribute("data-target");
      const delta = parseInt(btn.getAttribute("data-delta"), 10);
      const min = parseInt(btn.getAttribute("data-min") || "0", 10);
      const max = parseInt(btn.getAttribute("data-max") || "20", 10);

      let current = state.calculator[targetKey] || 0;
      current = Math.max(min, Math.min(max, current + delta));
      state.calculator[targetKey] = current;

      const display = document.getElementById(`count-${targetKey}`);
      if (display) display.textContent = current;

      updateCalculations();
    });
  });

  // Language selector change
  const langSelect = document.getElementById("lang-select");
  if (langSelect) {
    langSelect.addEventListener("change", e => {
      setLanguage(e.target.value);
    });
  }

  // Country selector change
  const countrySelect = document.getElementById("country-select");
  if (countrySelect) {
    countrySelect.addEventListener("change", e => {
      setCountry(e.target.value);
    });
  }

  // Load plan and initialize view
  loadPlanData();
  setLanguage(state.currentLang);
  setCountry(state.currentCountry);
  updateCalculations();
  renderExpiryTracker();

  if (state.nightVision) {
    document.body.classList.add("night-vision-mode");
    const btn = document.getElementById("nightvision-toggle-btn");
    if (btn) btn.classList.add("active");
  }

  if (state.blackout) {
    document.body.classList.add("blackout-mode");
    const btn = document.getElementById("blackout-toggle-btn");
    if (btn) btn.classList.add("active");
  }

  // Pre-fill ICE fields if plan has data
  if (state.plan?.head?.name) {
    const el = document.getElementById("ice-name");
    if (el && !el.value) el.value = state.plan.head.name;
  }

  // Register service worker for offline functionality
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("./sw.js").catch(err => {
      console.log("Service Worker registration note: ", err);
    });
  }
});

// ==========================================
// P2P OFFLINE EMERGENCY PLAN SHARING (QR CODE)
// ==========================================

let qrCameraStream = null;
let qrScanInterval = null;

function encodePlanToQRPayload(plan) {
  try {
    const jsonStr = JSON.stringify(plan || state.plan || {});
    const b64 = btoa(unescape(encodeURIComponent(jsonStr)));
    return "MG72H:" + b64;
  } catch (err) {
    console.error("Error encoding plan:", err);
    return "";
  }
}

function decodeQRPayloadToPlan(payload) {
  try {
    const trimmed = (payload || "").trim();
    if (!trimmed) return null;
    let b64 = trimmed;
    if (trimmed.startsWith("MG72H:")) {
      b64 = trimmed.substring(6);
    } else if (trimmed.startsWith("MG72HZ:")) {
      b64 = trimmed.substring(7);
    }
    const jsonStr = decodeURIComponent(escape(atob(b64)));
    return JSON.parse(jsonStr);
  } catch (err) {
    console.error("Error decoding plan payload:", err);
    return null;
  }
}

function openQRShareModal() {
  savePlanData();
  const modal = document.getElementById("modal-qr-share");
  const box = document.getElementById("qr-code-box");
  if (!modal || !box) return;

  const payload = encodePlanToQRPayload(state.plan);
  if (!payload) {
    alert("Impossible d'encoder le plan d'urgence.");
    return;
  }

  try {
    const qr = qrcode(0, "M");
    qr.addData(payload);
    qr.make();
    box.innerHTML = qr.createSvgTag(5, 8);
  } catch (err) {
    console.error("QR Generation error:", err);
    try {
      const minPlan = {
        head: state.plan.head,
        emergency: state.plan.emergency,
        house: state.plan.house,
        members: state.plan.members
      };
      const minPayload = encodePlanToQRPayload(minPlan);
      const qrMin = qrcode(0, "L");
      qrMin.addData(minPayload);
      qrMin.make();
      box.innerHTML = qrMin.createSvgTag(5, 8);
    } catch (e2) {
      box.innerHTML = "<p style='color:#000;'>Plan trop volumineux pour un QR code unique. Utilisez le bouton Sauvegarder JSON.</p>";
    }
  }

  modal.style.display = "flex";
}

function closeQRShareModal() {
  const modal = document.getElementById("modal-qr-share");
  if (modal) modal.style.display = "none";
}

function copyQRPayload() {
  const payload = encodePlanToQRPayload(state.plan);
  if (!payload) return;
  navigator.clipboard.writeText(payload).then(() => {
    alert("Clé d'urgence copiée dans le presse-papier !");
  }).catch(() => {
    prompt("Copiez votre clé d'urgence :", payload);
  });
}

function sharePlanViaWebShare() {
  const payload = encodePlanToQRPayload(state.plan);
  if (navigator.share) {
    navigator.share({
      title: "Plan d'Urgence Familial 72h",
      text: "Voici mon plan d'urgence familial MonGuide72h (clé de synchronisation hors-ligne) :\n\n" + payload,
    }).catch(err => console.log("Share canceled", err));
  } else {
    copyQRPayload();
  }
}

function downloadQRCodePNG() {
  const box = document.getElementById("qr-code-box");
  const svg = box?.querySelector("svg");
  if (!svg) return;

  const svgData = new XMLSerializer().serializeToString(svg);
  const canvas = document.createElement("canvas");
  const ctx = canvas.getContext("2d");
  const img = new Image();
  img.onload = () => {
    canvas.width = img.width || 400;
    canvas.height = img.height || 400;
    ctx.fillStyle = "#ffffff";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(img, 0, 0);
    const a = document.createElement("a");
    a.download = "MonGuide72h-Plan-QR.png";
    a.href = canvas.toDataURL("image/png");
    a.click();
  };
  img.src = "data:image/svg+xml;base64," + btoa(unescape(encodeURIComponent(svgData)));
}

function openQRScanModal() {
  const modal = document.getElementById("modal-qr-scan");
  if (modal) modal.style.display = "flex";
  const feedback = document.getElementById("qr-scan-feedback");
  if (feedback) feedback.textContent = "";
}

function closeQRScanModal() {
  stopCameraScanner();
  const modal = document.getElementById("modal-qr-scan");
  if (modal) modal.style.display = "none";
}

function startCameraScanner() {
  const video = document.getElementById("qr-scan-video");
  const container = document.getElementById("qr-camera-container");
  const btn = document.getElementById("btn-toggle-camera");
  const feedback = document.getElementById("qr-scan-feedback");

  if (qrCameraStream) {
    stopCameraScanner();
    return;
  }

  if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
    alert("Accès caméra non supporté par ce navigateur.");
    return;
  }

  navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } })
    .then(stream => {
      qrCameraStream = stream;
      if (video) {
        video.srcObject = stream;
        video.play();
      }
      if (container) container.style.display = "block";
      if (btn) btn.textContent = "🛑 Arrêter la Caméra";

      if ("BarcodeDetector" in window) {
        const barcodeDetector = new BarcodeDetector({ formats: ["qr_code"] });
        qrScanInterval = setInterval(async () => {
          if (!video || video.readyState < 2) return;
          try {
            const barcodes = await barcodeDetector.detect(video);
            if (barcodes && barcodes.length > 0) {
              const rawValue = barcodes[0].rawValue;
              if (rawValue && (rawValue.startsWith("MG72H:") || rawValue.startsWith("{"))) {
                stopCameraScanner();
                applyQRPayloadString(rawValue);
              }
            }
          } catch (e) {
            // Frame error
          }
        }, 300);
      } else {
        if (feedback) {
          feedback.style.color = "var(--accent-color)";
          feedback.textContent = "Caméra active. Si l'auto-détection n'est pas disponible sur votre navigateur, importez une photo du QR code ci-dessous.";
        }
      }
    })
    .catch(err => {
      alert("Impossible d'accéder à la caméra : " + (err.message || err));
    });
}

function stopCameraScanner() {
  if (qrScanInterval) {
    clearInterval(qrScanInterval);
    qrScanInterval = null;
  }
  if (qrCameraStream) {
    qrCameraStream.getTracks().forEach(track => track.stop());
    qrCameraStream = null;
  }
  const container = document.getElementById("qr-camera-container");
  if (container) container.style.display = "none";
  const btn = document.getElementById("btn-toggle-camera");
  if (btn) btn.textContent = "📷 Utiliser la Caméra";
}

function scanQRFromImageFile(event) {
  const file = event.target.files?.[0];
  if (!file) return;

  const feedback = document.getElementById("qr-scan-feedback");
  if ("BarcodeDetector" in window) {
    const barcodeDetector = new BarcodeDetector({ formats: ["qr_code"] });
    const img = new Image();
    img.onload = async () => {
      try {
        const barcodes = await barcodeDetector.detect(img);
        if (barcodes && barcodes.length > 0) {
          applyQRPayloadString(barcodes[0].rawValue);
        } else {
          if (feedback) {
            feedback.style.color = "#ff4444";
            feedback.textContent = "Aucun QR code détecté dans cette image.";
          }
        }
      } catch (err) {
        if (feedback) {
          feedback.style.color = "#ff4444";
          feedback.textContent = "Erreur de lecture de l'image.";
        }
      }
    };
    img.src = URL.createObjectURL(file);
  } else {
    alert("Veuillez coller le code d'urgence dans le champ texte ci-dessous.");
  }
}

function applyManualQRPayload() {
  const input = document.getElementById("qr-manual-payload");
  if (!input) return;
  applyQRPayloadString(input.value);
}

function applyQRPayloadString(payloadStr) {
  const feedback = document.getElementById("qr-scan-feedback");
  const plan = decodeQRPayloadToPlan(payloadStr);

  if (!plan) {
    if (feedback) {
      feedback.style.color = "#ff4444";
      feedback.textContent = "Code d'urgence invalide ou format non reconnu.";
    }
    return;
  }

  state.plan = Object.assign(state.plan || {}, plan);
  localStorage.setItem("mg72_plan_data", JSON.stringify(state.plan));

  loadPlanData();
  renderMembersList();
  renderMedsList();
  renderPetsList();
  renderNeighborhoodLists();

  if (feedback) {
    feedback.style.color = "#00D66F";
    feedback.textContent = "✅ Plan familial synchronisé avec succès !";
  }

  setTimeout(() => {
    closeQRScanModal();
  }, 1200);
}

// ==========================================
// VOICE CRISIS GUIDE (TEXT-TO-SPEECH)
// ==========================================

let currentVoiceTitle = "";
let isSpeakingVoice = false;

function readRiskCardAloud(btn) {
  const card = btn.closest(".risk-card");
  if (!card) return;
  const title = card.querySelector(".risk-card-header strong")?.innerText || "";
  const bodyText = card.querySelector(".risk-card-body p")?.innerText || "";
  if (!bodyText) return;

  if (isSpeakingVoice && currentVoiceTitle === title) {
    stopVoiceGuide();
    return;
  }

  document.querySelectorAll(".btn-voice-mini").forEach(b => b.classList.remove("active"));
  btn.classList.add("active");

  speakCrisisGuide(title, `${title}. ${bodyText}`);
}

function speakCrisisGuide(title, fullText) {
  if (!("speechSynthesis" in window)) {
    alert("Synthèse vocale non supportée par votre navigateur.");
    return;
  }

  window.speechSynthesis.cancel();

  const utterance = new SpeechSynthesisUtterance(fullText);
  const langMap = {
    fr: "fr-FR",
    en: "en-US",
    de: "de-DE",
    lu: "lb-LU",
    pt: "pt-PT",
    es: "es-ES",
    it: "it-IT"
  };
  utterance.lang = langMap[state.currentLang] || "fr-FR";
  utterance.rate = 0.88; // Calm, clear, deliberate rate for emergency situations
  utterance.pitch = 1.0;

  const voices = window.speechSynthesis.getVoices();
  const matchedVoice = voices.find(v => v.lang.startsWith(utterance.lang.substring(0, 2)));
  if (matchedVoice) utterance.voice = matchedVoice;

  isSpeakingVoice = true;
  currentVoiceTitle = title;

  const bar = document.getElementById("voice-guide-bar");
  const titleEl = document.getElementById("voice-current-title");
  const pauseBtn = document.getElementById("btn-voice-pause");
  if (bar) bar.classList.add("active");
  if (titleEl) titleEl.textContent = title;
  if (pauseBtn) pauseBtn.textContent = "⏸️";

  utterance.onend = () => {
    stopVoiceGuide();
  };

  utterance.onerror = () => {
    stopVoiceGuide();
  };

  window.speechSynthesis.speak(utterance);
}

function toggleVoiceGuidePause() {
  if (!("speechSynthesis" in window)) return;
  const pauseBtn = document.getElementById("btn-voice-pause");
  if (window.speechSynthesis.paused) {
    window.speechSynthesis.resume();
    if (pauseBtn) pauseBtn.textContent = "⏸️";
  } else {
    window.speechSynthesis.pause();
    if (pauseBtn) pauseBtn.textContent = "▶️";
  }
}

function stopVoiceGuide() {
  if ("speechSynthesis" in window) {
    window.speechSynthesis.cancel();
  }
  isSpeakingVoice = false;
  currentVoiceTitle = "";
  const bar = document.getElementById("voice-guide-bar");
  if (bar) bar.classList.remove("active");
  document.querySelectorAll(".btn-voice-mini").forEach(btn => btn.classList.remove("active"));
}
