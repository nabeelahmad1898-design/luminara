-- Fix orders status check constraint
-- Run this in your Supabase SQL Editor

-- First, let's see what the current constraint allows
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'orders'::regclass 
AND contype = 'c';

-- Drop the existing status check constraint
ALTER TABLE orders 
DROP CONSTRAINT IF EXISTS orders_status_check;

-- Create a new constraint that allows all the status values we need
ALTER TABLE orders 
ADD CONSTRAINT orders_status_check 
CHECK (status IN ('pending', 'dispatched', 'completed', 'cancelled', 'processing', 'shipped', 'delivered'));

-- Verify the constraint was created
SELECT conname, pg_get_constraintdef(oid) 
FROM pg_constraint 
WHERE conrelid = 'orders'::regclass 
AND contype = 'c';

-- Test the constraint by checking what status values are currently in the table
SELECT DISTINCT status FROM orders;

-- Optional: Update any existing invalid status values to 'pending'
UPDATE orders 
SET status = 'pending' 
WHERE status NOT IN ('pending', 'dispatched', 'completed', 'cancelled', 'processing', 'shipped', 'delivered');
