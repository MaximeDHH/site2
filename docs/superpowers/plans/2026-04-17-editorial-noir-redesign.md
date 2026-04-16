# Editorial Noir Redesign — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refonte complète du site Truc Anh Nails vers une esthétique Editorial Noir — near-black chaud, Cormorant Garamond monumental, Cabinet Grotesk, accent or unique, navigation pill flottante, animations fadeUp subtiles.

**Architecture:** Réécriture du SCSS en une seule passe depuis les tokens, mise à jour HTML view par view, ajout d'un Stimulus controller pour le scroll reveal. Pas de nouvelle gem, pas de React. Tout en Rails 7.1 + SCSS pur + Stimulus.

**Tech Stack:** Rails 7.1, SCSS (Sprockets), Stimulus, Hotwire, Google Fonts CDN

**Spec:** `docs/superpowers/specs/2026-04-17-editorial-noir-redesign.md`

---

## Files

| Statut | Fichier | Rôle |
|--------|---------|------|
| Modify | `app/views/layouts/application.html.erb` | Fonts Cabinet Grotesk, suppression topbar, inline JS scroll |
| Modify | `app/views/shared/_header.html.erb` | Navigation pill flottante |
| Rewrite | `app/assets/stylesheets/application.scss` | Tokens, tous les composants |
| Modify | `app/views/pages/home.html.erb` | Hero noir, services, about |
| Modify | `app/views/shared/_footer.html.erb` | Footer noir restructuré |
| Modify | `app/views/pages/contact.html.erb` | Contact redesign + filtre carte |
| Modify | `app/views/shared/_hero.html.erb` | Hero partial contact page |
| Create | `app/javascript/controllers/scroll_reveal_controller.js` | IntersectionObserver fadeUp |

---

## Task 1 : Layout — fonts + suppression topbar + scroll JS

**Files:**
- Modify: `app/views/layouts/application.html.erb`

**Note:** Pas de tests Rails pour le HTML pur. Vérification visuelle sur `bin/rails server`.

- [ ] **Step 1 : Remplacer le `<link>` Google Fonts** pour ajouter Cabinet Grotesk et supprimer Outfit

Remplacer la ligne existante :
```html
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Outfit:wght@300;400;500&display=swap" rel="stylesheet">
```
Par :
```html
<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400;1,600&family=Cabinet+Grotesk:wght@300;400;500;700&display=swap" rel="stylesheet">
```

- [ ] **Step 2 : Supprimer le bloc `.topbar`** dans le `<body>`

Supprimer ces lignes :
```html
<div class="topbar">
  <span>Onglerie</span>
  <span>Beauté des pieds</span>
  <span>Épilation</span>
  <span>Sur rendez-vous</span>
</div>
```

- [ ] **Step 3 : Remplacer le inline `<script>` scroll** par la version sans parallaxe hero-img (supprimé dans nouveau design)

Remplacer le bloc `<script>` actuel par :
```html
<script>
(function () {
  const header = document.querySelector('header');
  let ticking = false;
  window.addEventListener('scroll', function () {
    if (!ticking) {
      requestAnimationFrame(function () {
        if (window.scrollY > 40) header.classList.add('scrolled');
        else header.classList.remove('scrolled');
        ticking = false;
      });
      ticking = true;
    }
  }, { passive: true });
})();
</script>
```

- [ ] **Step 4 : Commit**
```bash
git add app/views/layouts/application.html.erb
git commit -m "feat: update fonts to Cabinet Grotesk, remove topbar, simplify scroll JS"
```

---

## Task 2 : SCSS — tokens globaux + reset + helpers + boutons

**Files:**
- Modify: `app/assets/stylesheets/application.scss` (lignes 1–125 environ)

- [ ] **Step 1 : Remplacer les variables SCSS** (début du fichier, jusqu'à `/* RESET & BASE */`)

Remplacer tout le bloc variables :
```scss
/*
 *= require_self
 */

/* ============================================================
   VARIABLES — Editorial Noir
   ============================================================ */
$void:         #0E0C0A;
$charcoal:     #1A1714;
$ink:          #2C2824;
$cream:        #F5F0E8;
$cream-dim:    rgba(245, 240, 232, 0.45);
$cream-ghost:  rgba(245, 240, 232, 0.08);
$cream-subtle: rgba(245, 240, 232, 0.12);
$gold:         #C9A96E;
$gold-dim:     rgba(201, 169, 110, 0.18);
$border:       rgba(245, 240, 232, 0.10);

$ease-expo:    cubic-bezier(0.16, 1, 0.3, 1);
$ease-std:     cubic-bezier(0.4, 0, 0.2, 1);
```

- [ ] **Step 2 : Remplacer le bloc RESET & BASE**
```scss
/* ============================================================
   RESET & BASE
   ============================================================ */
*, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
html { scroll-behavior: smooth; }

body {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-weight: 300;
  color: $cream;
  background: $void;
  line-height: 1.6;

  // Noise overlay
  &::after {
    content: '';
    position: fixed;
    inset: 0;
    z-index: 9999;
    pointer-events: none;
    opacity: 0.032;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
    background-size: 200px 200px;
  }
}

a { color: inherit; text-decoration: none; }
img { display: block; max-width: 100%; }
```

- [ ] **Step 3 : Remplacer le bloc LAYOUT + HELPERS**
```scss
/* ============================================================
   LAYOUT
   ============================================================ */
.container { max-width: 1160px; margin: 0 auto; padding: 0 48px; }

/* ============================================================
   HELPERS
   ============================================================ */
.section-eyebrow {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.62rem;
  font-weight: 500;
  letter-spacing: 0.24em;
  text-transform: uppercase;
  color: $gold;
  margin-bottom: 0.8rem;
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 4px 14px;
  border-radius: 100px;
  border: 1px solid $border;
}

.section-heading {
  margin-bottom: 4rem;

  h2 {
    font-family: 'Cormorant Garamond', serif;
    font-size: clamp(2.8rem, 5vw, 5rem);
    font-weight: 400;
    color: $cream;
    margin-top: 1rem;
    line-height: 1.1;
    letter-spacing: -0.03em;
  }
}
```

- [ ] **Step 4 : Remplacer le bloc BUTTONS**
```scss
/* ============================================================
   BUTTONS
   ============================================================ */
.btn-primary {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 13px 20px 13px 28px;
  background: $gold;
  color: $void;
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.72rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  border-radius: 100px;
  transition: background 0.28s $ease-expo, transform 0.18s $ease-expo;

  .btn-icon {
    width: 26px;
    height: 26px;
    border-radius: 50%;
    background: rgba($void, 0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.75rem;
    transition: transform 0.22s $ease-expo;
  }

  &:hover {
    background: $cream;
    .btn-icon { transform: translate(1px, -1px) scale(1.08); }
  }
  &:active { transform: scale(0.98); }
}

.btn-outline {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 12px 26px;
  border: 1px solid $border;
  color: $cream-dim;
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.72rem;
  font-weight: 500;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  border-radius: 100px;
  transition: border-color 0.22s $ease-expo, color 0.22s $ease-expo;

  &:hover { border-color: $cream; color: $cream; }
  &:active { transform: scale(0.99); }
}

// Alias pour compatibilité avec les vues existantes
.btn-yellow  { @extend .btn-primary; }
.btn-header  { @extend .btn-primary; padding: 9px 16px 9px 22px; font-size: 0.68rem; }
.btn-booking { @extend .btn-primary; border-radius: 2px; }
.btn-ghost   { @extend .btn-outline; border-radius: 2px; }
.btn-outline-dark { @extend .btn-outline; }
```

- [ ] **Step 5 : Commit**
```bash
git add app/assets/stylesheets/application.scss
git commit -m "feat: rewrite SCSS tokens, reset, helpers, buttons — Editorial Noir"
```

---

## Task 3 : SCSS — Header pill flottant

**Files:**
- Modify: `app/assets/stylesheets/application.scss` (blocs TOPBAR + HEADER)

- [ ] **Step 1 : Remplacer les blocs TOPBAR et HEADER**

Supprimer entièrement les blocs `.topbar`, `body.shop-closed .site-header`, `.site-header`, `.header-inner`, `.header-logo`, `.logo-badge`, `.logo-text`, `.header-nav`.

Les remplacer par :
```scss
/* ============================================================
   HEADER — pill flottante
   ============================================================ */
.site-header {
  position: fixed;
  top: 24px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 100;
  width: auto;
  max-width: calc(100vw - 48px);
  background: transparent;
  border-radius: 100px;
  border: 1px solid $border;
  box-shadow: inset 0 1px 0 rgba(245, 240, 232, 0.07);
  backdrop-filter: blur(0px);
  -webkit-backdrop-filter: blur(0px);
  transition: background 0.4s $ease-expo,
              backdrop-filter 0.4s,
              box-shadow 0.4s $ease-expo,
              border-color 0.4s;

  &.scrolled {
    background: rgba(14, 12, 10, 0.78);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    border-color: $cream-subtle;
    box-shadow: 0 4px 40px rgba(0, 0, 0, 0.5),
                inset 0 1px 0 rgba(245, 240, 232, 0.08);
  }
}

.header-inner {
  display: flex;
  align-items: center;
  gap: 2.4rem;
  padding: 10px 12px 10px 16px;
}

.header-logo {
  display: flex;
  align-items: center;
  gap: 10px;
  text-decoration: none;
  flex-shrink: 0;
}

.logo-badge {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 1px solid rgba(245, 240, 232, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Cormorant Garamond', serif;
  font-size: 1rem;
  font-weight: 600;
  color: $cream;
  flex-shrink: 0;
}

.logo-text {
  font-family: 'Cormorant Garamond', serif;
  font-size: 0.95rem;
  font-weight: 600;
  color: $cream;
  line-height: 1.1;
  letter-spacing: 0.04em;

  small {
    font-size: 0.6rem;
    font-weight: 400;
    letter-spacing: 0.18em;
    color: $cream-dim;
    display: block;
    font-family: 'Cabinet Grotesk', sans-serif;
    text-transform: uppercase;
  }
}

.header-nav {
  display: flex;
  align-items: center;
  gap: 2rem;

  a {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.75rem;
    font-weight: 400;
    letter-spacing: 0.04em;
    color: $cream-dim;
    transition: color 0.2s;
    position: relative;

    &::after {
      content: '';
      position: absolute;
      bottom: -2px;
      left: 0;
      width: 0;
      height: 1px;
      background: $gold;
      transition: width 0.22s $ease-expo;
    }

    &:hover {
      color: $cream;
      &::after { width: 100%; }
    }
  }
}
```

- [ ] **Step 2 : Commit**
```bash
git add app/assets/stylesheets/application.scss
git commit -m "feat: SCSS floating pill header"
```

---

## Task 4 : HTML — Header pill + layout scroll

**Files:**
- Modify: `app/views/shared/_header.html.erb`

- [ ] **Step 1 : Réécrire le header**

Remplacer tout le contenu du fichier par :
```erb
<header class="site-header">
  <div class="header-inner">
    <%= link_to root_path, class: 'header-logo' do %>
      <div class="logo-badge">TN</div>
      <span class="logo-text">Truc Anh<small>Nails</small></span>
    <% end %>

    <nav class="header-nav">
      <%= link_to 'Accueil', root_path %>
      <a href="#services">Prestations</a>
      <%= link_to 'Contact', contact_path %>
    </nav>

    <%= link_to new_booking_path, class: 'btn-header' do %>
      Réserver
      <span class="btn-icon"><i class="fa-solid fa-arrow-right"></i></span>
    <% end %>
  </div>
</header>
```

- [ ] **Step 2 : Commit**
```bash
git add app/views/shared/_header.html.erb
git commit -m "feat: floating pill nav HTML"
```

---

## Task 5 : SCSS — Hero noir pleine hauteur

**Files:**
- Modify: `app/assets/stylesheets/application.scss` (bloc HERO SPLIT → HERO NOIR)

- [ ] **Step 1 : Supprimer** les blocs `.hero-split`, `.hero-left`, `.hero-tag`, `.hero-left h1`, `.hero-info-strip`, `.hero-desc`, `.hero-actions`, `.hero-right`, `.hero-coral-block`, `.hero-img-frame`, `.hero-img`, `.hero-img-accent`, `.hero-coral-block`.

Remplacer par :
```scss
/* ============================================================
   HERO NOIR — pleine hauteur
   ============================================================ */
.hero-noir {
  position: relative;
  min-height: 100dvh;
  display: flex;
  align-items: flex-end;
  background: $void;
  overflow: hidden;
  padding-bottom: 80px;
}

.hero-noir__bg {
  position: absolute;
  inset: 0;
  background-size: cover;
  background-position: center 30%;
  background-image: url('/assets/hands-holding.jpg');
  transform: scale(1.04);
  will-change: transform;
}

.hero-noir__overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    110deg,
    rgba(14, 12, 10, 0.95) 45%,
    rgba(14, 12, 10, 0.4) 100%
  );
}

.hero-noir__content {
  position: relative;
  z-index: 1;
  padding: 0 80px;
  max-width: 900px;
}

.hero-eyebrow-pill {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 5px 14px;
  border-radius: 100px;
  border: 1px solid $border;
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.6rem;
  font-weight: 500;
  letter-spacing: 0.24em;
  text-transform: uppercase;
  color: $gold;
  margin-bottom: 2.4rem;

  &::before {
    content: '';
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: $gold;
    flex-shrink: 0;
  }
}

.hero-display {
  font-family: 'Cormorant Garamond', serif;
  font-size: clamp(5.5rem, 10vw, 13rem);
  font-weight: 300;
  color: $cream;
  line-height: 0.88;
  letter-spacing: -0.04em;
  margin-bottom: 2.4rem;

  em {
    font-style: italic;
    font-weight: 300;
    color: $gold;
  }
}

.hero-desc {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.95rem;
  font-weight: 300;
  color: $cream-dim;
  line-height: 1.9;
  max-width: 400px;
  margin-bottom: 2.8rem;
}

.hero-actions {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.hero-info-strip {
  display: flex;
  gap: 2.4rem;
  margin-top: 3.2rem;
  padding-top: 2rem;
  border-top: 1px solid $cream-ghost;
  flex-wrap: wrap;

  span {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.65rem;
    font-weight: 400;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: $cream-dim;
  }
}
```

- [ ] **Step 2 : Mettre à jour le bloc ANIMATIONS**

Remplacer le bloc ANIMATIONS existant par :
```scss
/* ============================================================
   ANIMATIONS
   ============================================================ */
@keyframes fadeUp {
  from { opacity: 0; transform: translateY(20px); }
  to   { opacity: 1; transform: translateY(0); }
}

@keyframes accordion-reveal {
  from { opacity: 0; transform: translateY(-6px); }
  to   { opacity: 1; transform: translateY(0); }
}

.hero-eyebrow-pill,
.hero-display,
.hero-desc,
.hero-actions,
.hero-info-strip {
  opacity: 0;
  animation: fadeUp 0.8s $ease-expo forwards;
}

.hero-eyebrow-pill { animation-delay: 0.08s; }
.hero-display      { animation-delay: 0.20s; }
.hero-desc         { animation-delay: 0.34s; }
.hero-actions      { animation-delay: 0.48s; }
.hero-info-strip   { animation-delay: 0.62s; }

details[open] .accordion-inner {
  animation: accordion-reveal 0.35s $ease-expo both;
}

// Scroll reveal (via IntersectionObserver)
[data-scroll-reveal] {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.7s $ease-expo, transform 0.7s $ease-expo;

  &.is-visible {
    opacity: 1;
    transform: translateY(0);
  }
}
```

- [ ] **Step 3 : Commit**
```bash
git add app/assets/stylesheets/application.scss
git commit -m "feat: SCSS hero noir + scroll reveal animations"
```

---

## Task 6 : HTML — Hero noir home page

**Files:**
- Modify: `app/views/pages/home.html.erb`

- [ ] **Step 1 : Remplacer la section hero** (lignes 1–35 environ)

Remplacer depuis `<% if @shop_closed %>` jusqu'à la fin de `</section>` du hero par :
```erb
<% if @shop_closed %>
  <div class="shop-closed-banner">
    <i class="fa-solid fa-circle-exclamation"></i>
    <% if @shop_closure[:from] == @shop_closure[:to] %>
      Le salon est fermé le <%= I18n.l(@shop_closure[:from], format: :long) %>. Nous vous accueillons dès le lendemain.
    <% else %>
      Le salon est fermé du <%= I18n.l(@shop_closure[:from], format: :long) %> au <%= I18n.l(@shop_closure[:to], format: :long) %>. À très bientôt !
    <% end %>
  </div>
<% end %>

<section class="hero-noir">
  <div class="hero-noir__bg"></div>
  <div class="hero-noir__overlay"></div>
  <div class="hero-noir__content">
    <p class="hero-eyebrow-pill">Salon d'onglerie · Paris</p>
    <h1 class="hero-display">Des mains<br><em>sublimes,</em><br>vos plus beaux<br>moments.</h1>
    <p class="hero-desc">Chez Truc Anh Nails, des professionnelles passionnées subliment vos mains dans un cadre chaleureux et raffiné.</p>
    <div class="hero-actions">
      <%= link_to new_booking_path, class: 'btn-primary' do %>
        Réserver
        <span class="btn-icon"><i class="fa-solid fa-arrow-right"></i></span>
      <% end %>
      <a href="#services" class="btn-outline">Voir les prestations</a>
    </div>
    <div class="hero-info-strip">
      <span>Paris · Île-de-France</span>
      <span>Lun – Dim · 10h–20h</span>
      <span>Sur rendez-vous</span>
    </div>
  </div>
</section>
```

- [ ] **Step 2 : Commit**
```bash
git add app/views/pages/home.html.erb
git commit -m "feat: hero noir HTML"
```

---

## Task 7 : SCSS — Services section + About section

**Files:**
- Modify: `app/assets/stylesheets/application.scss`

- [ ] **Step 1 : Remplacer le bloc SERVICES**

Remplacer le bloc `.services { ... }` + `.accordion-*` + `.service-row*` par :
```scss
/* ============================================================
   SERVICES — charcoal
   ============================================================ */
.services {
  padding: 120px 0;
  background-color: $charcoal;
  position: relative;
  overflow: hidden;

  &::after {
    content: '01';
    position: absolute;
    top: 24px;
    right: 40px;
    font-family: 'Cormorant Garamond', serif;
    font-size: 16rem;
    font-weight: 600;
    line-height: 1;
    color: rgba($cream, 0.025);
    pointer-events: none;
    user-select: none;
    letter-spacing: -0.04em;
  }

  .section-eyebrow { margin-bottom: 0.6rem; }

  .section-heading h2 { color: $cream; }
}

.accordion-item {
  border-bottom: 1px solid $cream-ghost;
  &:first-child { border-top: 1px solid $cream-ghost; }
}

.accordion-header {
  list-style: none;
  display: flex;
  align-items: center;
  gap: 1.5rem;
  padding: 1.6rem 0;
  cursor: pointer;
  user-select: none;

  &::-webkit-details-marker { display: none; }
  &::marker { display: none; }
  &:hover .accordion-title { color: $cream; }
}

details[open] .accordion-header {
  .accordion-title { color: $cream; }
  .accordion-chevron { transform: rotate(180deg); }
}

.accordion-title {
  font-family: 'Cormorant Garamond', serif;
  font-size: 1.6rem;
  font-weight: 400;
  color: rgba(245, 240, 232, 0.75);
  transition: color 0.2s;
}

.accordion-meta {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.72rem;
  font-weight: 300;
  color: $cream-dim;
  letter-spacing: 0.04em;
  flex: 1;
}

.accordion-chevron {
  width: 20px;
  height: 20px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.28s $ease-expo;

  &::before {
    content: '';
    display: block;
    width: 8px;
    height: 8px;
    border-right: 1px solid $cream-dim;
    border-bottom: 1px solid $cream-dim;
    transform: rotate(45deg) translateY(-3px);
  }
}

.accordion-inner { padding-bottom: 1rem; }

.services-category { margin-bottom: 0; }
.services-category-title { display: none; }

.service-row {
  display: grid;
  grid-template-columns: 1fr 80px 72px;
  align-items: baseline;
  gap: 24px;
  padding: 18px 0;
  border-bottom: 1px solid $cream-ghost;
  transition: background-color 0.18s;

  &:hover .service-row-name { color: $cream; }
}

.service-row-name {
  font-family: 'Cormorant Garamond', serif;
  font-size: 1.2rem;
  font-weight: 400;
  color: rgba(245, 240, 232, 0.75);
  transition: color 0.2s;
}

.service-row-duration {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.75rem;
  font-weight: 300;
  color: $cream-dim;
  white-space: nowrap;
}

.service-row-price {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.9rem;
  font-weight: 500;
  color: $gold;
  text-align: right;
  white-space: nowrap;
}
```

- [ ] **Step 2 : Remplacer le bloc ABOUT**

Remplacer le bloc `.about-section { ... }` + `.about-content` + `.about-image` + `.about-text` + `.about-pic` par :
```scss
/* ============================================================
   ABOUT — void
   ============================================================ */
.about-section {
  padding: 120px 0;
  background-color: $void;
  position: relative;
  overflow: hidden;

  &::after {
    content: '02';
    position: absolute;
    top: 24px;
    right: 40px;
    font-family: 'Cormorant Garamond', serif;
    font-size: 16rem;
    font-weight: 600;
    line-height: 1;
    color: rgba($cream, 0.025);
    pointer-events: none;
    user-select: none;
    letter-spacing: -0.04em;
  }
}

.about-content {
  display: grid;
  grid-template-columns: 1.2fr 1fr;
  gap: 80px;
  align-items: center;
  position: relative;
  z-index: 1;
}

.about-image { order: 1; }
.about-text  { order: 2; }

// Double-bezel sur l'image
.about-bezel {
  padding: 3px;
  background: $cream-ghost;
  border-radius: 4px;
  border: 1px solid $border;
}

.about-pic {
  width: 100%;
  aspect-ratio: 4 / 5;
  object-fit: cover;
  object-position: center;
  border-radius: 2px;
  display: block;
}

.about-text {
  h2 {
    font-family: 'Cormorant Garamond', serif;
    font-size: clamp(2.4rem, 3.6vw, 4rem);
    font-weight: 400;
    color: $cream;
    margin: 1rem 0 1.8rem;
    line-height: 1.05;
    letter-spacing: -0.03em;

    em {
      font-style: italic;
      font-weight: 300;
      color: $gold;
    }
  }

  p {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.95rem;
    font-weight: 300;
    color: $cream-dim;
    line-height: 1.9;
    margin-bottom: 1rem;
    max-width: 460px;
  }

  .btn-primary { margin-top: 0.8rem; }
}
```

- [ ] **Step 3 : Commit**
```bash
git add app/assets/stylesheets/application.scss
git commit -m "feat: SCSS services charcoal + about noir redesign"
```

---

## Task 8 : HTML — About section home page

**Files:**
- Modify: `app/views/pages/home.html.erb`

- [ ] **Step 1 : Remplacer la section about**

Remplacer le bloc `<!-- ABOUT -->` jusqu'à la fin du fichier par :
```erb
<!-- ABOUT -->
<section class="about-section">
  <div class="container">
    <div class="about-content">
      <div class="about-image" data-scroll-reveal style="--reveal-index: 0">
        <div class="about-bezel">
          <%= image_tag 'workind.jpg', alt: 'Truc Anh Nails salon', class: 'about-pic' %>
        </div>
      </div>
      <div class="about-text" data-scroll-reveal style="--reveal-index: 1">
        <p class="section-eyebrow">Notre histoire</p>
        <h2>À propos de <em>Truc Anh Nails</em></h2>
        <p>Chez Truc Anh Nails, notre passion est de sublimer vos mains et de vous offrir un moment de détente dans un cadre raffiné. Nous vous accueillons dans une ambiance chaleureuse et professionnelle.</p>
        <p>Notre équipe de professionnelles est là pour vous conseiller et réaliser vos envies, qu'il s'agisse d'une manucure classique ou d'un nail art élaboré.</p>
        <%= link_to contact_path, class: 'btn-primary' do %>
          Nous contacter
          <span class="btn-icon"><i class="fa-solid fa-arrow-right"></i></span>
        <% end %>
      </div>
    </div>
  </div>
</section>
```

- [ ] **Step 2 : Ajouter data-scroll-reveal sur la section services heading**

Dans la section `<!-- SERVICES -->`, ajouter `data-scroll-reveal` sur `.section-heading` :
```erb
<div class="section-heading" data-scroll-reveal>
```

- [ ] **Step 3 : Commit**
```bash
git add app/views/pages/home.html.erb
git commit -m "feat: about section redesign + scroll reveal attributes"
```

---

## Task 9 : SCSS + HTML — Footer noir

**Files:**
- Modify: `app/assets/stylesheets/application.scss` (bloc FOOTER)
- Modify: `app/views/shared/_footer.html.erb`

- [ ] **Step 1 : Remplacer le bloc FOOTER dans le SCSS**

Remplacer tout le bloc `.site-footer { ... }` jusqu'à `.footer-bottom { ... }` par :
```scss
/* ============================================================
   FOOTER — near-black
   ============================================================ */
.site-footer {
  background-color: #080705;
  color: $cream-dim;
  padding: 72px 0 28px;
  border-top: 1px solid $cream-ghost;
}

.footer-coral { display: none; }

.footer-top {
  display: grid;
  grid-template-columns: 1.8fr 1fr 1fr 1fr;
  gap: 48px;
  padding-bottom: 48px;
  border-bottom: 1px solid $cream-ghost;
  margin-bottom: 24px;
}

.footer-brand {
  display: flex;
  align-items: flex-start;
  gap: 14px;
}

.footer-logo-badge {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  border: 1px solid rgba(245, 240, 232, 0.18);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Cormorant Garamond', serif;
  font-size: 1rem;
  font-weight: 600;
  color: $cream;
  flex-shrink: 0;
}

.footer-logo-text {
  font-family: 'Cormorant Garamond', serif;
  font-size: 1.1rem;
  font-weight: 600;
  color: rgba(245, 240, 232, 0.82);
  display: block;
  margin-bottom: 0.5rem;
  letter-spacing: 0.02em;
}

.footer-brand p {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.85rem;
  font-weight: 300;
  color: rgba(245, 240, 232, 0.22);
  line-height: 1.65;
}

.footer-links h4,
.footer-contact h4,
.footer-cta h4 {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.6rem;
  font-weight: 500;
  letter-spacing: 0.22em;
  text-transform: uppercase;
  color: $gold;
  margin-bottom: 1.2rem;
}

.footer-links ul {
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;

  a {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.88rem;
    font-weight: 300;
    color: $cream-dim;
    transition: color 0.2s;
    &:hover { color: $cream; }
  }
}

.footer-contact p {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.85rem;
  font-weight: 300;
  color: $cream-dim;
  margin-bottom: 0.75rem;

  i { color: $gold; font-size: 0.8rem; margin-top: 3px; flex-shrink: 0; opacity: 0.8; }
}

.footer-cta p {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.85rem;
  font-weight: 300;
  color: rgba(245, 240, 232, 0.28);
  margin-bottom: 1.2rem;
  line-height: 1.65;
}

.site-footer .btn-primary {
  background: transparent;
  border: 1px solid rgba(201, 169, 110, 0.35);
  color: $gold;
  padding: 10px 16px 10px 22px;
  font-size: 0.68rem;

  .btn-icon { background: $gold-dim; }

  &:hover {
    background: $gold;
    border-color: $gold;
    color: $void;
    .btn-icon { background: rgba($void, 0.2); }
  }
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;

  p, a {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.72rem;
    font-weight: 300;
    color: rgba(245, 240, 232, 0.14);
  }
  a { transition: color 0.2s; &:hover { color: rgba(245, 240, 232, 0.42); } }
}
```

- [ ] **Step 2 : Réécrire le footer HTML**

Remplacer tout le contenu de `_footer.html.erb` par :
```erb
<footer class="site-footer">
  <div class="container">
    <div class="footer-top">
      <div class="footer-brand">
        <div class="footer-logo-badge">TN</div>
        <div>
          <span class="footer-logo-text">Truc Anh Nails</span>
          <p>L'art de sublimer vos mains dans un cadre raffiné, au cœur de Paris.</p>
        </div>
      </div>
      <div class="footer-links">
        <h4>Navigation</h4>
        <ul>
          <li><%= link_to 'Accueil', root_path %></li>
          <li><a href="#services">Prestations</a></li>
          <%= link_to 'Contact', contact_path %>
        </ul>
      </div>
      <div class="footer-contact">
        <h4>Contact</h4>
        <p><i class="fa-solid fa-phone"></i> <a href="tel:+33627358188">06 27 35 81 88</a></p>
        <p><i class="fa-solid fa-location-dot"></i> 64 rue Brancion, Paris 15e</p>
        <p><i class="fa-solid fa-clock"></i> Lun – Dim : 10h – 20h</p>
      </div>
      <div class="footer-cta">
        <h4>Réservation</h4>
        <p>Prenez rendez-vous en ligne facilement.</p>
        <%= link_to new_booking_path, class: 'btn-primary' do %>
          Réserver
          <span class="btn-icon"><i class="fa-solid fa-arrow-right"></i></span>
        <% end %>
      </div>
    </div>
    <div class="footer-bottom">
      <p>© 2025 Truc Anh Nails — Tous droits réservés</p>
      <a href="#">Mentions légales</a>
    </div>
  </div>
</footer>
```

- [ ] **Step 3 : Commit**
```bash
git add app/assets/stylesheets/application.scss app/views/shared/_footer.html.erb
git commit -m "feat: footer noir — SCSS + HTML"
```

---

## Task 10 : SCSS — Contact page + shop-closed banner

**Files:**
- Modify: `app/assets/stylesheets/application.scss`

- [ ] **Step 1 : Remplacer le bloc CONTACT PAGE HERO**

Remplacer le bloc `.hero { ... }` + `.hero-overlay` + `.hero-content` + `.home-hero` + `.contact-hero` par :
```scss
/* ============================================================
   CONTACT HERO
   ============================================================ */
.hero-contact {
  position: relative;
  min-height: 55vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background-size: cover;
  background-position: center;
  overflow: hidden;

  &::after {
    content: '';
    position: absolute;
    inset: 0;
    background: rgba(14, 12, 10, 0.72);
  }
}

.hero-contact__content {
  position: relative;
  z-index: 2;
  padding: 0 32px;

  .hero-eyebrow-pill { margin: 0 auto 1.6rem; }

  h1 {
    font-family: 'Cormorant Garamond', serif;
    font-size: clamp(3rem, 6vw, 5.5rem);
    font-weight: 300;
    color: $cream;
    line-height: 1.05;
    letter-spacing: -0.03em;
    margin-bottom: 1rem;
  }

  .hero-sub {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.95rem;
    font-weight: 300;
    color: $cream-dim;
  }
}
```

- [ ] **Step 2 : Remplacer le bloc CONTACT SECTION**

Remplacer le bloc `.contact-section { ... }` jusqu'à `.metro-tag--bus` par :
```scss
/* ============================================================
   CONTACT SECTION
   ============================================================ */
.contact-section {
  padding: 100px 0;
  background-color: $charcoal;
}

.contact-grid {
  display: grid;
  grid-template-columns: 1fr 1.5fr;
  gap: 72px;
  align-items: start;
}

.contact-info {
  h2 {
    font-family: 'Cormorant Garamond', serif;
    font-size: clamp(2.2rem, 3.5vw, 3.2rem);
    font-weight: 400;
    color: $cream;
    margin: 1rem 0 2.4rem;
    line-height: 1.15;
    letter-spacing: -0.02em;
  }
}

.gold-bar { display: none; }

.info-list {
  display: flex;
  flex-direction: column;
  gap: 1.8rem;
}

.info-item {
  display: flex;
  align-items: flex-start;
  gap: 1.2rem;

  i { font-size: 0.8rem; color: $gold; margin-top: 5px; flex-shrink: 0; width: 14px; }
  div { display: flex; flex-direction: column; gap: 4px; }

  strong {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.62rem;
    font-weight: 500;
    letter-spacing: 0.16em;
    text-transform: uppercase;
    color: $cream-dim;
  }

  span {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.9rem;
    font-weight: 300;
    color: $cream;
    a { color: $cream; transition: color 0.2s; &:hover { color: $gold; } }
  }
}

.contact-map {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.google-map {
  height: 400px;
  width: 100%;
  border: 0;
  border-radius: 2px;
  filter: grayscale(100%) contrast(1.1) brightness(0.35);
  box-shadow: 0 4px 32px rgba(0, 0, 0, 0.4);
}

.metro-badge {
  background: $ink;
  border: 1px solid $cream-ghost;
  border-radius: 2px;
  padding: 0.75rem 1.2rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.metro-badge-title {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.62rem;
  font-weight: 500;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: $cream-dim;
  margin: 0;
  white-space: nowrap;
}

.metro-tags {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.metro-tag {
  display: inline-flex;
  align-items: center;
  padding: 3px 10px;
  border-radius: 20px;
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.72rem;
  font-weight: 600;
  color: $cream;
  white-space: nowrap;

  &--13  { background: $ink; border: 1px solid $cream-ghost; }
  &--12  { background: $charcoal; border: 1px solid $cream-ghost; }
  &--bus { background: $gold-dim; color: $gold; border: 1px solid rgba(201, 169, 110, 0.3); }
}
```

- [ ] **Step 3 : Mettre à jour le bloc SHOP CLOSED BANNER**

Remplacer le bloc `.shop-closed-banner` par :
```scss
/* ============================================================
   SHOP CLOSED BANNER
   ============================================================ */
.shop-closed-banner {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 200;
  background: $charcoal;
  border-bottom: 1px solid $cream-ghost;
  color: $cream-dim;
  text-align: center;
  padding: 12px 24px;
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.8rem;
  font-weight: 300;
  letter-spacing: 0.04em;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;

  i { color: $gold; font-size: 0.85rem; }
}
```

- [ ] **Step 4 : Mettre à jour les blocs BOOKING, SUCCESS/CANCEL**

Remplacer les blocs `.booking-*` + `.result-page` + `.result-*` + `.btn-ghost` par :
```scss
/* ============================================================
   BOOKING
   ============================================================ */
.booking-hero-section {
  position: relative;
  min-height: 44vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  background-color: $charcoal;
  overflow: hidden;
  padding-top: 76px;

  .hero-eyebrow-pill { margin: 0 auto 1.4rem; }

  h1 {
    font-family: 'Cormorant Garamond', serif;
    font-size: clamp(2.8rem, 5vw, 4.5rem);
    font-weight: 300;
    color: $cream;
    letter-spacing: -0.03em;
  }
}

.booking-section {
  padding: 72px 0 100px;
  background-color: $void;
}

.booking-wrapper {
  display: flex;
  justify-content: center;
}

.booking-sidebar {
  background-color: $charcoal;
  border: 1px solid $cream-ghost;
  border-radius: 2px;
  padding: 32px 24px;
  position: sticky;
  top: 100px;

  h3 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 1.2rem;
    font-weight: 400;
    color: $cream;
    margin-bottom: 1.4rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid $cream-ghost;
  }
}

.service-price-list {
  list-style: none;
  margin-bottom: 1.6rem;

  li {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid $cream-ghost;
    font-size: 0.85rem;
    &:last-child { border-bottom: none; }

    .spl-name  { color: $cream-dim; font-weight: 300; font-family: 'Cabinet Grotesk', sans-serif; }
    .spl-price { font-weight: 500; color: $gold; font-family: 'Cabinet Grotesk', sans-serif; }
  }
}

.booking-note {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.75rem;
  font-weight: 300;
  color: $cream-dim;
  display: flex;
  align-items: center;
  gap: 8px;

  i { color: $gold; }
}

.booking-form-wrapper {
  background-color: $charcoal;
  border: 1px solid $cream-ghost;
  border-radius: 2px;
  padding: 44px;
}

.form-section-title {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.62rem;
  font-weight: 500;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: $cream-dim;
  margin: 2rem 0 1.2rem;
  padding-bottom: 0.6rem;
  border-bottom: 1px solid $cream-ghost;
  &:first-child { margin-top: 0; }
}

.form-group {
  margin-bottom: 1.2rem;

  label {
    display: block;
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.68rem;
    font-weight: 500;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: $cream-dim;
    margin-bottom: 6px;
  }
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.form-control {
  width: 100%;
  padding: 11px 14px;
  border: 1px solid $cream-ghost;
  border-radius: 2px;
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.9rem;
  font-weight: 300;
  color: $cream;
  background-color: $ink;
  appearance: auto;
  transition: border-color 0.2s;

  &:focus { outline: none; border-color: $gold; }
  &:disabled { background-color: $charcoal; color: $cream-dim; cursor: not-allowed; }

  option { background-color: $ink; color: $cream; }
}

.price-display {
  margin: -0.4rem 0 1rem;

  .price-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.85rem;
    font-weight: 500;
    color: $gold;
  }
}

.form-errors {
  background-color: $gold-dim;
  border: 1px solid rgba(201, 169, 110, 0.3);
  border-radius: 2px;
  padding: 16px 20px;
  margin-bottom: 1.5rem;

  p {
    font-family: 'Cabinet Grotesk', sans-serif;
    font-size: 0.85rem;
    font-weight: 300;
    color: $gold;
    margin-bottom: 4px;
    display: flex;
    align-items: center;
    gap: 8px;
    &:last-child { margin-bottom: 0; }
  }
}

.form-submit {
  margin-top: 2rem;
  display: flex;
  align-items: center;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.submit-note {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.75rem;
  font-weight: 300;
  color: $cream-dim;
  display: flex;
  align-items: center;
  gap: 6px;

  i { color: $gold; }
}

/* ============================================================
   SUCCESS / CANCEL
   ============================================================ */
.result-page {
  min-height: 80vh;
  display: flex;
  align-items: center;
  background-color: $void;
  padding-top: 88px;
}

.result-inner {
  text-align: center;
  padding: 96px 48px;
  width: 100%;

  h1 {
    font-family: 'Cormorant Garamond', serif;
    font-size: 3rem;
    font-weight: 300;
    color: $cream;
    margin: 1.2rem 0 1rem;
    letter-spacing: -0.02em;
  }
}

.result-icon {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  margin: 0 auto;
  border: 1px solid $cream-ghost;
  i { color: $cream; }
}

.success-icon { background-color: $gold-dim; border-color: rgba(201, 169, 110, 0.3); i { color: $gold; } }
.cancel-icon  { background-color: $ink; }

.result-sub {
  font-family: 'Cabinet Grotesk', sans-serif;
  font-size: 0.95rem;
  font-weight: 300;
  color: $cream-dim;
  line-height: 1.85;
  max-width: 500px;
  margin: 0 auto 0.6rem;
}

.result-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
  margin-top: 2rem;
}
```

- [ ] **Step 5 : Commit**
```bash
git add app/assets/stylesheets/application.scss
git commit -m "feat: SCSS contact, booking, results pages — Editorial Noir"
```

---

## Task 11 : HTML — Contact page hero partial

**Files:**
- Modify: `app/views/shared/_hero.html.erb`
- Modify: `app/views/pages/contact.html.erb`

- [ ] **Step 1 : Lire le contenu de `_hero.html.erb`** pour voir sa structure actuelle

- [ ] **Step 2 : Réécrire `_hero.html.erb`**

```erb
<section class="hero-contact" style="background-image: url('/assets/<%= hero_image || 'hands-rdv.jpg' %>');">
  <div class="hero-contact__content">
    <p class="hero-eyebrow-pill"><%= hero_eyebrow || 'Contact' %></p>
    <h1><%= hero_title %></h1>
    <% if local_assigns[:hero_description] %>
      <p class="hero-sub"><%= hero_description %></p>
    <% end %>
  </div>
</section>
```

- [ ] **Step 3 : Commit**
```bash
git add app/views/shared/_hero.html.erb
git commit -m "feat: hero partial redesign for contact page"
```

---

## Task 12 : Stimulus — Scroll reveal controller

**Files:**
- Create: `app/javascript/controllers/scroll_reveal_controller.js`

- [ ] **Step 1 : Créer le controller**

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible")
            this.observer.unobserve(entry.target)
          }
        })
      },
      { threshold: 0.12, rootMargin: "0px 0px -40px 0px" }
    )

    this.element
      .querySelectorAll("[data-scroll-reveal]")
      .forEach((el) => this.observer.observe(el))
  }

  disconnect() {
    if (this.observer) this.observer.disconnect()
  }
}
```

- [ ] **Step 2 : Enregistrer le controller dans `application.js`**

Dans `app/javascript/controllers/index.js` (ou `application.js` selon structure), ajouter :
```javascript
import ScrollRevealController from "./scroll_reveal_controller"
application.register("scroll-reveal", ScrollRevealController)
```

- [ ] **Step 3 : Ajouter `data-controller="scroll-reveal"` sur `<body>` dans le layout**

Dans `app/views/layouts/application.html.erb`, modifier :
```erb
<body class="<%= 'shop-closed' if _closure && Date.today.between?(_closure[:from], _closure[:to]) %>" data-controller="scroll-reveal">
```

- [ ] **Step 4 : Commit**
```bash
git add app/javascript/controllers/scroll_reveal_controller.js app/javascript/controllers/index.js app/views/layouts/application.html.erb
git commit -m "feat: scroll reveal Stimulus controller"
```

---

## Task 13 : Vérification finale + nettoyage

**Files:**
- Modify: `app/assets/stylesheets/application.scss` (supprimer classes orphelines)

- [ ] **Step 1 : Démarrer le serveur et vérifier visuellement**

```bash
bin/rails server
```

Ouvrir `http://localhost:3000` et vérifier :
- [ ] Navbar pill flottante visible, glassmorphism au scroll
- [ ] Hero noir pleine hauteur, animations staggered au chargement
- [ ] Section services sur fond charcoal, accordéons fonctionnels
- [ ] Section about asymétrique sur fond void, double-bezel image
- [ ] Footer noir, couleurs or/crème correctes
- [ ] Page contact : hero + section info + carte filtrée en noir

- [ ] **Step 2 : Supprimer les classes SCSS orphelines** non utilisées après la refonte :
`.forest`, `.forest-light`, `.forest-pale`, `.forest-muted`, `.stone`, `.white`, `.grey` (si non référencés)

- [ ] **Step 3 : Commit final**
```bash
git add app/assets/stylesheets/application.scss
git commit -m "chore: remove orphan SCSS variables after Editorial Noir redesign"
```
