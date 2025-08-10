-- Simple Fix: Add missing 'id' column to products table
-- The table already has a primary key on 'ID' column, so we just need to add 'id'

-- 1. Check if 'id' column already exists
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'products' 
    AND column_name = 'id';

-- 2. Add 'id' column if it doesn't exist (without PRIMARY KEY constraint)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'products' AND column_name = 'id'
    ) THEN
        ALTER TABLE products ADD COLUMN id SERIAL;
        RAISE NOTICE 'Added id column to products table';
    ELSE
        RAISE NOTICE 'id column already exists in products table';
    END IF;
END $$;

-- 3. Verify the column was added
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
    AND column_name IN ('id', 'ID')
ORDER BY column_name;

-- 4. Test that we can insert a product
INSERT INTO products (name, brand, category, price, id) 
VALUES ('Test Product', 'Test Brand', 'Test Category', 99.99, 999999)
ON CONFLICT (id) DO NOTHING;

-- 5. Check if the insert worked
SELECT id, name, brand, category, price 
FROM products 
WHERE name = 'Test Product' 
ORDER BY created_at DESC 
LIMIT 1;

-- 6. Clean up test data
DELETE FROM products WHERE name = 'Test Product';

-- 7. Show final table structure
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;
