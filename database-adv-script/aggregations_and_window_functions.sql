-- 1. Write a query to find the total number of bookings made by each user, using the COUNT function and GROUP BY clause.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings
FROM
    users AS u
LEFT JOIN
    bookings AS b ON u.user_id = b.user_id
GROUP BY
    u.user_id,
    u.first_name,
    u.last_name
ORDER BY
    total_bookings DESC;

-- 2. Use a window function (ROW_NUMBER, RANK) to rank properties based on the total number of bookings they have received.
SELECT
    p.property_id,
    p.name AS property_name,
    p.location,
    COUNT(b.booking_id) AS booking_count,
    ROW_NUMBER () OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank,
    RANK () OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank_with_ties
FROM
    properties AS p
LEFT JOIN
    bookings AS b ON p.property_id = b.property_id
GROUP BY
    p.property_id,
    p.name,
    p.location
ORDER BY
    booking_count DESC;
