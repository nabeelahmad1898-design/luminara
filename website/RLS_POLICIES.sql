-- RLS Policies for Luminara Clothing Store
-- Run this SQL in your Supabase SQL Editor to fix authentication issues

-- 1. Enable RLS on products table (if not already enabled)
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- 2. Drop existing policies (if any) to start fresh
DROP POLICY IF EXISTS "products_insert_admin" ON products;
DROP POLICY IF EXISTS "products_update_admin" ON products;
DROP POLICY IF EXISTS "products_delete_admin" ON products;
DROP POLICY IF EXISTS "products_select_all" ON products;

-- 3. Create new policies for authenticated users

-- Policy for INSERT (Adding Products)
CREATE POLICY "Enable insert for authenticated users" ON products
  FOR INSERT 
  WITH CHECK (auth.role() = 'authenticated');

-- Policy for SELECT (Reading Products)
CREATE POLICY "Enable read access for all users" ON products
  FOR SELECT 
  USING (true); -- Allow everyone to read products

-- Policy for UPDATE (Editing Products)
CREATE POLICY "Enable update for authenticated users" ON products
  FOR UPDATE 
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- Policy for DELETE (Deleting Products)
CREATE POLICY "Enable delete for authenticated users" ON products
  FOR DELETE 
  USING (auth.role() = 'authenticated');

-- 4. Verify policies were created
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'products';

-- 5. Test the policies
-- This will show if the policies are working
SELECT 
  tablename,
  rowsecurity,
  CASE 
    WHEN rowsecurity THEN 'RLS Enabled'
    ELSE 'RLS Disabled'
  END as rls_status
FROM pg_tables 
WHERE tablename = 'products';
