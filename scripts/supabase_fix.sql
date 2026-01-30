DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    CREATE ROLE anon;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    CREATE ROLE authenticated;
  END IF;
END $$;

ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email text;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS first_login boolean DEFAULT false;

ALTER TABLE public.offer_clicks ADD COLUMN IF NOT EXISTS associate_id text;

ALTER TABLE public.associate_social_accounts ADD COLUMN IF NOT EXISTS associate_id text;
ALTER TABLE public.associate_social_accounts ADD COLUMN IF NOT EXISTS social_url text;
ALTER TABLE public.associate_social_accounts ADD COLUMN IF NOT EXISTS follower_count integer DEFAULT 0;
ALTER TABLE public.associate_social_accounts ADD COLUMN IF NOT EXISTS is_verified boolean DEFAULT false;
ALTER TABLE public.associate_social_accounts ALTER COLUMN username DROP NOT NULL;

UPDATE public.associate_social_accounts
SET social_url = profile_url
WHERE social_url IS NULL AND profile_url IS NOT NULL;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'associate_social_accounts_valid_url'
  ) THEN
    ALTER TABLE public.associate_social_accounts
      ADD CONSTRAINT associate_social_accounts_valid_url
      CHECK (social_url LIKE 'http://%' OR social_url LIKE 'https://%');
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'associate_social_accounts_associate_id_platform_key'
  ) THEN
    ALTER TABLE public.associate_social_accounts
      ADD CONSTRAINT associate_social_accounts_associate_id_platform_key
      UNIQUE (associate_id, platform);
  END IF;
END $$;

CREATE INDEX IF NOT EXISTS idx_associate_social_accounts_associate_id
  ON public.associate_social_accounts(associate_id);

REVOKE ALL ON public.store_credentials FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.associate_social_accounts TO authenticated;
GRANT SELECT ON public.associate_social_accounts TO anon;

GRANT EXECUTE ON FUNCTION public.get_associate_earnings(TEXT) TO anon, authenticated;
GRANT EXECUTE ON FUNCTION public.get_associate_clicks_by_offer(TEXT) TO anon, authenticated;
