# Glute Diary — Product Requirements Document (PRD) v1.0

## 1. Vision

An intelligent AI companion that helps users with gluten intolerance, celiac disease, wheat sensitivity, IBS, and digestive issues finally understand which foods are hurting them. The app reduces anxiety, accidental gluten exposure, confusion, and manual tracking effort.

## 2. Three Core Features

### Feature 1 — AI Food Scanner
Inputs: photo, image upload, ingredient label scan, nutrition label scan, barcode, voice.
Outputs: food name, ingredients, calories, protein/carbs/fat, gluten risk (safe/caution/unsafe), suspicious ingredients, confidence score, cross-contamination risk.

Performance budget: under 3 seconds end-to-end.

### Feature 2 — Smart Food Diary
Goal: log a meal in under 10 seconds. Stores photo, name, ingredients, macros, gluten risk, timestamp, notes, location, AI confidence. Auto-organizes into breakfast/lunch/dinner/snacks. Supports recents, favorites, templates, autocomplete, swipe actions, voice logging.

Safe Foods Memory: per-user learned tolerance scores. Surfaces messages like "This meal appears safe for you" or "You previously experienced symptoms after similar meals."

### Feature 3 — AI Symptom Analyzer
Logs: bloating, stomach pain, diarrhea, constipation, nausea, fatigue, brain fog, headaches, anxiety, skin reactions, reflux, cramps. Each entry: severity 1–10, duration, notes, timestamp. Plus mood, energy, Bristol stool chart.

Pattern detection (nightly job per user): correlates ingredients to symptoms with lift, exposure count, and median latency. Outputs ranked triggers and calm, non-diagnostic insight strings.

## 3. Tech Stack

- Mobile: React Native + Expo SDK 51+
- - State: Zustand + TanStack Query
  - - Local DB: WatermelonDB / expo-sqlite (offline-first)
    - - Backend: Supabase (Postgres + Auth + Storage + Edge Functions)
      - - AI orchestrator: Cloudflare Workers / Fly.io
        - - Vision AI: Gemini 2.5 Flash primary, GPT-4o fallback
          - - OCR: Google Cloud Vision
            - - Nutrition: Open Food Facts → USDA → Spoonacular
              - - Payments: RevenueCat
               
                - ## 4. Gluten Detection Engine (3 layers)
               
                - 1. Deterministic ingredient blocklist (see gluten-blocklist.json) — exact-token match against canonicalized ingredient list.
                  2. 2. LLM reasoning layer — sends dish + ingredients to Gemini 2.5 Flash with strict JSON schema requesting confirmed gluten, suspected hidden gluten, cross-contamination risk, classification, confidence.
                     3. 3. Confidence calibration — if deterministic and LLM disagree, return CAUTION. Never silently override deterministic UNSAFE.
                       
                        4. ## 5. Cost Model (per 1,000 MAU/month)
                       
                        5. Gemini Flash ~$15, Google Vision OCR ~$45, Spoonacular $29, Supabase Pro $25, infra ~$10. Total ~$125/mo. Target $7.99/mo Pro tier; break-even ~16 paying users per 1,000.
                       
                        6. ## 6. Compliance
                       
                        7. - Onboarding disclaimer: "Glute Diary is an informational tool, not a medical device."
                           - - Avoid claims of diagnosis or treatment.
                             - - GDPR-grade: explicit consent, data export, full account deletion, region-pinned storage.
                               - - Encrypted at rest (Supabase) and in transit (TLS).
                                
                                 - ## 7. UX & Design System
                                
                                 - Palette: bg #FAFAF7 / #0E1413, primary sage #2F6B5E, safe #6FBF8A, caution #E8B341, unsafe #D9534F.
                                 - Type: Inter or SF Pro. 17pt body, 28pt titles, 1.4 line-height.
                                 - Motion: 250ms ease-out, light haptic on save, bloom animation on AI result reveal.
                                 - References: Apple Health, Cara Care, Nerva, Calm, Headspace.
                                
                                 - ## 8. Build Plan (12 weeks)
                                
                                 - W1–2: Expo project, auth, schema, navigation.
                                 - W3–4: Camera + barcode + Gemini + gluten engine v1.
                                 - W5–6: Diary timeline, offline sync, voice logging.
                                 - W7–8: Symptom logger, Bristol chart, dashboard.
                                 - W9–10: Pattern detection job, insights, safe-foods memory.
                                 - W11: Onboarding, paywall, polish, dark mode.
                                 - W12: TestFlight + Play Internal Testing, submit.
                                
                                 - ## 9. Success Metrics
                                
                                 - - Time-to-log a meal: median < 10s.
                                   - - Scan-to-result latency: p95 < 3s.
                                     - - Gluten classification precision: > 95% on labeled test set.
                                       - - D30 retention: > 30% (health apps benchmark).
                                         - - Paying conversion: > 5% of activated users.
                                           - 
