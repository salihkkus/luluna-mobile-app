---
name: Luluna Design System
colors:
  surface: '#faf8fe'
  surface-dim: '#dad9de'
  surface-bright: '#faf8fe'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f3f8'
  surface-container: '#efedf2'
  surface-container-high: '#e9e7ec'
  surface-container-highest: '#e3e2e7'
  on-surface: '#1a1b1f'
  on-surface-variant: '#44474f'
  inverse-surface: '#2f3034'
  inverse-on-surface: '#f1f0f5'
  outline: '#747780'
  outline-variant: '#c4c6d0'
  surface-tint: '#455e92'
  primary: '#455e92'
  on-primary: '#ffffff'
  primary-container: '#abc4ff'
  on-primary-container: '#375084'
  inverse-primary: '#aec6ff'
  secondary: '#436468'
  on-secondary: '#ffffff'
  secondary-container: '#c3e6eb'
  on-secondary-container: '#47686c'
  tertiary: '#79590a'
  on-tertiary: '#ffffff'
  tertiary-container: '#e9be69'
  on-tertiary-container: '#694c00'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#aec6ff'
  on-primary-fixed: '#001a43'
  on-primary-fixed-variant: '#2c4678'
  secondary-fixed: '#c6e9ee'
  secondary-fixed-dim: '#aacdd2'
  on-secondary-fixed: '#001f23'
  on-secondary-fixed-variant: '#2b4c50'
  tertiary-fixed: '#ffdea3'
  tertiary-fixed-dim: '#ecc06b'
  on-tertiary-fixed: '#261900'
  on-tertiary-fixed-variant: '#5d4200'
  background: '#faf8fe'
  on-background: '#1a1b1f'
  surface-variant: '#e3e2e7'
typography:
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Lexend
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 26px
  body-md:
    fontFamily: Lexend
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-lg:
    fontFamily: Lexend
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Lexend
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-margin: 20px
  touch-target-min: 48px
---

## Brand & Style

This design system is engineered to provide a sanctuary of calm for children with autism. The brand personality is gentle, patient, and encouraging, prioritizing sensory-friendly interactions that reduce cognitive load and anxiety. 

The aesthetic blends **Soft Minimalism** with **Tactile Warmth**. Drawing from Apple’s clarity and Material 3’s expressive shapes, the interface uses generous whitespace and a "pill-like" organic geometry. Visual elements appear soft and approachable, avoiding sharp edges or aggressive transitions. The emotional response is one of safety and predictability, utilizing subtle depth and physical metaphors to make the digital environment feel tangible and navigable.

## Colors

The palette is rooted in low-arousal pastel tones to ensure accessibility for neurodivergent users. 
- **Primary (Soft Blue):** Used for main actions and focus states, evoking a sense of serenity.
- **Secondary (Mint Green):** Applied to success states and secondary navigational elements.
- **Accent (Pastel Pink):** Reserved for celebratory moments, badges, or "delight" features.
- **Neutral (Off-White & Slate):** The background is slightly tinted to reduce screen glare, while the text provides high contrast without the harshness of pure black.

Avoid high-saturation gradients; instead, use subtle linear transitions between monochromatic tints to add depth without visual noise.

## Typography

Typography focuses on maximum legibility and friendliness. 
- **Headlines:** Use **Plus Jakarta Sans** (as a high-quality alternative to Poppins with superior rendering) for its distinctive rounded terminals and open counters.
- **Body & Labels:** Use **Lexend**, a font specifically designed to reduce visual stress and improve reading performance for neurodivergent readers.

Maintain generous line heights to prevent "crowding" of text. All headers should use sentence case to feel more conversational and less formal.

## Layout & Spacing

The layout follows a **Fluid Grid** model with significant emphasis on "Safe Areas" to prevent accidental triggers. 
- **Margins:** A standard 20px side margin ensures content does not feel cramped against the bezel.
- **Vertical Rhythm:** Elements are separated by large gaps (24px+) to create a clear visual hierarchy and give the eyes room to rest.
- **Touch Targets:** Every interactive element must meet a minimum 48x48px footprint, though 56px is preferred for primary educational buttons to accommodate varying motor skill levels.
- **Adaptive Reflow:** On tablets, the system transitions to a multi-pane layout to avoid excessively long line lengths, maintaining a maximum content width of 600px for reading comfort.

## Elevation & Depth

This design system avoids harsh dropshadows in favor of **Ambient Tonal Depth**. 
- **Shadows:** Use extremely diffused shadows with a 10-15% opacity of the primary or secondary color rather than black. This "tinted shadow" makes elements feel like they are floating gently above the surface.
- **Tonal Layers:** Elevation is primarily communicated through color shifts. A "Surface" card is white, while the "Background" is off-white (#F8F9FA).
- **Subtle Gradients:** Buttons use a very soft top-to-bottom linear gradient (2% darkening) to suggest a convex, pressable surface, enhancing the tactile affordance.

## Shapes

The shape language is defined by **Extreme Rounding**. All primary containers and buttons use a corner radius of at least 20px, moving toward fully pill-shaped (rounded-xl) for buttons and tags. 

This lack of sharp corners removes visual "threat" and aligns with the organic, friendly nature of the brand. Secondary elements like input fields should mirror this 20px+ radius to maintain a consistent silhouette across the entire interface.

## Components

- **Buttons:** Large, pill-shaped, and high-contrast. Use "Squishy" micro-animations (scale 0.95x) on press to provide immediate haptic and visual feedback.
- **Floating Navigation Bar:** A pill-shaped bar detached from the screen bottom. It uses a soft backdrop blur (glassmorphism) and sits 16px above the home indicator to feel light and easily reachable.
- **Progress Bars:** Thick, rounded tracks with a "Secondary" color fill. Avoid percentages; use icons or simple steps (e.g., "3 of 5") to reduce math-induced stress.
- **Cards:** White backgrounds with a 1px soft border in #E9ECEF and a tinted ambient shadow. No sharp corners.
- **Input Fields:** Oversized height (64px) with large text and thick borders (2px) when focused, using the "Primary" color to clearly signal activity.
- **Interactive Chips:** Used for selection tasks. When selected, they should "pop" with a subtle scale increase and a change to the Primary color background.