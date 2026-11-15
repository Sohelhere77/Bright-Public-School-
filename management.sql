-- Supabase > SQL Editor mein pura paste karke Run karein (update.sql ke BAAD)

-- 1) Staff/teachers ki zyada details + website par kaun dikhe
alter table teachers add column if not exists post text default 'Teacher';
alter table teachers add column if not exists phone text;
alter table teachers add column if not exists address text;
alter table teachers add column if not exists joining_date date;
alter table teachers add column if not exists show_public boolean default true;

-- public ko sirf safe view dikhega (phone/salary nahi)
drop policy if exists "public read" on teachers;
create view teachers_public as select id,name,subject,qualification,photo_url,post,created_at from teachers where show_public;
grant select on teachers_public to anon, authenticated;

-- 2) Owner decide karega kisko Fees / Salary dikhe ya edit kare
alter table staff add column if not exists fees_access text not null default 'none' check (fees_access in ('none','view','edit'));
alter table staff add column if not exists salary_access text not null default 'none' check (salary_access in ('none','view','edit'));
create policy "owner update staff" on staff for update using (is_owner()) with check (is_owner());

create function fees_level() returns text language sql stable security definer set search_path=public as $$
 select case when access='owner' then 'edit' else fees_access end from staff where user_id=auth.uid() $$;
create function salary_level() returns text language sql stable security definer set search_path=public as $$
 select case when access='owner' then 'edit' else salary_access end from staff where user_id=auth.uid() $$;
create function can_see(t text) returns boolean language sql stable security definer set search_path=public as $$
 select coalesce(case when t='student' then fees_level() else salary_level() end,'none') in ('view','edit') $$;
create function can_edit(t text) returns boolean language sql stable security definer set search_path=public as $$
 select coalesce(case when t='student' then fees_level() else salary_level() end,'none') = 'edit' $$;

create policy "fees read" on students for select using (coalesce(fees_level(),'none') in ('view','edit'));
create policy "salary read" on teachers for select using (coalesce(salary_level(),'none') in ('view','edit'));

-- 3) Accounts (auto/manual) aur Ledger (charge / payment / discount)
create table accounts(
  person_type text not null check (person_type in ('student','employee')),
  person_id uuid not null,
  mode text not null default 'auto' check (mode in ('auto','manual')),
  monthly_amount numeric(12,2) not null default 0,
  start_month date,
  primary key (person_type, person_id));

create table ledger(
  id uuid primary key default gen_random_uuid(),
  person_type text not null check (person_type in ('student','employee')),
  person_id uuid not null,
  kind text not null check (kind in ('charge','payment','discount')),
  amount numeric(12,2) not null check (amount > 0),
  month date,
  paid_on date default current_date,
  note text,
  auto boolean not null default false,
  created_by uuid default auth.uid(),
  created_at timestamptz default now());
create unique index ledger_auto_uq on ledger(person_type, person_id, month) where auto;
create index ledger_person on ledger(person_type, person_id);

alter table accounts enable row level security;
alter table ledger enable row level security;
create policy "mgmt read" on accounts for select using (can_see(person_type));
create policy "mgmt write" on accounts for all using (can_edit(person_type)) with check (can_edit(person_type));
create policy "mgmt read" on ledger for select using (can_see(person_type));
create policy "mgmt insert" on ledger for insert with check (can_edit(person_type) and not auto);
create policy "mgmt delete" on ledger for delete using (can_edit(person_type) and not auto);

-- student/teacher delete ho to unka hisaab bhi hat jaye
create function cleanup_person() returns trigger language plpgsql security definer set search_path=public as $$
begin delete from ledger where person_id=old.id; delete from accounts where person_id=old.id; return old; end $$;
create trigger t_clean_s after delete on students for each row execute function cleanup_person();
create trigger t_clean_t after delete on teachers for each row execute function cleanup_person();

-- 4) AUTO: mahine ki aakhri tarikh ko fee/salary apne aap judti hai
create or replace function run_accrual() returns int language plpgsql security definer set search_path=public as $$
declare td date := (now() at time zone 'Asia/Kolkata')::date; r record; m date; c int; n int := 0;
begin
 if auth.uid() is not null and coalesce(fees_level(),'none')='none' and coalesce(salary_level(),'none')='none' then
  raise exception 'no access'; end if;
 for r in select * from accounts where mode='auto' and monthly_amount>0 and start_month is not null loop
  m := date_trunc('month', r.start_month)::date;
  while (m + interval '1 month' - interval '1 day')::date <= td loop
   insert into ledger(person_type,person_id,kind,amount,month,note,auto,created_by)
   values (r.person_type,r.person_id,'charge',r.monthly_amount,m,'Monthly (auto)',true,null) on conflict do nothing;
   get diagnostics c = row_count; n := n + c;
   m := (m + interval '1 month')::date;
  end loop;
 end loop;
 return n;
end $$;
revoke execute on function run_accrual() from public, anon;
grant execute on function run_accrual() to authenticated;

-- 5) Sabka baki hisaab ek saath (list ke liye)
create or replace function balances(t text) returns table(pid uuid, charged numeric, paid numeric, discounted numeric, monthly numeric, mode text)
language sql stable security definer set search_path=public as $$
 select x.pid,
  coalesce(sum(l.amount) filter (where l.kind='charge'),0),
  coalesce(sum(l.amount) filter (where l.kind='payment'),0),
  coalesce(sum(l.amount) filter (where l.kind='discount'),0),
  max(a.monthly_amount), max(a.mode)
 from (select person_id as pid from accounts where person_type=t union select person_id from ledger where person_type=t) x
 left join ledger l on l.person_id=x.pid and l.person_type=t
 left join accounts a on a.person_id=x.pid and a.person_type=t
 where can_see(t)
 group by x.pid $$;
revoke execute on function balances(text) from public, anon;
grant execute on function balances(text) to authenticated;

-- OPTIONAL: roz raat 12 baje (IST) apne aap chalane ke liye
-- Database > Extensions mein pg_cron ON karein, phir ye line chalayein:
-- select cron.schedule('daily-accrual','30 18 * * *','select public.run_accrual()');
