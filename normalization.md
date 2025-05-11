# Database Normalization to 3NF

This document analyzes the provided database schema for a property rental platform and outlines the steps taken to ensure it adheres to the Third Normal Form (3NF).

## Understanding Normalization Forms

* **First Normal Form (1NF):**
  * Each table cell should contain a single, atomic value.
  * There are no repeating groups of columns.
  * Each row is unique, typically ensured by a primary key.

* **Second Normal Form (2NF):**
  * The table must be in 1NF.
  * All non-key attributes must be fully functionally dependent on the *entire* primary key. This means there should be no partial dependencies, where a non-key attribute depends on only a part of a composite primary key.

* **Third Normal Form (3NF):**
  * The table must be in 2NF.
  * There should be no transitive dependencies. A transitive dependency occurs when a non-key attribute is functionally dependent on another non-key attribute, rather than directly on the primary key. In simpler terms, non-key attributes should depend on "the key, the whole key, and nothing but the key" (excluding other candidate keys).

## Reviewing the Original Schema

The provided schema is generally well-structured. Let's examine each entity:

### 1. User Entity

* `user_id` (PK)
  * Attributes: `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `created_at`.
    * **1NF:** All attributes appear atomic. `user_id` is a valid PK.
    * **2NF:** The primary key `user_id` is a single column, so no partial dependencies can exist. Thus, it's in 2NF.
    * **3NF:** All non-key attributes (`first_name`, `last_name`, etc.) are directly dependent on `user_id`. No transitive dependencies are apparent.
    * **Conclusion:** `User` entity appears to be in 3NF.

### 2. Property Entity

* `property_id` (PK)
  * Attributes: `host_id` (FK), `name`, `description`, `location`, `pricepernight`, `created_at`, `updated_at`.
  * **1NF:** All attributes appear atomic (assuming `location` is a single string value). `property_id` is a valid PK.
  * **2NF:** PK `property_id` is a single column, so no partial dependencies. Thus, it's in 2NF.
  * **3NF:** All non-key attributes (`name`, `description`, `location`, `pricepernight`) are directly dependent on `property_id`. `host_id` is an FK that depends on `property_id` (it defines who hosts *this* specific property). No transitive dependencies are apparent.
  * **Conclusion:** `Property` entity appears to be in 3NF.

### 3. Booking Entity

* `booking_id` (PK)
  * Attributes: `property_id` (FK), `user_id` (FK), `start_date`, `end_date`, `total_price`, `status`, `created_at`.
  * **1NF:** All attributes appear atomic. `booking_id` is a valid PK.
  * **2NF:** PK `booking_id` is a single column, so no partial dependencies. Thus, it's in 2NF.
  * **3NF:**
    * `property_id`, `user_id`, `start_date`, `end_date`, `status`, `created_at` are directly dependent on `booking_id`.
    * `total_price`: This attribute is problematic for strict 3NF. The `total_price` is typically calculated as (`end_date` - `start_date`)* `Property.pricepernight`.
    * `booking_id` -> `property_id` (FK in Booking)
    * `property_id` -> `pricepernight` (from Property table)
    * `booking_id` -> (`start_date`, `end_date`) (attributes in Booking)
    * Therefore, `total_price` depends on `start_date`, `end_date`, and `Property.pricepernight` (which is determined via `property_id`). This makes `total_price` dependent on other attributes, some of which are non-key or in a related table. This is a transitive dependency or a dependency on non-key attributes if calculated only from `start_date` and `end_date` and a `pricepernight` value that could be argued to be part of the booking context.
      * Storing `total_price` is a form of denormalization. While practical for performance and historical accuracy (capturing the price at the time of booking, even if `Property.pricepernight` changes later), it violates strict 3NF.
    * **Conclusion:** `Booking` entity, due to `total_price`, is not strictly in 3NF.

### 4. Payment Entity

* `payment_id` (PK)
  * Attributes: `booking_id` (FK), `amount`, `payment_date`, `payment_method`.
    * **1NF:** All attributes appear atomic. `payment_id` is a valid PK.
    * **2NF:** PK `payment_id` is a single column, so no partial dependencies. Thus, it's in 2NF.
    * **3NF:**
      * `booking_id`, `payment_date`, `payment_method` are directly dependent on `payment_id`.
      * `amount`: The relationship "Booking to Payment: A Booking has one Payment (one-to-one)" strongly implies that the `Payment.amount` should correspond to the `Booking.total_price`.
        * If `Payment.amount` is always equal to `Booking.total_price`:
          * `payment_id` -> `booking_id` (FK in Payment)
          * `booking_id` -> (`total_price` from Booking table, or calculated based on Booking's details and Property's price)
          * This means `Payment.amount` is transitively dependent on `payment_id` via `booking_id` and the booking's total price. This is a 3NF violation if `amount` is just a copy.
    * **Conclusion:** `Payment` entity, due to `amount` (if it mirrors `Booking.total_price`), is not strictly in 3NF.

### 5. Review Entity

* `review_id` (PK)
  * Attributes: `property_id` (FK), `user_id` (FK), `rating`, `comment`, `created_at`.
    * **1NF, 2NF, 3NF:** Similar to `User` and `Property`, all non-key attributes (`rating`, `comment`) depend directly on `review_id`.
  * **Conclusion:** `Review` entity appears to be in 3NF.

### 6. Message Entity

* `message_id` (PK)
  * Attributes: `sender_id` (FK), `recipient_id` (FK), `message_body`, `sent_at`.
    * **1NF, 2NF, 3NF:** All non-key attributes (`message_body`) depend directly on `message_id`.
    * **Conclusion:** `Message` entity appears to be in 3NF.

## Normalization Steps to Achieve Strict 3NF

To achieve strict 3NF, we need to address the identified transitive dependencies and redundant data.

### Step 1: Normalize the `Booking` Entity

* **Issue:** The `total_price` attribute in the `Booking` entity is derived from `start_date`, `end_date`, and `Property.pricepernight`. This violates 3NF as `total_price` is dependent on other attributes, not solely and directly on `booking_id` for its fundamental value (it's calculated).
* **Action:** Remove the `total_price` attribute from the `Booking` entity.
* **Rationale:** The `total_price` can be calculated dynamically whenever needed by joining the `Booking` table with the `Property` table and using the `start_date`, `end_date`, and `pricepernight`. This ensures that the price is always based on the current data and avoids redundancy and potential update anomalies.
  * Calculation: `(Booking.end_date - Booking.start_date) * Property.pricepernight` (adjusting for duration units).

### Step 2: Normalize the `Payment` Entity

* **Issue:** The `amount` attribute in the `Payment` entity is likely intended to be the same as the `Booking.total_price`. Given the one-to-one relationship between `Booking` and `Payment`, storing `amount` separately in `Payment` is redundant if it's always derived from the booking's total. This creates a transitive dependency: `payment_id` -> `booking_id` -> `calculated_booking_total_price`.
* **Action:** Remove the `amount` attribute from the `Payment` entity.
* **Rationale:** Since a `Payment` is uniquely tied to a `Booking` (via `booking_id`), the payment amount can be determined by referring to the associated booking's details (which, after Step 1, would also involve calculation). This eliminates redundancy. If there's a future need for payments that don't directly match the calculated booking total (e.g., partial payments, additional fees processed with payment), the schema would need further adjustment (e.g., making `Payment.amount` independent or changing the Booking-Payment relationship). However, based on the current "one-to-one" and the context, direct derivation is implied.

## Adjusted Schema for Strict 3NF

Here's how the affected entities would look after applying these normalization steps:

### Booking Entity (3NF)

* `booking_id` (Primary Key, UUID, Indexed)
* `property_id` (Foreign Key, references Property(property\_id))
* `user_id` (Foreign Key, references User(user\_id))
* `start_date` (DATE, NOT NULL)
* `end_date` (DATE, NOT NULL)
* `status` (ENUM ('pending', 'confirmed', 'canceled'), NOT NULL)
* `created_at` (TIMESTAMP, DEFAULT CURRENT\_TIMESTAMP)
  * *(`total_price` removed)*

### Payment Entity (3NF)

* `payment_id` (Primary Key, UUID, Indexed)
* `booking_id` (Foreign Key, references Booking(booking\_id), UNIQUE for 1:1)
* `payment_date` (TIMESTAMP, DEFAULT CURRENT\_TIMESTAMP)
* `payment_method` (ENUM ('credit\_card', 'paypal', 'stripe'), NOT NULL)
  * *(`amount` removed)*

The `User`, `Property`, `Review`, and `Message` entities remain unchanged as they were already assessed to be in 3NF.

## Practical Considerations vs. Strict 3NF

While the adjustments above achieve strict 3NF, it's important to consider the practical implications:

* **Performance:** Calculating `total_price` on-the-fly for every query requiring it can impact performance, especially with a large number of bookings. The original design (storing `total_price` in `Booking`) is a common denormalization technique to optimize read performance.
* **Historical Data Integrity:** If `Property.pricepernight` changes, calculating `total_price` on-the-fly for past bookings would reflect the *new* property price, not the price at the time of booking. Storing `total_price` in the `Booking` table preserves this historical accuracy. Similarly, `Payment.amount` would capture the exact amount of the transaction at that time.

**Recommendation:**
For this specific application, especially for `Booking.total_price` and `Payment.amount`, the original schema with these attributes stored might be preferable due to:

1. **Auditing/Historical Accuracy:** The price of a booking and the amount paid are fixed at the time of the transaction. They should not change if base rates or other factors change later.
2. **Performance:** Avoiding repeated complex calculations.

If the original design is kept (with `Booking.total_price` and `Payment.amount` stored), it's a conscious decision to denormalize for these practical benefits. The application logic must then ensure consistency (e.g., `Payment.amount` correctly reflects `Booking.total_price` at the time of payment).

However, for the purpose of this exercise demonstrating strict 3NF, the attributes `Booking.total_price` and `Payment.amount` have been identified as violations and removed in the "Adjusted Schema for Strict 3NF" section.

---

### Conclusion on Normalization Steps

The original schema was largely normalized. The primary adjustments for strict 3NF involve removing the calculated/derived `total_price` from `Booking` and the potentially redundant `amount` from `Payment`. These changes ensure that non-key attributes are not dependent on other non-key attributes or derivable from related tables in a way that causes redundancy according to strict 3NF principles. The choice between strict 3NF and a pragmatically denormalized design depends on balancing data integrity, performance, and business requirements.
