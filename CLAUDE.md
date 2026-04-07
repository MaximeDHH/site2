# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Manucure Vitrine** is a static showcase website for "Royal Nail", a nail salon located in Lorient, France. It is a Rails 7.1 app with no database — purely a frontend vitrine with two pages (home and contact).

- Ruby 3.3.5, Rails 7.1
- No ActiveRecord / no database
- Sprockets for assets, `sassc-rails` for SCSS compilation
- Stimulus + Turbo (Hotwire) via importmap
- Leaflet.js (loaded via CDN) for the map on the contact page

## Common Commands

```bash
bundle install          # Install gems
bin/rails server        # Start dev server at localhost:3000
bin/rails test          # Run all tests
bin/rails test test/path/to/test_file.rb  # Run a single test file
```

No database setup needed — this app has no models or migrations.

## Architecture

**Routes → Controller → Views** (no models):
- `PagesController#home` → `app/views/pages/home.html.erb`
- `PagesController#contact` → `app/views/pages/contact.html.erb`

**Shared partials** in `app/views/shared/`:
- `_header.html.erb` — fixed navbar with logo
- `_footer.html.erb` — footer with address/contact info
- `_hero.html.erb` — reusable full-screen hero section, accepts `hero_class`, `hero_title`, `hero_description` locals

**Styling** is all in `app/assets/stylesheets/application.scss` (single file). The header transitions between transparent (on top) and a blurred/scrolled state via inline JS in `app/views/layouts/application.html.erb`.

**Fonts & icons** loaded via CDN: Montserrat (Google Fonts), Font Awesome 6.5.

**Map** on the contact page uses Leaflet.js loaded via CDN (not importmap), initialized with inline `<script>` in the view, centered on the salon's coordinates in Lorient.

**Images** live in `app/assets/images/` and are referenced with `image_tag` or directly as `/assets/filename.jpg` in CSS.
