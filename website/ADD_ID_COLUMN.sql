-- Migration: Add Primary Key ID Column to Products Table
-- Run this in your Supabase SQL Editor to fix the "column products.id does not exist" error

-- 1. First, let's check the current table structure and primary key
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 2. Check what the current primary key is
SELECT 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
    AND tc.table_name = 'products';

-- 3. Check if 'id' column already exists
SELECT column_name 
FROM information_schema.columns 
WHERE table_name = 'products' 
    AND column_name = 'id';

-- 4. If 'id' column doesn't exist, add it (without PRIMARY KEY constraint)
-- We'll handle the primary key separately
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'products' AND column_name = 'id'
    ) THEN
        ALTER TABLE products ADD COLUMN id SERIAL;
    END IF;
END $$;

-- 5. Now let's see what we have
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 6. Check current primary key again
SELECT 
    tc.constraint_name, 
    tc.table_name, 
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'PRIMARY KEY' 
    AND tc.table_name = 'products';

-- 7. Test the table structure
SELECT * FROM products LIMIT 5;
