# Supabase Troubleshooting Guide

## Quick Fixes

### 1. Missing ID Column Error
**Error**: `column products.id does not exist` or `null value in column "ID" of relation "products" violates not-null constraint`

**Solution**: Run the migration in `ADD_ID_COLUMN.sql` in your Supabase SQL Editor.

### 2. RLS Policies
**Error**: `new row violates row-level security policy`

**Solution**: Run the SQL in `RLS_POLICIES.sql` in your Supabase SQL Editor.

### 3. Authentication Issues
**Error**: `Invalid login credentials`

**Solution**: 
- Check if user exists in Supabase Auth
- Verify email/password
- Create user if needed

## Database Schema

### Required Tables

#### 1. `profiles` Table
```sql
CREATE TABLE profiles (
  user_id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  role TEXT DEFAULT 'user',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### 2. `products` Table
```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  brand TEXT,
  category TEXT,
  price DECIMAL(10,2),
  currency TEXT DEFAULT 'USD',
  images TEXT[],
  specifications JSONB,
  availability BOOLEAN DEFAULT true,
  stock INTEGER DEFAULT 0,
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Setup Steps

1. **Configure Supabase**: Use `supabase-config.html` to set your project URL and anon key
2. **Run Database Migrations**: Execute the SQL files in your Supabase SQL Editor
3. **Test Connection**: Use the debug panel (`debug.html`) to verify everything works
4. **Add Admin User**: Update your user's role to 'admin' in the profiles table

## Debug Tools

- **Debug Panel**: `debug.html` - Test all Supabase operations
- **Config Panel**: `supabase-config.html` - Set up Supabase credentials
- **Migration Files**: SQL files to fix database issues
