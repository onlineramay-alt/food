-- Food for the Family: run once in Supabase > SQL Editor.
-- Tables are prefixed ffl_ so they can share a project with other apps.
-- Login: Google only, and only the emails listed at the bottom.

create table if not exists ffl_members (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  sex text not null check (sex in ('M','F')),
  dob date not null,
  height_cm numeric not null,
  weight_kg numeric not null,
  activity text not null default 'light',
  objective text not null default 'maintain',
  email text,
  created_at timestamptz not null default now()
);

create table if not exists ffl_foods (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  serving text not null,
  kcal numeric not null default 0,
  protein numeric not null default 0,
  carbs numeric not null default 0,
  fibre numeric not null default 0,
  fat numeric not null default 0,
  calcium numeric not null default 0,
  iron numeric not null default 0,
  vita numeric not null default 0,
  vitc numeric not null default 0,
  b12 numeric not null default 0,
  folate numeric not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists ffl_logs (
  id uuid primary key default gen_random_uuid(),
  member_id uuid not null references ffl_members(id) on delete cascade,
  food_id uuid not null references ffl_foods(id) on delete restrict,
  day date not null,
  meal text not null,
  servings numeric not null default 1,
  logged_by text,
  created_at timestamptz not null default now()
);
create index if not exists ffl_logs_day_idx on ffl_logs(day);

-- Only Google accounts listed here can read or write anything.
create table if not exists ffl_family_emails (email text primary key);
alter table ffl_family_emails enable row level security;   -- no policies: not readable from the app

create or replace function ffl_is_family() returns boolean
language sql security definer set search_path = public stable as $$
  select exists (select 1 from ffl_family_emails where lower(email) = lower(auth.jwt() ->> 'email'));
$$;
revoke all on function ffl_is_family() from public, anon;
grant execute on function ffl_is_family() to authenticated;

alter table ffl_members enable row level security;
alter table ffl_foods   enable row level security;
alter table ffl_logs    enable row level security;

drop policy if exists ffl_all on ffl_members;
drop policy if exists ffl_all on ffl_foods;
drop policy if exists ffl_all on ffl_logs;
create policy ffl_all on ffl_members for all to authenticated using (ffl_is_family()) with check (ffl_is_family());
create policy ffl_all on ffl_foods   for all to authenticated using (ffl_is_family()) with check (ffl_is_family());
create policy ffl_all on ffl_logs    for all to authenticated using (ffl_is_family()) with check (ffl_is_family());

grant select, insert, update, delete on ffl_members, ffl_foods, ffl_logs to authenticated;
revoke all on ffl_members, ffl_foods, ffl_logs from anon;

-- The four family Google accounts (add or remove rows later in the Table Editor).
insert into ffl_family_emails (email) values
  ('vasudev.nathan@gmail.com'),
  ('alampas@gmail.com'),
  ('lakshmanan.vasudev@gmail.com'),
  ('vmeenakshi.vasudev@gmail.com')
on conflict do nothing;
