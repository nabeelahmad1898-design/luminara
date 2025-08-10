-- Simple Fix: Rename ID column to match application expectations
-- The application expects 'id' but the database has 'ID'

-- 1. First, let's see the current column structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
    AND column_name IN ('ID', 'id')
ORDER BY column_name;

-- 2. Check the primary key constraint
SELECT 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
    AND tc.table_name = 'products';

-- 3. Rename the column from "ID" to "id"
ALTER TABLE products RENAME COLUMN "ID" TO id;

-- 4. Verify the column was renamed
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
    AND column_name = 'id';

-- 5. Verify the primary key constraint still works
SELECT 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
    AND tc.table_name = 'products';

-- 6. Test inserting a product
INSERT INTO products (name, brand, category, price) 
VALUES ('Test Product', 'Test Brand', 'Test Category', 99.99);

-- 7. Check if the insert worked
SELECT id, name, brand, category, price 
FROM products 
WHERE name = 'Test Product' 
ORDER BY created_at DESC 
LIMIT 1;

-- 8. Clean up test data
DELETE FROM products WHERE name = 'Test Product';

-- 9. Show final table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;
