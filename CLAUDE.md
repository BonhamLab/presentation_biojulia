# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A [Typst](https://typst.app) + [Touying](https://touying-typ.github.io/) presentation — "The State
of BioJulia," a talk for the BioJulia Minisymposium at JuliaCon 2026. `main.typ` is the entire deck
(title, agenda, sections, content slides, thank-you). Previously this repo was a Slidev deck; it was
rewritten to Typst to match [`template_presentation`](https://github.com/BonhamLab/template_presentation),
the lab's Typst talk template — see that repo for the theme's design rationale.

## Structure

- `main.typ` — the whole deck. Slides come from Touying's heading-driven auto-slicing: a `=`
  heading starts a new section slide (via `bonham-theme`'s `new-section-slide`), a `==` heading
  starts a new content slide, and content between headings becomes that slide's body. Most content
  slides here wrap their body in an explicit `#slide(...)[...]` anyway (for `align:`, `#pause`
  reveals, or multi-column `#grid`s), with the heading above providing the title.
- `assets/theme/bonham-theme.typ` — **a local copy** of the lab's Touying theme, not a submodule.
  If lab-wide branding changes in `template_presentation`, re-copy this file from there; don't
  diverge it for this talk specifically (talk-specific tweaks belong in `main.typ`, e.g. the
  `framed`/`code-card` helpers defined at its top).
- `assets/general/` — git submodule ([`assets_lab_general`](https://github.com/BonhamLab/assets_lab_general))
  providing `contact_info_slide`, `thank-you-slide`, the lab logo, and headshots used on the
  closing slides. Run `git submodule update --init --recursive` after cloning.
- `images/` — this talk's figures, referenced directly as `image("images/foo.png")` from `main.typ`
  (Typst resolves paths relative to `--root`, which CI and the commands below set to the repo root).
  `images/cajun/` holds figures pulled from third-party BioJulia package docs/repos for illustration.

## Dark mode

The deck runs the whole talk in `bonham-theme`'s dark "terminal" palette (not just the default
light "paper" one) — `main.typ`'s `bonham-theme.with(...)` call passes `bonham-dark.*` into the
theme's light-slot arguments (`bg`, `surface`, `text-color`, ...) and `bonham-light.*` into its
dark-slot arguments (`dark-bg`, `dark-surface`, ...). This is a swap done entirely from `main.typ`,
not a change to `bonham-theme.typ` itself — the theme has no built-in whole-deck dark toggle (see
its own repo's README). One side effect: `#focus-slide[..]` now renders in the *light* palette
instead of dark, since it always pulls from the "dark-slot" arguments — that's intentional, it's
still the one deliberate change-of-register slide, just inverted to match this deck's default.

## Images against a dark background

Plots/screenshots that carry their own (usually white) background aren't re-exported — they're
wrapped in the `framed()` helper defined near the top of `main.typ` (thin `bonham-dark.border`
box, clipped, small radius) so they read as a card instead of a bare white rectangle. SVG diagrams
that are already transparent/dark-compatible (the `txn-*.svg` figures) are used unwrapped. Code
blocks go through the `code-card()` helper (a `bonham-dark.surface` box) for the same reason.

## Reveals

Click-by-click reveals (the Slidev deck's `v-clicks`) are done with Touying's `#pause` between list
items, and `#uncover("N-")[...]` for images/content that should appear in sync with a specific
bullet (see the "Parsing infrastructure" and "Infrastructure and other milestones" slides for the
paired bullet/headshot pattern).

## Commands

- `typst compile --root . main.typ presentation.pdf` — build the PDF
- `typst watch --root . main.typ presentation.pdf` — rebuild on save while editing
- `typst compile --root . --format png --pages 1 main.typ title-slide.png` — regenerate the title-slide preview

Requires IBM Plex Sans/Serif/Mono installed system-wide (Arch: `pacman -S ttf-ibm-plex`).

## Supplementary: GitHub stats scripts (`code/`)

`code/` is a standalone Julia/Quarto tool used to generate the GitHub-activity plots (`stars.svg`,
`repostats.svg`, `commiters.svg`) embedded in the deck — it's not part of the Typst build.
`code/gh-module.jl` defines a `GHInfo` module wrapping the `gh` CLI (`gh api --paginate --slurp`)
to pull star history and commit/repo stats for the BioJulia org; `code/github-stats.qmd` is a
Quarto notebook that calls into it with CairoMakie and saves figures to `../images/`. Requires the
`gh` CLI authenticated as a BioJulia admin/collaborator (needed for `starred_at` timestamps) and
the Julia deps in `code/Project.toml`. Re-run the `.qmd` in Quarto to regenerate the plots; this is
a one-off data-generation step, not wired into any build command.

## Deployment

`.github/workflows/preview.yml` builds a PDF + title-slide PNG on every push/PR and comments the
artifact link on PRs. `.github/workflows/release.yml` does the same plus a full source archive,
triggered by creating a GitHub release.
