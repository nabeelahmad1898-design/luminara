-- Fix for Identity Column Issue
-- The 'id' column is already an identity column, so we need to handle it properly

-- 1. Check current table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    is_identity,
    identity_generation,
    identity_start,
    identity_increment
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

-- 3. Check if the identity column is working properly
-- Try to insert a test product without specifying the id
INSERT INTO products (name, brand, category, price) 
VALUES ('Identity Test Product', 'Test Brand', 'stitched', 99.99);

-- 4. Check if the insert worked and what ID was generated
SELECT id, name, brand, category, price 
FROM products 
WHERE name = 'Identity Test Product' 
ORDER BY created_at DESC 
LIMIT 1;

-- 5. Clean up test data
DELETE FROM products WHERE name = 'Identity Test Product';

-- 6. Show the sequence information
SELECT 
    sequence_name,
    last_value,
    start_value,
    increment_by
FROM information_schema.sequences 
WHERE sequence_name LIKE '%products%';

-- 7. Verify the identity column is properly configured
SELECT 
    column_name,
    is_identity,
    identity_generation,
    identity_start,
    identity_increment
FROM information_schema.columns 
WHERE table_name = 'products' 
    AND column_name = 'id';

-- 8. Test another insert to make sure it's working
INSERT INTO products (name, brand, category, price) 
VALUES ('Final Test Product', 'Test Brand', 'stitched', 199.99);

-- 9. Show the final result
SELECT id, name, brand, category, price 
FROM products 
WHERE name = 'Final Test Product';

-- 10. Clean up final test
DELETE FROM products WHERE name = 'Final Test Product';

-- 11. Show final table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default,
    is_identity
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;
