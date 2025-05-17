-- A query to find all properties where the average rating is greater than 4.0 using a subquery.

SELECT
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    (SELECT AVG(r.rating)
    FROM
        reviews AS r
    WHERE
        r.property_id = p.property_id) AS average_rating
FROM
    properties AS p
HAVING
    average_rating > 4.0
ORDER BY
    average_rating DESC;

-- 2. A correlated subquery to find users who have made more than 3 bookings.

SELECT
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (SELECT COUNT(*)
    FROM
        bookings AS b
    WHERE
        b.user_id = u.user_id) AS booking_count
FROM
    users AS u
HAVING
    booking_count > 3
ORDER BY
    u.user_id DESC;
