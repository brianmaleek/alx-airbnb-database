-- 1.  Initial query retrieves all bookings along with the user details, property details, and payment details and saves it on performance.sql
EXPLAIN ANALYZE
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price AS booking_total_price,
    b.status AS booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.property_name,
    p.location,
    p.price_per_night,
    pay.payment_id,
    pay.amount AS payment_amount,
    pay.payment_date
FROM
    bookings AS b
JOIN
    users AS u ON b.user_id = u.user_id
JOIN
    properties AS p ON b.property_id = p.property_id
JOIN
    payments AS pay ON b.booking_id = pay.booking_id
WHERE
    b.status = 'confirmed'

-- Create necessary indexes
CREATE INDEX idx_booking_status ON bookings(status);
CREATE INDEX idx_booking_user ON bookings(user_id);
CREATE INDEX idx_booking_property ON bookings(property_id);
CREATE INDEX idx_payment_booking ON payments(booking_id);

-- Optimized query with selective columns
SELECT
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    p.location,
    pay.amount AS payment_amount
FROM
    bookings b
    INNER JOIN users u ON b.user_id = u.user_id
    INNER JOIN properties p ON b.property_id = p.property_id
    LEFT JOIN payments pay ON b.booking_id = pay.booking_id
WHERE
    b.status = 'confirmed'
ORDER BY
    b.start_date DESC;
