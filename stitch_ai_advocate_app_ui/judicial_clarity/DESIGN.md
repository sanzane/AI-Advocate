---
name: Judicial Clarity
colors:
  surface: '#fbf9f4'
  surface-dim: '#dbdad5'
  surface-bright: '#fbf9f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3ee'
  surface-container: '#f0eee9'
  surface-container-high: '#eae8e3'
  surface-container-highest: '#e4e2dd'
  on-surface: '#1b1c19'
  on-surface-variant: '#45474c'
  inverse-surface: '#30312e'
  inverse-on-surface: '#f2f1ec'
  outline: '#75777d'
  outline-variant: '#c5c6cd'
  surface-tint: '#555e73'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#121c2e'
  on-primary-container: '#7a849a'
  inverse-primary: '#bdc6df'
  secondary: '#515f78'
  on-secondary: '#ffffff'
  secondary-container: '#d2e0ff'
  on-secondary-container: '#55637d'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#001356'
  on-tertiary-container: '#5a79ff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d9e2fc'
  primary-fixed-dim: '#bdc6df'
  on-primary-fixed: '#121c2e'
  on-primary-fixed-variant: '#3d475b'
  secondary-fixed: '#d6e3ff'
  secondary-fixed-dim: '#b9c7e5'
  on-secondary-fixed: '#0d1c32'
  on-secondary-fixed-variant: '#394760'
  tertiary-fixed: '#dde1ff'
  tertiary-fixed-dim: '#b9c3ff'
  on-tertiary-fixed: '#001356'
  on-tertiary-fixed-variant: '#0035be'
  background: '#fbf9f4'
  on-background: '#1b1c19'
  surface-variant: '#e4e2dd'
typography:
  display-sm:
    fontFamily: Inter
    fontSize: 1.75rem
    fontWeight: '700'
    lineHeight: 2.25rem
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 1.5rem
    fontWeight: '600'
    lineHeight: 2rem
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Inter
    fontSize: 1.25rem
    fontWeight: '600'
    lineHeight: 1.75rem
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Inter
    fontSize: 1.125rem
    fontWeight: '600'
    lineHeight: 1.5rem
  title-md:
    fontFamily: Inter
    fontSize: 1rem
    fontWeight: '600'
    lineHeight: 1.5rem
  body-lg:
    fontFamily: Inter
    fontSize: 1rem
    fontWeight: '400'
    lineHeight: 1.625rem
  body-md:
    fontFamily: Inter
    fontSize: 0.875rem
    fontWeight: '400'
    lineHeight: 1.375rem
  body-sm:
    fontFamily: Inter
    fontSize: 0.8125rem
    fontWeight: '400'
    lineHeight: 1.25rem
  label-lg:
    fontFamily: Inter
    fontSize: 0.875rem
    fontWeight: '500'
    lineHeight: 1.25rem
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 0.75rem
    fontWeight: '600'
    lineHeight: 1rem
    letterSpacing: 0.04em
  label-legal:
    fontFamily: Inter
    fontSize: 0.6875rem
    fontWeight: '600'
    lineHeight: 0.875rem
    letterSpacing: 0.06em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 0.75rem
  margin: 1.25rem
  margin-compact: 1rem
  margin-expanded: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system establishes an authoritative, precise, and approachable interface for Indian jurisprudence and legal research on Android. The visual identity reflects the solemnity and intellectual rigor of the law while dismantling its impenetrable density through modern mobile clarity. 

The aesthetic is built on **Modern Precision Minimalism** blended with strict **Material 3 architectural cues**. We explicitly discard the cliché "AI aesthetic"—there are no luminous violet gradients, holographic meshes, sci-fi glowing borders, or faux-official ministerial insignia. The credibility of the assistant is earned through typographical balance, deep deliberate navy tones, crisp structural lines, and generous calm whitespace.

The emotional experience must communicate:
- **Intellectual Trust:** High readability, structured legal taxonomy, and objective informational hierarchy.
- **Cognitive Relief:** The warm ivory background softens the clinical harshness of raw white screens during protracted case-law reading and analysis.
- **Decisive Navigation:** Purposeful elevation, clear tap states, and ergonomic thumb-zone placements designed specifically for standard high-density Android mobile displays (~393×852).

## Colors

The palette balances authoritative weight with long-form reading comfort, adhering to Indian courtroom dignity and contemporary digital standards:

- **Deep Sovereign Navy (`#101A2C`):** Primary tone for top-level headers, primary actions, and key navigation surfaces.
- **Secondary Slate Navy (`#1B2940`):** Secondary brand tone used for secondary app bars, section groupings, and contextual chip selections.
- **Cobalt Blue (`#4263EB`):** High-precision accent color. Used exclusively for focal points: interactive queries, key citation links, primary CTA buttons, and active bottom navigation states.
- **Warm Ivory Background (`#F7F5F0`):** Off-white base canvas canvas tone (`Scaffold` background). Eliminates optical fatigue during sustained reading of constitutional texts and judgment transcripts.
- **Pure Surface White (`#FFFFFF`):** High-level elevation tier for Cards, BottomSheets, and input containers to lift content off the ivory ground cleanly.
- **Primary Text (`#182230`):** High-contrast deep ink for maximum legibility in judgments and body copy.
- **Secondary Text (`#697386`):** Muted slate for metadata, bench citations, act sections, and timestamps.
- **Subtle Outline (`#E5E7EB`):** Hairline 1px structural separation.
- **Functional Semantics:**
  - **Success / Precedent Upheld (`#18866B`):** Restrained forest green for favorable citations, active statutes, and valid cross-references.
  - **Warning / Overruled / Cautionary (`#B7791F`):** Deep amber-ochre for disputed precedents, repealed acts, and pending scrutiny.

## Typography

The typography system relies on **Inter**, configured for legal precision, high legibility on standard AMOLED and LCD mobile panels, and structured information grouping.

- **Legibility Rules:**
  - Case names (e.g., *Kesavananda Bharati v. State of Kerala*) must always be set in `title-md` or `body-lg` using italicized emphasis, with secondary court tags in `label-legal`.
  - Body judgment summaries use `body-md` with an expanded line-height (`1.375rem`) to prevent crowding during scanning of lengthy multi-clause summaries.
- **Legal Tags & Badges (`label-legal`):**
  - All statutory references (e.g., `SEC. 482 CRPC`, `ART. 21`, `IPC § 302`) use all-caps tracking (`+0.06em`) at `11px` to differentiate legislative references from editorial notes.

## Layout & Spacing

The layout is anchored to a standard **8dp spatial grid** (with a secondary 4dp sub-grid for icons and fine typography alignment), optimized for a default viewport of **393 × 852 dp**.

- **Horizontal Margins:** 
  - A default gutter margin of `20dp` (`1.25rem`), adaptable to `16dp` on screens smaller than 360dp width, ensuring card boundaries never feel cramped against the screen edge.
- **Vertical Spacing Model:**
  - Top AppBar to first content block: `space-md` (`16dp`).
  - Section-to-section gap: `space-xl` (`32dp`).
  - Interior card content padding: `space-md` (`16dp`) standard, `space-lg` (`24dp`) for primary analysis blocks.
- **Thumb Zone Design:**
  - AI prompt bars, quick filters, and primary CTAs must remain within the bottom 35% of the viewport.
  - Floating action targets maintain minimum 48×48dp physical touch areas.

## Elevation & Depth

Elevation follows Material 3 principles translated through calm, non-skeuomorphic layering. We avoid thick drop-shadows and flashy ambient blurs in favor of tonal differentiation supported by razor-sharp micro-borders.

- **Level 0 (Canvas Base):** Warm Ivory (`#F7F5F0`). Flat, non-elevated.
- **Level 1 (Card & Section Containers):** Pure White (`#FFFFFF`) with a 1px solid border in `#E5E7EB`. Shadow: `0px 1px 3px rgba(16, 26, 44, 0.04)`.
- **Level 2 (Interactive Floating Elements, Chips, Menus):** Pure White (`#FFFFFF`) with a 1px solid border in `#E5E7EB`. Shadow: `0px 4px 12px rgba(16, 26, 44, 0.06)`.
- **Level 3 (Modal BottomSheets & Dialogs):** Pure White (`#FFFFFF`). Shadow: `0px -4px 20px rgba(16, 26, 44, 0.08)`. Scrim overlay: `#101A2C` at 32% opacity.
- **Rule on Blur & Translucency:** Transparent backdrops are strictly restricted to the sticky App Bar (`#F7F5F0` at 92% with `backdrop-filter: blur(8px)`) to keep case headings visible while scrolling.

## Shapes

The design system employs a **Rounded** aesthetic (`roundedness: 2`), tailored for Material 3 surfaces on Android:

- **Cards & Case Blocks:** `16px` (`rounded-lg`) corner radii create approachable yet architecturally stable cards.
- **Large Dialogue / Query Panels:** `20px` corner radii for contextual bottom-docked legal input boxes.
- **Action Buttons:** `12px` to `14px` border radius, balancing friendly contact with a serious presence.
- **Filter Chips & Statutory Badges:** `8px` (`rounded-sm`) to maintain a clean, compact appearance for data-heavy tags.
- **Bottom Sheets:** Top-left and top-right corners rounded to `24px` (`rounded-xl`).

## Components

### Buttons
- **Primary Legal CTA (e.g., "Analyze Precedent", "Draft Notice"):**
  - Height: `50dp` (within 48-54dp spec).
  - Background: Deep Navy (`#101A2C`) or Cobalt Blue (`#4263EB`).
  - Text: Label Large (`14px`, 600 weight, `#FFFFFF`).
  - Corners: `12px`.
  - Iconography: 20dp outlined stroke icon placed leading the text.
- **Secondary Button:**
  - Height: `50dp`.
  - Background: Surface White (`#FFFFFF`), 1px border `#E5E7EB`.
  - Text: `#101A2C`.

### Cards & Case Briefs
- **Case Summary Card:**
  - Background: `#FFFFFF`.
  - Border: 1px `#E5E7EB`. Corner radius: `16dp`.
  - Padding: `16dp`.
  - Header: Contains Court badge (e.g., "SC INDIA", `label-legal`), year, and bookmark icon.
  - Title: Case title in `title-md` (`#182230`).
  - Bench & Coram: In `body-sm` (`#697386`).
  - Summary: Max 3 lines in `body-md`, ending with ellipsis.

### Chips & Legal Filters
- **Statute / Court Chips:**
  - Height: `32dp`.
  - Inactive: Background `#FFFFFF`, 1px border `#E5E7EB`, text `#697386`.
  - Selected: Background `#101A2C`, text `#FFFFFF`, 0px border.
  - Status Indicators (Upheld / Overruled): Left-aligned 6dp solid dot in `#18866B` or `#B7791F`.

### Input Fields & Search / Query Bar
- **AI Prompt Box (Docked or Inline):**
  - Height: `54dp`.
  - Background: `#FFFFFF`.
  - Border: 1px `#E5E7EB`, transitions to 1.5px `#4263EB` upon focus.
  - Corner radius: `16dp`.
  - Placeholder: "Ask about sections, precedents, or draft grounds..." in `#697386`.
  - Trailing Action: 36×36dp circular Cobalt Blue button with an upward arrow or spark symbol.

### Lists & Citations (ListTile)
- **Citations List Item:**
  - Min height: `64dp`.
  - Padding: `12dp 16dp`.
  - Leading: Monogram avatar (e.g., "AIR", "SCC") inside a 40dp rounded-square container (`#F7F5F0`).
  - Title: `title-md` bold text.
  - Subtitle: `body-sm` indicating section tags and date.
  - Trailing: Subtle chevron-right icon in `#697386`.

### Navigation
- **Material 3 Navigation Bar (Bottom):**
  - Background: `#FFFFFF` with top 1px border `#E5E7EB`.
  - Active Icon: `#4263EB` with a soft cobalt tint pill container (`#4263EB` at 10% opacity).
  - Inactive Icon: `#697386`.
  - Labels: `label-md` (`12px`).