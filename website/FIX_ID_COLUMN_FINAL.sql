-- Comprehensive Fix for Products Table ID Column
-- This will properly handle the ID column and make it auto-incrementing

-- 1. First, let's see the current table structure
SELECT column_name, data_type, is_nullable, column_default, is_identity
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 2. Check the current primary key constraint
SELECT 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name,
    tc.constraint_type
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
    AND tc.table_name = 'products';

-- 3. Check if ID column is properly set up as SERIAL/IDENTITY
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
    AND column_name = 'id';

-- 4. Fix the ID column to be properly auto-incrementing
-- First, drop the existing primary key constraint
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_pkey;

-- 5. Modify the ID column to be SERIAL (auto-incrementing)
ALTER TABLE products ALTER COLUMN id SET DATA TYPE SERIAL;

-- 6. If the above doesn't work, try this alternative approach:
-- Create a new sequence and set it as the default for ID
DO $$
BEGIN
    -- Create a sequence if it doesn't exist
    IF NOT EXISTS (SELECT 1 FROM pg_sequences WHERE schemaname = 'public' AND sequencename = 'products_id_seq') THEN
        CREATE SEQUENCE products_id_seq;
    END IF;
    
    -- Set the sequence as the default for the ID column
    ALTER TABLE products ALTER COLUMN id SET DEFAULT nextval('products_id_seq');
    
    -- Set the sequence to start from the current maximum ID + 1
    PERFORM setval('products_id_seq', COALESCE((SELECT MAX(id) FROM products), 0) + 1);
    
    RAISE NOTICE 'ID column configured with sequence';
END $$;

-- 7. Re-add the primary key constraint
ALTER TABLE products ADD CONSTRAINT products_pkey PRIMARY KEY (id);

-- 8. Test inserting a product
INSERT INTO products (name, brand, category, price) 
VALUES ('Test Product', 'Test Brand', 'Test Category', 99.99);

-- 9. Check if the insert worked
SELECT id, name, brand, category, price 
FROM products 
WHERE name = 'Test Product' 
ORDER BY created_at DESC 
LIMIT 1;

-- 10. Clean up test data
DELETE FROM products WHERE name = 'Test Product';

-- 11. Show final table structure
SELECT column_name, data_type, is_nullable, column_default, is_identity
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 12. Verify the sequence is working
SELECT 
    sequence_name,
    last_value,
    start_value,
    increment_by
FROM products_id_seq;
