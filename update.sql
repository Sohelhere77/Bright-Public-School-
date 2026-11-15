-- Supabase > SQL Editor mein pura paste karke Run karein (schema.sql ke BAAD)
create table staff(
  user_id uuid primary key references auth.users on delete cascade,
  email text unique not null,
  name text, post text,
  access text not null default 'staff' check (access in ('owner','admin','teacher','staff')),
  created_at timestamptz default now());

insert into staff(user_id,email,name,post,access)
select a.user_id,u.email,'Owner','Owner',a.role from admins a join auth.users u on u.id=a.user_id;

create or replace function is_admin() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from staff where user_id=auth.uid() and access in ('owner','admin')) $$;
create or replace function is_owner() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from staff where user_id=auth.uid() and access='owner') $$;
create function is_teacher() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from staff where user_id=auth.uid() and access in ('owner','admin','teacher')) $$;

drop table admins;

alter table staff enable row level security;
create policy "staff read" on staff for select using (user_id=auth.uid() or is_admin());

create policy "teacher read" on students for select using (is_teacher());
create policy "teacher all" on student_attendance for all using (is_teacher()) with check (is_teacher());
create policy "teacher all" on notices for all using (is_teacher()) with check (is_teacher());

create table site_settings(key text primary key, value text, updated_at timestamptz default now());
alter table site_settings enable row level security;
create policy "public read" on site_settings for select using (true);
create policy "admin write" on site_settings for all using (is_admin()) with check (is_admin());
