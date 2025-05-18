# Database Index Performance Analysis

## Identified High-Usage Columns

### Users Table

- `email`: Used in login queries and uniqueness checks
- `role`: Filtered for user type-specific operations

### Property Table

- `location`: Frequently used in search filters
- `host_id`: Used in JOIN operations with users
- `pricepernight`: Common in search filters and sorting

### Booking Table

- `start_date`, `end_date`: Used in availability checks
- `status`: Filtered for booking management
- `user_id`, `property_id`: Frequent JOIN operations

## Performance Impact

### Before Indexing

Common queries could require full table scans, especially for:

- User lookups by email
- Property searches by location and price
- Booking date range queries

### After Indexing

1. User queries:
   - Email lookups: O(log n) instead of O(n)
   - Role-based filtering: Improved sort operations

2. Property searches:
   - Location-based queries: Faster geographical searches
   - Price range queries: Optimized range scans

3. Booking operations:
   - Date range queries: Efficient booking availability checks
   - Status filtering: Quick booking status updates

## Monitoring

- Use `EXPLAIN ANALYZE` to verify index usage
- Monitor index size and maintenance overhead
- Regular index optimization may be required

## Best Practices

1. Only index frequently queried columns
2. Consider impact on INSERT/UPDATE operations
3. Regular maintenance of index statistics
4. Monitor index usage patterns

====================================================

### Performance Testing Queries

====================================================

Before adding indexes, run EXPLAIN on critical queries to establish baseline

#### Example 1: Find properties with reviews above 4.0

```sql
EXPLAIN
SELECT p.property_id, p.name, AVG(r.rating) as avg_rating
FROM Property p
JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name
HAVING AVG(r.rating) > 4.0;
```

#### Example 2: Find user booking history with status

```sql
EXPLAIN
SELECT u.first_name, u.last_name, b.start_date, b.end_date, b.status
FROM User u
JOIN Booking b ON u.user_id = b.user_id
WHERE u.email = 'sample@example.com' AND b.status = 'confirmed';
```

#### Example 3: Find properties in a location within price range

```sql
EXPLAIN
SELECT property_id, name, price_per_night
FROM Property
WHERE location LIKE '%New York%' AND price_per_night BETWEEN 100 AND 300
ORDER BY price_per_night;
```

After creating indexes, run the same EXPLAIN queries again to compare execution plans
