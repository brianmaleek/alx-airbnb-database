-- Ensure the uuid-ossp extension is enabled for UUID generation
-- in PostgreSQL.
-- Enable the uuid-ossp extension
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Insert initial data into the users table
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES
  (uuid_generate_v4(), 'Alice', 'Walker', 'alice@example.com', 'hashed_password_1', '1234567890', 'guest'),
  (uuid_generate_v4(), 'Bob', 'Smith', 'bob@example.com', 'hashed_password_2', '2345678901', 'host'),
  (uuid_generate_v4(), 'Carol', 'Jones', 'carol@example.com', 'hashed_password_3', '3456789012', 'admin');

-- Insert initial data into the properties table
-- Assume Bob is the host
INSERT INTO properties (property_id, host_id, name, description, location, price_per_night)
VALUES
  (uuid_generate_v4(), (SELECT user_id FROM users WHERE email = 'bob@example.com'), 'Sunny Apartment', 'A cozy apartment with ocean views.', 'Mombasa, Kenya', 85.00),
  (uuid_generate_v4(), (SELECT user_id FROM users WHERE email = 'bob@example.com'), 'Nairobi City Loft', 'Modern loft in the heart of Nairobi.', 'Nairobi, Kenya', 120.00);

-- Insert initial data into the bookings table
-- Assume Alice is the guest
-- Alice books Sunny Apartment
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Sunny Apartment'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    '2025-06-01', '2025-06-05',
    85.00 * 4,
    'confirmed'
  ),
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Nairobi City Loft'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    '2025-07-10', '2025-07-12',
    120.00 * 2,
    'pending'
  );

-- Insert initial data into the payments table
INSERT INTO payments (payment_id, booking_id, amount, payment_method)
VALUES
  (
    uuid_generate_v4(),
    (SELECT booking_id FROM bookings WHERE status = 'confirmed'),
    340.00,
    'credit_card'
  );

-- Insert initial data into the reviews table
INSERT INTO reviews (review_id, property_id, user_id, rating, comment)
VALUES
  (
    uuid_generate_v4(),
    (SELECT property_id FROM properties WHERE name = 'Sunny Apartment'),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    5,
    'Amazing stay! Clean, peaceful, and great location.'
  );

-- Insert initial data into the messages table
INSERT INTO messages (message_id, sender_id, recipient_id, message_body)
VALUES
  (
    uuid_generate_v4(),
    (SELECT user_id FROM users WHERE email = 'alice@example.com'),
    (SELECT user_id FROM users WHERE email = 'bob@example.com'),
    'Hi Bob, I’d like to ask if late check-in is possible? Thanks!'
  );

