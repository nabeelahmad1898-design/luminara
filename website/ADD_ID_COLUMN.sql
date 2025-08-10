-- Migration: Add Primary Key ID Column to Products Table
-- Run this in your Supabase SQL Editor to fix the "column products.id does not exist" error

-- 1. First, let's check the current table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 2. Add the primary key id column
-- Using SERIAL for PostgreSQL (auto-incrementing integer)
ALTER TABLE products ADD COLUMN id SERIAL PRIMARY KEY;

-- 3. Verify the column was added
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 4. Check if there are any existing rows that need an id
SELECT COUNT(*) as total_products FROM products;

-- 5. If you have existing products, you can optionally set specific IDs
-- (SERIAL will automatically handle new products)
-- Example: UPDATE products SET id = 1 WHERE name = 'Product Name';

-- 6. Test the table structure
SELECT * FROM products LIMIT 5;
