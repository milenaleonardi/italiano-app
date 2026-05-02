-- =====================================================
-- Italiano para Viagem — Supabase Schema
-- Execute no SQL Editor do dashboard Supabase
-- =====================================================

-- Habilita RLS (Row Level Security) para todos
-- Cada usuário só acessa os próprios dados

-- ─── TABELA: user_progress ────────────────────────
CREATE TABLE IF NOT EXISTS public.user_progress (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  favorites   INT[]    DEFAULT '{}',   -- índices de palavras favoritadas
  studied     INT[]    DEFAULT '{}',   -- índices de palavras estudadas
  wrong       INT[]    DEFAULT '{}',   -- índices de palavras erradas no quiz
  streak      INT      DEFAULT 0,
  last_visit  DATE,
  visit_days  INT[]    DEFAULT '{}',   -- dias da semana (0=Dom..6=Sáb) visitados
  quiz_total  JSONB    DEFAULT '{"sessions":0,"correct":0,"total":0}',
  updated_at  TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT user_progress_user_id_key UNIQUE (user_id)
);

ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own progress"
  ON public.user_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress"
  ON public.user_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress"
  ON public.user_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- ─── TABELA: chat_history ─────────────────────────
CREATE TABLE IF NOT EXISTS public.chat_history (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mode        TEXT NOT NULL,           -- 'free' | 'restaurant' | etc.
  messages    JSONB DEFAULT '[]',      -- [{role, parts:[{text}]}]
  updated_at  TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT chat_history_user_mode_key UNIQUE (user_id, mode)
);

ALTER TABLE public.chat_history ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own chat"
  ON public.chat_history FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own chat"
  ON public.chat_history FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own chat"
  ON public.chat_history FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own chat"
  ON public.chat_history FOR DELETE
  USING (auth.uid() = user_id);

-- ─── TABELA: generated_phrases ────────────────────
CREATE TABLE IF NOT EXISTS public.generated_phrases (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  phrases     JSONB DEFAULT '{}',      -- {"word_index": {it, pt}}
  updated_at  TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT generated_phrases_user_id_key UNIQUE (user_id)
);

ALTER TABLE public.generated_phrases ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own phrases"
  ON public.generated_phrases FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own phrases"
  ON public.generated_phrases FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own phrases"
  ON public.generated_phrases FOR UPDATE
  USING (auth.uid() = user_id);

-- ─── FUNÇÃO: updated_at automático ───────────────
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_user_progress_updated_at
  BEFORE UPDATE ON public.user_progress
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_chat_history_updated_at
  BEFORE UPDATE ON public.chat_history
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER set_generated_phrases_updated_at
  BEFORE UPDATE ON public.generated_phrases
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
