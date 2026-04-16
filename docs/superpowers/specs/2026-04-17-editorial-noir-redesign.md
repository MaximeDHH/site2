# Truc Anh Nails — Refonte Editorial Noir
**Date :** 2026-04-17  
**Stack :** Rails 7.1, SCSS pur (Sprockets), Stimulus/Turbo, pas de React/Tailwind

---

## 1. Direction créative

**Vibe :** Editorial Noir — near-black chaud dominant, typographie Cormorant monumentale en crème ivoire, accent or unique, grain papier premium.  
**Référence mentale :** Couverture de Vogue Paris × spa parisien haut de gamme.  
**Motion :** Subtil & Raffiné — staggered fadeUp au scroll via IntersectionObserver, hover states soignés, pas d'animations tape-à-l'œil.

---

## 2. Tokens globaux

### Palette SCSS
```scss
$void:        #0E0C0A;   // fond principal
$charcoal:    #1A1714;   // sections alternées
$ink:         #2C2824;   // composants sombres
$cream:       #F5F0E8;   // texte principal
$cream-dim:   rgba(245, 240, 232, 0.45);  // texte secondaire
$cream-ghost: rgba(245, 240, 232, 0.08);  // bordures / séparateurs
$gold:        #C9A96E;   // accent unique
$gold-dim:    rgba(201, 169, 110, 0.18);  // fonds dorés légers
$border:      rgba(245, 240, 232, 0.10);  // bordures standard
```

### Typographie
- **Display (H1 hero)** : Cormorant Garamond, `clamp(6rem, 10vw, 13rem)`, weight 300, `letter-spacing: -0.04em`, `line-height: 0.88`
- **H2 sections** : Cormorant Garamond, `clamp(2.8rem, 5vw, 5rem)`, weight 400, italique pour les `<em>`
- **Body / UI** : Cabinet Grotesk (via Google Fonts), weight 300–500
- **Eyebrow** : Cabinet Grotesk, `0.62rem`, weight 500, `letter-spacing: 0.24em`, uppercase, couleur `$gold`
- **Remplacer** Outfit/DM Sans par Cabinet Grotesk partout

### Noise overlay
```scss
body::after {
  content: '';
  position: fixed;
  inset: 0;
  z-index: 9999;
  pointer-events: none;
  background-image: url("data:image/svg+xml,..."); // SVG noise
  opacity: 0.032;
}
```

### Easing global
```scss
$ease-out-expo: cubic-bezier(0.16, 1, 0.3, 1);
$ease-standard: cubic-bezier(0.4, 0, 0.2, 1);
```

---

## 3. Navigation — Pill flottante

**Suppression :** La `.topbar` est supprimée. Ses infos migrent dans le footer et la hero info-strip.

**Structure :**
```
[ TN ] Truc Anh Nails     Accueil · Prestations · Contact     [ Réserver → ]
```

**Positionnement :** `position: fixed; top: 24px; left: 50%; transform: translateX(-50%); z-index: 100;`

**Forme :** `border-radius: 100px; padding: 10px 16px 10px 12px;`

**Double-bezel :**
- Outer : `box-shadow: 0 0 0 1px rgba(245,240,232,0.06), inset 0 1px 0 rgba(245,240,232,0.08);`
- Fond initial : `rgba(14,12,10,0)`, `backdrop-filter: blur(0px)`
- Fond scrollé (`.scrolled`) : `rgba(14,12,10,0.78)`, `backdrop-filter: blur(24px)`, `box-shadow: 0 4px 40px rgba(0,0,0,0.5), 0 0 0 1px rgba(245,240,232,0.1)`

**Logo badge :** Cercle 36px, bordure `1px solid $cream` à 20% opacité, initiales `TN` Cormorant Garamond.

**Nav links :** Cabinet Grotesk `0.75rem` weight 400, couleur `$cream-dim`. Hover : couleur `$cream` + underline `1px solid $gold` slide depuis gauche (`width: 0 → 100%`, `0.22s`).

**CTA Réserver :** Pill `border-radius: 100px`, fond `$gold`, texte `$void`, Cabinet Grotesk `0.7rem` weight 600, uppercase. Hover : fond `$cream`, transition `0.28s $ease-out-expo`.

**Mobile :** Pill collapse → logo + hamburger. Menu overlay full-screen `$void` avec links Cormorant `3rem` centrés, staggered fadeUp `delay: 0ms, 80ms, 160ms, 240ms`.

---

## 4. Hero — Pleine hauteur Editorial

**Layout :** `min-height: 100dvh`, fond `$void`, image en `position: absolute` full-bleed, overlay gradient `linear-gradient(to right, rgba(14,12,10,0.95) 55%, rgba(14,12,10,0.3) 100%)`.

**Structure DOM :**
```
.hero-noir
  .hero-noir__bg (image absolute)
  .hero-noir__overlay (gradient)
  .hero-noir__content (relative z-index 1)
    .hero-eyebrow     — "Salon d'onglerie · Paris"
    h1.hero-display   — "Des mains\nsublimes."
    p.hero-desc
    .hero-actions     — [Réserver] [Voir les prestations ↓]
    .hero-info-strip
```

**Headline :** Cormorant Garamond `clamp(6rem, 10vw, 13rem)`, weight 300, crème `$cream`, `line-height: 0.88`. Le mot `sublimes` en `<em>` : italic, couleur `$gold`.

**Eyebrow :** Pill badge `border-radius: 100px`, `padding: 4px 14px`, bordure `1px solid $border`, Cabinet Grotesk `0.6rem`, `letter-spacing: 0.24em`, couleur `$gold`.

**Hero desc :** Cabinet Grotesk `0.95rem` weight 300, `$cream-dim`, `max-width: 400px`, `line-height: 1.9`.

**Bouton Réserver :** Pill fond `$gold`, texte `$void`. Icône flèche dans cercle intérieur `$void/20`, se translate `+1px -1px` au hover.

**Bouton outline :** Pill bordure `$border`, texte `$cream-dim`. Hover : bordure `$cream`.

**Hero info-strip :** 3 items Cabinet Grotesk `0.65rem` uppercase `$cream-dim`, séparés par `·`, `border-top: 1px solid $cream-ghost`, `padding-top: 1.6rem`, `margin-top: 2.4rem`.

**Animations load :** Staggered fadeUp — eyebrow `80ms`, h1 `200ms`, desc `320ms`, actions `440ms`, strip `580ms`.

---

## 5. Services — Fond charcoal

**Fond :** `$charcoal`. Numéro de section `01` en fond Cormorant `14rem`, `opacity: 0.025`, `$cream`, position `absolute top-8 right-10`.

**Section heading :** Eyebrow `$gold`, H2 Cormorant crème `clamp(2.8rem, 4.5vw, 4.5rem)`.

**Accordéon redessiné :**
- Item séparateur : `1px solid $cream-ghost`
- Header : Cabinet Grotesk pour le meta (count + prix), Cormorant pour le titre `1.6rem`
- Titre couleur : `$cream` à 85%, hover → `$cream` 100%
- Meta couleur : `$cream-dim`
- Chevron : `1px solid $cream` à 30%, rotate `180deg` à l'ouverture

**Service rows :**
- Grid `1fr 80px 72px`
- Nom : Cormorant `1.2rem` `$cream` à 80%
- Durée : Cabinet Grotesk `0.75rem` `$cream-dim`
- Prix : Cabinet Grotesk `0.9rem` weight 500, couleur `$gold`
- Hover : nom → `$cream` 100%

---

## 6. About — Fond void

**Fond :** `$void` (différent du design actuel qui était `$stone`).

**Layout asymétrique 55/45 :** image à gauche (55%), texte à droite (45%), gap `80px`.

**Image :** `aspect-ratio: 4/5`, `object-fit: cover`, pas de box-shadow coloré — à la place : outer bezel `padding: 3px`, fond `$cream-ghost`, `border-radius: 4px`. Inner image `border-radius: 2px`.

**Texte :**
- Eyebrow `$gold`
- H2 Cormorant crème, `<em>` italique `$gold`
- Paragraphes Cabinet Grotesk `0.95rem` `$cream-dim` `line-height: 1.9`
- CTA : pill `$gold`, texte `$void`

**Décoration :** Numéro `02` en fond à `opacity: 0.025`.

---

## 7. Contact page

**Hero contact :** Même structure que hero home mais plus compact (`min-height: 55vh`), overlay plus dense (`rgba(14,12,10,0.7)`).

**Section contact :** Fond `$charcoal`, grid `1fr 1.5fr`.

**Contact info :** Icons remplacés par traits — petits tirets `—` avant chaque info. Couleurs crème/gold.

**Metro badges :** Redessinés en pills fines, fond `$cream-ghost`, texte `$cream-dim`.

**Carte Leaflet :** Filtre CSS `grayscale(100%) contrast(1.1) brightness(0.4)` pour correspondre à l'ambiance noir.

---

## 8. Footer

**Fond :** `#080705` (plus sombre que `$void`).

**Logo :** Même pill que nav mais statique, taille légèrement plus grande.

**Structure :** Grid `2fr 1fr 1fr 1fr`, gap `48px`.

**Typographie :** Tous Cabinet Grotesk. Headers colonnes en `$gold` `0.6rem` uppercase. Links en `$cream-dim`. Descriptions en `$cream` à 20%.

**CTA footer :** Pill outline, bordure `$gold` à 30%, texte `$gold`. Hover : fond `$gold`, texte `$void`.

**Footer bottom :** `border-top: 1px solid $cream-ghost`. Copyright `$cream` à 12% opacité.

---

## 9. Animations globales (IntersectionObserver)

```js
// stimulus controller: scroll_reveal_controller.js
// Ajoute classe .is-visible quand l'élément entre dans le viewport
// Éléments marqués data-controller="scroll-reveal"
```

```scss
[data-scroll-reveal] {
  opacity: 0;
  transform: translateY(20px);
  transition: opacity 0.7s $ease-out-expo, transform 0.7s $ease-out-expo;

  &.is-visible {
    opacity: 1;
    transform: translateY(0);
  }
}
```

**Stagger sur listes** : `transition-delay: calc(var(--reveal-index) * 80ms)` via attribut `style="--reveal-index: N"`.

---

## 10. Fichiers à modifier

| Fichier | Changements |
|---|---|
| `app/assets/stylesheets/application.scss` | Refonte complète des variables et tous les composants |
| `app/views/layouts/application.html.erb` | Nouvelle font Cabinet Grotesk, suppression topbar, nouveau header pill |
| `app/views/shared/_header.html.erb` | Restructuration en pill flottante |
| `app/views/shared/_footer.html.erb` | Nouvelle mise en page footer noir |
| `app/views/pages/home.html.erb` | Nouveau hero noir, sections redessinées |
| `app/views/pages/contact.html.erb` | Filtre carte, redesign info |
| `app/javascript/controllers/` | Nouveau `scroll_reveal_controller.js` |

---

## 11. Dépendances à ajouter

- **Cabinet Grotesk** : via Google Fonts CDN (déjà chargé via `<link>` dans layout)
- Aucune nouvelle gem nécessaire
