-- ============================================
-- AI Game Lab · Boss Level Leaderboard
-- ============================================
-- Run this ONCE in the Supabase SQL Editor:
--   https://supabase.com/dashboard/project/pakyudrjcezmasapvwgv/sql/new
-- Paste the entire file and hit RUN.
-- ============================================

CREATE TABLE IF NOT EXISTS leaderboard (
  id BIGSERIAL PRIMARY KEY,
  game TEXT NOT NULL,
  player TEXT NOT NULL,
  score INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS leaderboard_game_score_idx
  ON leaderboard (game, score DESC);

CREATE INDEX IF NOT EXISTS leaderboard_score_idx
  ON leaderboard (score DESC);

ALTER TABLE leaderboard ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anyone can read"  ON leaderboard;
DROP POLICY IF EXISTS "anyone can write" ON leaderboard;

CREATE POLICY "anyone can read"  ON leaderboard FOR SELECT TO anon USING (true);
CREATE POLICY "anyone can write" ON leaderboard FOR INSERT TO anon WITH CHECK (true);

-- Quick smoke test (optional, you can delete the row after):
-- INSERT INTO leaderboard (game, player, score) VALUES ('test', 'tutor', 1);
-- SELECT * FROM leaderboard ORDER BY score DESC LIMIT 5;
