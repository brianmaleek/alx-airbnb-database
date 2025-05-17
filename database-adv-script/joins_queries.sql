-- 1.This SQL script demonstrates how to use inner join to retrieve all bookings and the respective users who made those bookings.
SELECT
    b.booking_id,
    b.start_date,
    b.total_price,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM
    bookings AS b
INNER JOIN
    users AS u ON b.user_id = u.user_id;


-- 2. This SQL script demonstrates how to use left join to retrieve all properties and their reviews, including properties that have no reviews.
SELECT
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.description,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM
    properties AS p
LEFT JOIN
    reviews AS r ON p.property_id = r.property_id
ORDER BY
    p.property_id,
    r.created_at DESC;

-- 3. This SQL script demonstrates how to use full outer join to retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status
FROM
    users AS u
FULL OUTER JOIN
    bookings AS b ON u.user_id = b.user_id;