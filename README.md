# 🌾 Glute Diary

> AI-powered mobile companion for people with gluten intolerance, celiac disease, wheat sensitivity, IBS, and digestive issues.
>
> **Three core features. Zero friction. Medical-grade trust.**
>
> 1. 📸 **AI Food Scanner** — photo, label, or barcode → instant gluten risk + macros
> 2. 2. 📔 **Smart Food Diary** — log a meal in under 10 seconds
>    3. 3. 🧠 **AI Symptom Analyzer** — detects your personal trigger patterns over time
>      
>       4. ---
>      
>       5. ## Status
>      
>       6. 🚧 Pre-development. Spec complete. See `/docs/PRD.md` for full product requirements.
>
> ## Tech Stack
>
> - **Mobile:** React Native + Expo (SDK 51+)
> - - **State:** Zustand + TanStack Query + WatermelonDB (offline-first)
>   - - **Backend:** Supabase (Postgres, Auth, Storage, Edge Functions)
>     - - **AI Vision:** Gemini 2.5 Flash (primary), GPT-4o (fallback)
>       - - **OCR:** Google Cloud Vision API
>         - - **Nutrition data:** Open Food Facts → USDA FoodData Central → Spoonacular
>           - - **Payments:** RevenueCat
>            
>             - ## Repository Structure
>            
>             - ```
>               glute-diary/
>               ├── app/                  # Expo React Native app
>               ├── api/                  # AI orchestration backend
>               ├── supabase/             # Database migrations + Edge Functions
>               ├── docs/
>               │   ├── PRD.md            # Full product requirements document
>               │   ├── data-model.sql    # Postgres schema
>               │   └── gluten-blocklist.json
>               └── README.md
>               ```
>
> ## Disclaimer
>
> Glute Diary is an informational tool, **not a medical device**. Always verify ingredients with restaurant staff and packaging. Consult your physician for medical advice.
>
> ## License
>
> MIT
> 
