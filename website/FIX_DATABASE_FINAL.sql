-- Comprehensive Database Fix for Luminara Products Table
-- Run this in your Supabase SQL Editor

-- 1. Check current table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    is_identity
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 2. Check current primary key
SELECT 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
    AND tc.table_name = 'products';

-- 3. Check category constraint
SELECT 
    constraint_name,
    check_clause
FROM information_schema.check_constraints 
WHERE constraint_name LIKE '%category%';

-- 4. Fix the id column to be proper SERIAL PRIMARY KEY
-- First, drop existing primary key if it exists
DO $$ 
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE constraint_type = 'PRIMARY KEY' 
        AND table_name = 'products'
    ) THEN
        ALTER TABLE products DROP CONSTRAINT products_pkey;
    END IF;
END $$;

-- 5. Modify id column to be SERIAL (auto-incrementing)
ALTER TABLE products ALTER COLUMN id SET DATA TYPE INTEGER;
ALTER TABLE products ALTER COLUMN id SET DEFAULT nextval('products_id_seq');
ALTER TABLE products ALTER COLUMN id SET NOT NULL;

-- 6. Create sequence if it doesn't exist
CREATE SEQUENCE IF NOT EXISTS products_id_seq;
ALTER TABLE products ALTER COLUMN id SET DEFAULT nextval('products_id_seq');

-- 7. Set the sequence to start from the current max id + 1
SELECT setval('products_id_seq', COALESCE((SELECT MAX(id) FROM products), 0) + 1);

-- 8. Add primary key constraint
ALTER TABLE products ADD CONSTRAINT products_pkey PRIMARY KEY (id);

-- 9. Ensure category constraint exists with correct values
DO $$ 
BEGIN
    -- Drop existing category constraint if it exists
    IF EXISTS (
        SELECT 1 FROM information_schema.check_constraints 
        WHERE constraint_name = 'products_category_check'
    ) THEN
        ALTER TABLE products DROP CONSTRAINT products_category_check;
    END IF;
    
    -- Add new category constraint
    ALTER TABLE products ADD CONSTRAINT products_category_check 
    CHECK (category IN ('stitched', 'pre-custom', 'jewelry'));
END $$;

-- 10. Test the fixes
INSERT INTO products (name, brand, category, price) 
VALUES ('Test Product', 'Test Brand', 'stitched', 99.99);

-- 11. Verify the insert worked
SELECT id, name, brand, category, price 
FROM products 
WHERE name = 'Test Product' 
ORDER BY created_at DESC 
LIMIT 1;

-- 12. Clean up test data
DELETE FROM products WHERE name = 'Test Product';

-- 13. Show final table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    is_identity
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 14. Show final constraints
SELECT 
    tc.constraint_name, 
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name = 'products';

-- 15. Show category constraint
SELECT 
    constraint_name,
    check_clause
FROM information_schema.check_constraints 
WHERE constraint_name = 'products_category_check';
