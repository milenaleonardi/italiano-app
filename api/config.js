/**
 * /api/config — returns public Supabase credentials to the frontend.
 * SUPABASE_URL and SUPABASE_ANON_KEY are safe to expose (they're "public" keys).
 * Only GEMINI_API_KEY must stay secret (it's never returned here).
 */
export default function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Cache-Control', 'public, max-age=3600');

  const url = process.env.SUPABASE_URL;
  const anonKey = process.env.SUPABASE_ANON_KEY;

  if (!url || !anonKey) {
    return res.status(200).json({ configured: false });
  }

  return res.status(200).json({
    configured: true,
    supabaseUrl: url,
    supabaseAnonKey: anonKey,
  });
}
