# Airbnb Database Schema

## Overview

This project provides a database schema for a property rental platform, similar to Airbnb. The schema is designed to manage users, properties, bookings, payments, reviews, and user-to-user messaging. It ensures data integrity, supports efficient queries, and adheres to best practices in database design.

## Features

1. **Entities**:
   - **User**: Represents platform users (guests, hosts, and admins).
   - **Property**: Represents properties listed by hosts.
   - **Booking**: Represents bookings made by users for properties.
   - **Payment**: Represents payments for bookings.
   - **Review**: Represents user reviews for properties.
   - **Message**: Represents messages exchanged between users.

2. **Data Integrity**:
   - Primary keys (`UUID`) for unique identification.
   - Foreign keys to enforce relationships between entities.
   - `NOT NULL` constraints for required fields.
   - `CHECK` constraints for valid data (e.g., roles, statuses, ratings).

3. **Indexes**:
   - Optimized for frequently queried columns (e.g., email, location, price).
   - Supports efficient searches and joins.

4. **Additional Features**:
   - Default timestamps (`created_at`, `updated_at`) for tracking records.
   - Unique constraints to prevent duplicate entries (e.g., email, reviews).

## Schema Details

### User Entity

- **Attributes**: `user_id`, `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`.
- **Indexes**: Email for faster lookups.
- **Constraints**: Unique email, valid roles (`guest`, `host`, `admin`).

### Property Entity

- **Attributes**: `property_id`, `host_id`, `name`, `description`, `location`, `price_per_night`, `created_at`, `updated_at`.
- **Indexes**: Host ID, location, price.
- **Constraints**: Valid price, valid timestamps.

### Booking Entity

- **Attributes**: `booking_id`, `property_id`, `user_id`, `start_date`, `end_date`, `total_price`, `status`, `created_at`.
- **Indexes**: Property ID, user ID, dates, status.
- **Constraints**: Valid dates, valid statuses (`pending`, `confirmed`, `canceled`).

### Payment Entity

- **Attributes**: `payment_id`, `booking_id`, `amount`, `payment_date`, `payment_method`.
- **Indexes**: Booking ID.
- **Constraints**: Valid amount, valid payment methods (`credit_card`, `paypal`, `stripe`).

### Review Entity

- **Attributes**: `review_id`, `property_id`, `user_id`, `rating`, `comment`, `created_at`.
- **Indexes**: Property ID, user ID, rating.
- **Constraints**: Valid ratings (1-5), unique property-user reviews.

### Message Entity

- **Attributes**: `message_id`, `sender_id`, `recipient_id`, `message_body`, `sent_at`.
- **Indexes**: Sender ID, recipient ID, sent timestamp.
- **Constraints**: Sender and recipient must be different.

## Setup Instructions

1. **Prerequisites**:
   - PostgreSQL database server.
   - Enable the `uuid-ossp` extension for UUID generation:
  
     ```sql
     CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
     ```

2. **Database Creation**:
   - Create a new database:
     ```sql
     CREATE DATABASE airbnb_db;
     ```

3. **Run the Schema Script**:
   - Execute the `schema.sql` file to create the database structure:

     ```bash
     psql -U <username> -d airbnb_db -f [schema.sql](http://_vscodecontentref_/0)
     ```

## Notes

- The schema is designed for PostgreSQL. Adjustments may be needed for other RDBMS.
- The `total_price` in the `Booking` table and `amount` in the `Payment` table are stored for performance and historical accuracy, even though they can be derived.

## File Structure

- `schema.sql`: SQL script to create the database schema.
- `README.md`: Documentation for the schema.
- `normalization.md`: Analysis of the schema's normalization to 3NF.
- `requirements.md`: Detailed specification of entities and relationships.
- `airbnb-detailed-er-diagram.png`: Entity-Relationship Diagram for the schema.

## License

This project is licensed under the MIT License.
