-- Simple and Direct Fix for Products Table ID Column
-- This will properly fix the auto-increment issue

-- 1. First, let's see what we're working with
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
    AND column_name = 'id';

-- 2. Drop the primary key constraint first
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_pkey;

-- 3. Drop the existing ID column
ALTER TABLE products DROP COLUMN IF EXISTS id;

-- 4. Add the ID column back as SERIAL (auto-incrementing)
ALTER TABLE products ADD COLUMN id SERIAL PRIMARY KEY;

-- 5. Test inserting a product
INSERT INTO products (name, brand, category, price) 
VALUES ('Test Product', 'Test Brand', 'Test Category', 99.99);

-- 6. Check if the insert worked
SELECT id, name, brand, category, price 
FROM products 
WHERE name = 'Test Product' 
ORDER BY created_at DESC 
LIMIT 1;

-- 7. Clean up test data
DELETE FROM products WHERE name = 'Test Product';

-- 8. Show final table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 9. Verify the sequence exists and is working
SELECT 
    sequence_name,
    last_value,
    start_value,
    increment_by
FROM products_id_seq;
