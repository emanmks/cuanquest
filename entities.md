# Entities & Schema: CuanQuest

## 1. PlayerProfile (Stats)
Tracks the user's RPG progress.
- `id`: String (UUID)
- `level`: int
- `current_xp`: int
- `hp`: int (Range 0-100)
- `streak_count`: int
- `last_log_date`: DateTime

## 2. Transaction (The Ledger)
- `id`: String (UUID)
- `amount`: double
- `category`: String
- `type`: Enum (Income, Expense)
- `is_essential`: bool (True = Neutral, False = Mana Drain)
- `note`: String
- `created_at`: DateTime

## 3. Reward (The Armory)
Items the user wants to buy in real life.
- `id`: String (UUID)
- `name`: String
- `xp_cost`: int
- `is_unlocked`: bool (Based on logic)
- `image_path`: String

## 4. Quest (Budget Context)
- `id`: String (UUID)
- `monthly_limit`: double
- `current_spending`: double
- `month_year`: String (MM-YYYY)
