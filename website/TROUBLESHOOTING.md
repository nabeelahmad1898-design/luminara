# Supabase Integration Troubleshooting Guide

## Common Issues and Solutions

### 1. "Supabase not configured" Error

**Problem**: The dashboard shows "Supabase not configured" and products are saved locally instead of to Supabase.

**Solution**:
1. Go to `supabase-config.html` to configure your Supabase credentials
2. Enter your Supabase project URL and anon key
3. Test the connection using the "Test Connection" button

### 2. "Authentication failed" Error

**Problem**: You get authentication errors when trying to save products.

**Solutions**:
1. **Check if you're logged in**: Make sure you've logged in through the admin panel
2. **Verify user role**: Your user must have 'admin' role in the profiles table
3. **Check RLS policies**: Ensure Row Level Security policies allow your user to access the products table

### 3. "Save failed" Error

**Problem**: Product save operations fail with database errors.

**Solutions**:
1. **Check table schema**: Ensure your products table has the correct structure
2. **Verify column names**: Make sure column names match exactly (case-sensitive)
3. **Check data types**: Ensure data types match the schema (e.g., price as DECIMAL, images as TEXT[])

### 4. "Connection failed" Error

**Problem**: The test connection fails.

**Solutions**:
1. **Verify URL format**: Should be `https://your-project-ref.supabase.co`
2. **Check API key**: Ensure you're using the anon key, not the service role key
3. **Check project status**: Make sure your Supabase project is active and not paused

## Required Database Schema

Run this SQL in your Supabase SQL Editor:

```sql
-- Create products table
CREATE TABLE products (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  brand TEXT NOT NULL,
  category TEXT NOT NULL,
  subcategory TEXT,
  price DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'PKR',
  images TEXT[],
  description TEXT,
  specifications JSONB,
  availability TEXT DEFAULT 'in-stock',
  stock INTEGER DEFAULT 0,
  featured BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policy for authenticated users
CREATE POLICY "Users can manage products" ON products
  FOR ALL USING (auth.role() = 'authenticated');

-- Create profiles table for admin role
CREATE TABLE profiles (
  user_id UUID REFERENCES auth.users(id) PRIMARY KEY,
  role TEXT DEFAULT 'user',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS on profiles
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policy for profiles
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = user_id);
```

## Setup Steps

1. **Create Supabase Project**:
   - Go to [supabase.com](https://supabase.com)
   - Create a new project
   - Note your project URL and anon key

2. **Configure Database**:
   - Go to SQL Editor in your Supabase dashboard
   - Run the schema SQL above

3. **Configure Website**:
   - Go to `supabase-config.html`
   - Enter your project URL and anon key
   - Test the connection

4. **Create Admin User**:
   - Sign up through the admin panel
   - Go to your Supabase dashboard → Authentication → Users
   - Find your user and note the UUID
   - Go to SQL Editor and run:
     ```sql
     INSERT INTO profiles (user_id, role) VALUES ('your-user-uuid', 'admin');
     ```

5. **Test**:
   - Login to the admin panel
   - Try adding a product
   - Check if it appears in your Supabase products table

## Debug Information

The dashboard now includes console logging. Open your browser's developer tools (F12) and check the Console tab for:

- Supabase configuration status
- Authentication status
- Database operation results
- Error details

## Common Error Messages

| Error | Cause | Solution |
|-------|-------|----------|
| `relation "products" does not exist` | Table not created | Run the schema SQL |
| `permission denied` | RLS policy issue | Check user role and policies |
| `invalid input syntax` | Data type mismatch | Check column data types |
| `duplicate key value` | ID already exists | Use a unique ID or let it auto-generate |

## Getting Help

If you're still having issues:

1. Check the browser console for detailed error messages
2. Verify your Supabase project settings
3. Ensure your database schema matches exactly
4. Test with a simple product first (minimal data)

## Fallback Mode

If Supabase is not configured or fails, the system will automatically fall back to local storage. Products will be saved in your browser's localStorage and will persist between sessions on the same device.
