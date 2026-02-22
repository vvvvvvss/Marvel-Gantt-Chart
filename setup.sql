-- ============================================================
-- MARVEL R&D LAB — BATCH TRACKER
-- Supabase Database Setup Script
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ============================================================

-- 1. Create the batches table
CREATE TABLE IF NOT EXISTS public.batches (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name        TEXT NOT NULL,
  start_date  DATE NOT NULL,
  color       TEXT NOT NULL DEFAULT '#2ec4b6',
  levels      JSONB NOT NULL DEFAULT '[]',
  created_by  TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security
ALTER TABLE public.batches ENABLE ROW LEVEL SECURITY;

-- 3. Policy: any authenticated user can READ batches
CREATE POLICY "Authenticated users can read batches"
  ON public.batches
  FOR SELECT
  TO authenticated
  USING (true);

-- 4. Policy: any authenticated user can INSERT batches
CREATE POLICY "Authenticated users can insert batches"
  ON public.batches
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- 5. Policy: users can DELETE their own batches
--    (Admins can delete all — handled in app logic via ADMIN_EMAILS list)
CREATE POLICY "Users can delete their own batches"
  ON public.batches
  FOR DELETE
  TO authenticated
  USING (created_by = auth.jwt() ->> 'email');

-- 6. Enable Realtime for live updates across all coordinators
ALTER PUBLICATION supabase_realtime ADD TABLE public.batches;

-- ============================================================
-- DONE! Your database is ready.
-- ============================================================