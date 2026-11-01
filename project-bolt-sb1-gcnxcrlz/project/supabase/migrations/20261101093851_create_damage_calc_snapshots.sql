/*
# Create damage calculator snapshots

1. New Tables
- `damage_calc_snapshots` stores named calculator setups so the current battle can be saved and restored.
- `id` is the snapshot identifier.
- `name` is the user-facing label.
- `payload` contains the editable attacker, defender, move, and calculation settings as JSON.
- `created_at` records when the snapshot was saved.

2. Security
- Row level security is enabled.
- This first-version calculator has no sign-in screen, so snapshots are intentionally shared through the public calculator workspace.
- Anonymous and authenticated users receive only the CRUD permissions used by the save/load controls.

3. Important Notes
- Snapshot payloads remain flexible JSON so future stat controls can be added without changing the table shape.
- No existing tables or user data are modified.
*/

CREATE TABLE IF NOT EXISTS public.damage_calc_snapshots (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  payload jsonb NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.damage_calc_snapshots ENABLE ROW LEVEL SECURITY;

GRANT SELECT, INSERT, DELETE ON public.damage_calc_snapshots TO anon, authenticated;

DROP POLICY IF EXISTS "Public can read damage snapshots" ON public.damage_calc_snapshots;
CREATE POLICY "Public can read damage snapshots"
  ON public.damage_calc_snapshots FOR SELECT
  TO anon, authenticated
  USING (true);

DROP POLICY IF EXISTS "Public can create damage snapshots" ON public.damage_calc_snapshots;
CREATE POLICY "Public can create damage snapshots"
  ON public.damage_calc_snapshots FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

DROP POLICY IF EXISTS "Public can delete damage snapshots" ON public.damage_calc_snapshots;
CREATE POLICY "Public can delete damage snapshots"
  ON public.damage_calc_snapshots FOR DELETE
  TO anon, authenticated
  USING (true);
