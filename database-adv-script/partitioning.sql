-- Create partitioned booking table
CREATE TABLE bookings_partitioned (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (start_date);

-- Create quarterly partitions for the current year
CREATE TABLE bookings_q1_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2025-04-01');

CREATE TABLE bookings_q2_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-04-01') TO ('2025-07-01');

CREATE TABLE bookings_q3_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-07-01') TO ('2025-10-01');

CREATE TABLE bookings_q4_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-10-01') TO ('2026-01-01');

-- Create indexes on partitioned table
CREATE INDEX idx_bookings_part_date ON bookings_partitioned(start_date);
CREATE INDEX idx_bookings_part_status ON bookings_partitioned(status);

-- Test query to compare performance
EXPLAIN ANALYZE
SELECT booking_id, property_id, start_date, end_date, total_price
FROM bookings_partitioned
WHERE start_date BETWEEN '2025-04-01' AND '2025-06-30'
AND status = 'confirmed';