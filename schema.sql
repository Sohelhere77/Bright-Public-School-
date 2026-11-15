-- Supabase > SQL Editor mein pura run karein
create table admins(user_id uuid primary key references auth.users on delete cascade, role text not null default 'admin' check (role in ('owner','admin')));
create table students(id uuid primary key default gen_random_uuid(), name text not null, class text not null, roll int, father_name text, mother_name text, phone text, address text, dob date, created_at timestamptz default now());
create table student_attendance(id uuid primary key default gen_random_uuid(), student_id uuid references students on delete cascade, date date not null, status text not null check (status in ('P','A','L')), unique(student_id,date));
create table teachers(id uuid primary key default gen_random_uuid(), name text not null, subject text, qualification text, photo_url text, created_at timestamptz default now());
create table teacher_attendance(id uuid primary key default gen_random_uuid(), teacher_id uuid references teachers on delete cascade, date date not null, status text not null check (status in ('P','A','L')), unique(teacher_id,date));
create table notices(id uuid primary key default gen_random_uuid(), title text not null, body text, date date default current_date, created_at timestamptz default now());
create table gallery(id uuid primary key default gen_random_uuid(), url text not null, caption text, created_at timestamptz default now());

create function is_admin() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from admins where user_id=auth.uid()) $$;
create function is_owner() returns boolean language sql security definer set search_path=public as $$ select exists(select 1 from admins where user_id=auth.uid() and role='owner') $$;

alter table admins enable row level security;
alter table students enable row level security;
alter table student_attendance enable row level security;
alter table teachers enable row level security;
alter table teacher_attendance enable row level security;
alter table notices enable row level security;
alter table gallery enable row level security;

-- sirf Admin: students aur dono attendance
create policy "admin all" on students for all using (is_admin()) with check (is_admin());
create policy "admin all" on student_attendance for all using (is_admin()) with check (is_admin());
create policy "admin all" on teacher_attendance for all using (is_admin()) with check (is_admin());
-- sab dekh sakte hain, sirf Admin badal sakta hai
create policy "public read" on teachers for select using (true);
create policy "admin write" on teachers for all using (is_admin()) with check (is_admin());
create policy "public read" on notices for select using (true);
create policy "admin write" on notices for all using (is_admin()) with check (is_admin());
create policy "public read" on gallery for select using (true);
create policy "admin write" on gallery for all using (is_admin()) with check (is_admin());
-- admins list: admin dekh sakta hai, sirf Owner badal sakta hai
create policy "admin read" on admins for select using (is_admin());
create policy "owner write" on admins for all using (is_owner()) with check (is_owner());

-- PEHLA OWNER (aap): pehle Authentication > Users mein apna email se user banayein, phir:
-- insert into admins(user_id, role) select id,'owner' from auth.users where email='AAPKA@gmail.com';
-- BAAD MEIN PRINCIPAL KO OWNER: unka user banakar:
-- update admins set role='admin' where user_id=(select id from auth.users where email='AAPKA@gmail.com');
-- insert into admins(user_id, role) select id,'owner' from auth.users where email='PRINCIPAL@gmail.com';
