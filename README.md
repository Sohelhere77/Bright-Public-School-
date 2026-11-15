# Bright Public School website

Files: index.html (public, Hindi/English), admin.html (staff), config.js, schema.sql

## Setup (ek baar)
1. supabase.com par naya project banayein. SQL Editor mein schema.sql paste karke Run karein.
2. Authentication > Users > Add user: apna email aur password banayein.
   Authentication > Sign In / Providers mein "Allow new users to sign up" band karein.
3. SQL Editor mein chalayein (apna email daalkar):
   insert into admins(user_id, role) select id,'owner' from auth.users where email='AAPKA@gmail.com';
4. Project Settings > API se Project URL aur anon key copy karke config.js mein daalein.
5. GitHub par naya repo banayein, ye saari files upload karein.
6. vercel.com par GitHub se login karein > Add New Project > repo chunein > Deploy (koi setting nahi badalni).

## Principal ko Owner banana
Principal ke email se Authentication > Users mein user banayein, phir schema.sql ke aakhri comments wali 2 lines chalayein.
