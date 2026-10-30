# Food for the Family

Free, no-domain family food tracker. Static site (index.html) + free Supabase database.

## Go live (about 10 minutes, no cost)

1. **Supabase** (new project, or your existing one — tables are prefixed `ffl_`):
   SQL Editor → paste all of `setup.sql` → Run.
2. **Google login** (free):
   a. console.cloud.google.com -> new project -> APIs & Services -> OAuth consent screen (External; add the family emails as Test users) -> Credentials -> Create OAuth client ID -> Web application.
   b. Authorised redirect URI: `https://<project-ref>.supabase.co/auth/v1/callback`. Copy the Client ID and Secret.
   c. Supabase -> Authentication -> Providers -> Google -> enable, paste both.
   d. Supabase -> Authentication -> URL Configuration: Site URL = your GitHub Pages link; add it to Redirect URLs too.
   e. Test users to add in Google: vasudev.nathan@gmail.com, alampas@gmail.com, lakshmanan.vasudev@gmail.com, vmeenakshi.vasudev@gmail.com (already listed in `setup.sql`).
3. Project Settings → API → copy **Project URL** and the **anon public** key into `config.js`.
   (Copy the whole key; a truncated key causes login-style failures.)
4. **GitHub Pages**: create a *public* repo with a long random name (e.g. `ffl-k7q2x9m4p8`),
   upload `index.html` and `config.js`, then Settings → Pages → Deploy from branch `main` / root.
   Your link: `https://<your-username>.github.io/ffl-k7q2x9m4p8/`
5. Open the link on each phone, pick "I am…" at top right, and use "Add to Home Screen".

Open the link without step 2 and it runs in demo mode (data stays on that phone only).

## Notes
- Sign-in is Google only and limited to the emails in `ffl_family_emails`; the database itself refuses anyone else, so a leaked link is useless. To add or remove a person, edit that table in Supabase.
- Targets are estimates (Mifflin-St Jeor / Schofield energy, ICMR-NIN style RDAs), not medical advice.
- Food values are approximate per serving; edit any food in the Foods tab to match your recipe.
