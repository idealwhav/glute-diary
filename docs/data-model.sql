-- Glute Diary - Postgres / Supabase schema (v1)
  -- Apply via supabase migration or psql \\i.

  CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE gluten_risk AS ENUM ('safe','caution','unsafe');
CREATE TYPE meal_source AS ENUM ('photo','barcode','label','voice','manual');
CREATE TYPE meal_type AS ENUM ('breakfast','lunch','dinner','snack');

CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           TEXT UNIQUE NOT NULL,
    created_at      TIMESTAMPTZ DEFAULT now(),
    dietary_profile JSONB DEFAULT '{}'::jsonb
  );

CREATE TABLE meals (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID REFERENCES users(id) ON DELETE CASCADE,
    photo_url    TEXT,
    name         TEXT NOT NULL,
    ingredients  JSONB DEFAULT '[]'::jsonb,
    calories     INT,
    protein_g    NUMERIC(6,2),
    carbs_g      NUMERIC(6,2),
    fat_g        NUMERIC(6,2),
    gluten_risk  gluten_risk NOT NULL DEFAULT 'caution',
    confidence   INT CHECK (confidence BETWEEN 0 AND 100),
    ai_reasoning JSONB,
    source       meal_source NOT NULL DEFAULT 'manual',
    meal_type    meal_type,
    eaten_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    location     TEXT,
    notes        TEXT,
    created_at   TIMESTAMPTZ DEFAULT now()
  );
CREATE INDEX idx_meals_user_eaten ON meals(user_id, eaten_at DESC);

CREATE TABLE symptoms (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID REFERENCES users(id) ON DELETE CASCADE,
    type        TEXT NOT NULL,
    severity    INT CHECK (severity BETWEEN 1 AND 10),
    duration_min INT,
    notes       TEXT,
    mood        INT,
    energy      INT,
    bristol     INT CHECK (bristol BETWEEN 1 AND 7),
    logged_at   TIMESTAMPTZ NOT NULL DEFAULT now()
  );
CREATE INDEX idx_symptoms_user_logged ON symptoms(user_id, logged_at DESC);

CREATE TABLE safe_foods (
    user_id        UUID REFERENCES users(id) ON DELETE CASCADE,
    food_signature TEXT NOT NULL,
    tolerance_score NUMERIC(4,2),
    sample_count   INT DEFAULT 0,
    last_reaction_at TIMESTAMPTZ,
    PRIMARY KEY (user_id, food_signature)
  );

CREATE TABLE triggers (
    user_id          UUID REFERENCES users(id) ON DELETE CASCADE,
    ingredient       TEXT NOT NULL,
    suspicion_score  NUMERIC(4,2),
    exposure_count   INT DEFAULT 0,
    reaction_count   INT DEFAULT 0,
    avg_latency_min  INT,
    PRIMARY KEY (user_id, ingredient)
  );

CREATE TABLE insights (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      UUID REFERENCES users(id) ON DELETE CASCADE,
    type         TEXT NOT NULL,
    payload      JSONB,
    generated_at TIMESTAMPTZ DEFAULT now(),
    dismissed    BOOLEAN DEFAULT FALSE
  );

-- Row Level Security
  ALTER TABLE meals     ENABLE ROW LEVEL SECURITY;
ALTER TABLE symptoms  ENABLE ROW LEVEL SECURITY;
ALTER TABLE safe_foods ENABLE ROW LEVEL SECURITY;
ALTER TABLE triggers   ENABLE ROW LEVEL SECURITY;
ALTER TABLE insights   ENABLE ROW LEVEL SECURITY;

CREATE POLICY "own meals"     ON meals     USING (user_id = auth.uid());
CREATE POLICY "own symptoms"  ON symptoms  USING (user_id = auth.uid());
CREATE POLICY "own safe"      ON safe_foods USING (user_id = auth.uid());
CREATE POLICY "own triggers"  ON triggers  USING (user_id = auth.uid());
CREATE POLICY "own insights"  ON insights  USING (user_id = auth.uid());
