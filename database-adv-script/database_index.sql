-- ====================================================
-- AirBnB Database Indexing Strategy
-- ====================================================

-- This file contains index creation commands to optimize
-- query performance for the AirBnB database schema.
-- ====================================================

-- ------------------------------------------------------
-- User Table Indexes
-- ------------------------------------------------------

-- Index on email for login and search operations
CREATE INDEX idx_user_email ON users(email);

-- Index on role for filtering users by role
CREATE INDEX idx_user_role ON users(role);

-- Composite index for name searches (common in user lookups)
CREATE INDEX idx_user_names ON users(last_name, first_name);

-- ------------------------------------------------------
-- Property Table Indexes
-- ------------------------------------------------------

-- Index on host_id for filtering properties by host
CREATE INDEX idx_property_host ON properties(host_id);

-- Index on location for geographical searches
CREATE INDEX idx_property_location ON properties(location);

-- Index on price for price range filtering
CREATE INDEX idx_property_price ON properties(price_per_night);

-- Composite index for sorting by price within location
CREATE INDEX idx_property_loc_price ON properties(location, price_per_night);

-- ------------------------------------------------------
-- Booking Table Indexes
-- ------------------------------------------------------

-- Index on property_id for property booking lookups
CREATE INDEX idx_booking_property ON bookings(property_id);

-- Index on user_id for user booking history
CREATE INDEX idx_booking_user ON bookings(user_id);

-- Index on booking dates for availability checking
CREATE INDEX idx_booking_dates ON bookings(start_date, end_date);

-- Index on status for filtering bookings by status
CREATE INDEX idx_booking_status ON bookings(status);

-- Composite index for user bookings by status
CREATE INDEX idx_booking_user_status ON bookings(user_id, status);

-- ------------------------------------------------------
-- Payment Table Indexes
-- ------------------------------------------------------

-- Index on booking_id for payment lookups
CREATE INDEX idx_payment_booking ON payments(booking_id);

-- Index on payment method for filtering/reporting
CREATE INDEX idx_payment_method ON payments(payment_method);

-- Index on payment date for financial reporting
CREATE INDEX idx_payment_date ON payments(payment_date);

-- ------------------------------------------------------
-- Review Table Indexes
-- ------------------------------------------------------

-- Index on property_id for property review lookups
CREATE INDEX idx_review_property ON reviews(property_id);

-- Index on user_id for user review history
CREATE INDEX idx_review_user ON reviews(user_id);

-- Index on rating for filtering by rating
CREATE INDEX idx_review_rating ON reviews(rating);

-- Composite index for property rating lookups
CREATE INDEX idx_review_property_rating ON reviews(property_id, rating);

-- ------------------------------------------------------
-- Message Table Indexes
-- ------------------------------------------------------

-- Index on sender_id for outbox queries
CREATE INDEX idx_message_sender ON messages(sender_id);

-- Index on recipient_id for inbox queries
CREATE INDEX idx_message_recipient ON messages(recipient_id);

-- Index on sent_at for chronological sorting
CREATE INDEX idx_message_sent_at ON messages(sent_at);

-- Composite index for user conversation history
CREATE INDEX idx_message_conversation ON messages(sender_id, recipient_id, sent_at);

-- ====================================================
-- Performance Testing Queries
-- ====================================================

-- Before adding indexes, run EXPLAIN on critical queries to establish baseline

-- Example 1: Find properties with reviews above 4.0
EXPLAIN ANALYZE
SELECT p.property_id, p.name, AVG(r.rating) as avg_rating
FROM properties AS p
JOIN reviews AS r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name
HAVING AVG(r.rating) > 4.0;

-- Example 2: Find user booking history with status
EXPLAIN ANALYZE
SELECT u.first_name, u.last_name, b.start_date, b.end_date, b.status
FROM users AS u
JOIN bookings AS b ON u.user_id = b.user_id
WHERE u.email = 'sample@example.com' AND b.status = 'confirmed';

-- Example 3: Find properties in a location within price range
EXPLAIN ANALYZE
SELECT property_id, name, price_per_night
FROM properties
WHERE location LIKE '%New York%' AND price_per_night BETWEEN 100 AND 300
ORDER BY price_per_night;

-- After creating indexes, run the same EXPLAIN queries again to compare execution plans

-- ====================================================
-- Index Maintenance
-- ====================================================

-- Monitor index usage (PostgreSQL example)
-- Remove unused indexes (after evaluation period)
-- DROP INDEX IF EXISTS idx_unused_index;