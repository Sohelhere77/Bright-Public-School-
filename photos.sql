-- Supabase > SQL Editor mein paste karke Run karein (photo upload ke liye)
insert into storage.buckets (id, name, public) values ('photos','photos',true) on conflict (id) do nothing;
create policy "photos public read" on storage.objects for select using (bucket_id='photos');
create policy "photos admin upload" on storage.objects for insert with check (bucket_id='photos' and is_admin());
create policy "photos admin delete" on storage.objects for delete using (bucket_id='photos' and is_admin());
