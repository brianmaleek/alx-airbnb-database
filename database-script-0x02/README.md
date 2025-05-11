# Airbnb Database Seed Script

## Overview

This project includes a seed script (`seed.sql`) to populate the Airbnb database with sample data. The data reflects real-world usage scenarios, including users, properties, bookings, payments, reviews, and messages. This script is designed to help test the database schema and simulate application functionality.

## Seed Data

The seed script populates the following tables:

### 1. **Users**

- Sample users include guests, hosts, and admins.
- Each user has attributes such as `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, and `role`.

### 2. **Properties**

- Properties are associated with hosts.
- Attributes include `name`, `description`, `location`, `price_per_night`, and timestamps (`created_at`, `updated_at`).

### 3. **Bookings**

- Bookings link guests to properties.
- Attributes include `start_date`, `end_date`, `total_price`, and `status` (e.g., `confirmed`, `pending`).

### 4. **Payments**

- Payments are linked to bookings.
- Attributes include `amount`, `payment_date`, and `payment_method` (e.g., `credit_card`, `paypal`).

### 5. **Reviews**

- Reviews are linked to properties and users.
- Attributes include `rating` (1-5), `comment`, and `created_at`.

### 6. **Messages**

- Messages are exchanged between users.
- Attributes include `sender_id`, `recipient_id`, `message_body`, and `sent_at`.

## How to Use

### Prerequisites

- Ensure the database schema is already created using the `schema.sql` file.
- If using PostgreSQL, enable the `uuid-ossp` extension for UUID generation:
  ```sql
  CREATE EXTENSION IF NOT EXISTS "uuid-ossp";