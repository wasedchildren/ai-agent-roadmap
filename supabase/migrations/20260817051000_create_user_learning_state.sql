create table public.user_learning_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  completed_tasks text[] not null default '{}'::text[],
  learning_mode text not null default 'sprint' check (learning_mode in ('sprint', 'steady')),
  active_stage text not null default 'foundation',
  target_date date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.user_learning_state is 'Per-user AI Agent roadmap progress and schedule';
alter table public.user_learning_state enable row level security;

create policy "Users can read their own learning state" on public.user_learning_state
for select to authenticated using ((select auth.uid()) = user_id);
create policy "Users can insert their own learning state" on public.user_learning_state
for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "Users can update their own learning state" on public.user_learning_state
for update to authenticated using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
create policy "Users can delete their own learning state" on public.user_learning_state
for delete to authenticated using ((select auth.uid()) = user_id);

grant usage on schema public to authenticated;
grant select, insert, update, delete on table public.user_learning_state to authenticated;
revoke all on table public.user_learning_state from anon;
