-- Database Seeder Script
-- This script populates the database with initial data: lobbies, menus, and admin account
-- Run this after the database schema is created

USE restaurantmanagement;

-- Insert Admin Account
-- Username: admin
-- Password: password (default - CHANGE THIS IN PRODUCTION!)
-- BCrypt hash generated with BCryptPasswordEncoder (Spring Security)
-- To generate a new hash, use: BCryptPasswordEncoder.encode("your_password")
INSERT INTO `user` (
    `user_id_card`, 
    `user_phone_number`, 
    `user_sex`, 
    `user_last_name`, 
    `user_first_name`, 
    `user_date_of_birth`, 
    `user_joined_date`, 
    `user_username`, 
    `user_password`, 
    `user_is_active`, 
    `user_role`, 
    `user_email`, 
    `user_address`, 
    `user_image`
) VALUES (
    '123456789012',
    '0123456789',
    TRUE,
    'Administrator',
    'System',
    '1990-01-01',
    CURDATE(),
    'admin',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- BCrypt hash for "password" (change this to your desired password hash)
    TRUE,
    'ADMIN',
    'admin@restaurant.com',
    '123 Admin Street, Ho Chi Minh City',
    'https://via.placeholder.com/150'
) ON DUPLICATE KEY UPDATE `user_username` = `user_username`;

-- Insert Sample Lobbies
INSERT INTO `lobby` (
    `lob_name`, 
    `lob_address`, 
    `lob_price`, 
    `lob_is_active`, 
    `lob_total_table`, 
    `lob_image`, 
    `lob_description`
) VALUES
(
    'Grand Ballroom',
    '123 Main Street, District 1, Ho Chi Minh City',
    5000000.00,
    TRUE,
    50,
    'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
    'Spacious grand ballroom perfect for large weddings and events. Features elegant chandeliers and modern sound system.'
),
(
    'Garden Pavilion',
    '456 Park Avenue, District 3, Ho Chi Minh City',
    3500000.00,
    TRUE,
    30,
    'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
    'Beautiful outdoor pavilion surrounded by lush gardens. Ideal for intimate ceremonies and garden parties.'
),
(
    'Royal Hall',
    '789 Luxury Boulevard, District 7, Ho Chi Minh City',
    8000000.00,
    TRUE,
    80,
    'https://images.unsplash.com/photo-1511578314322-379afb476865?w=800',
    'Luxurious royal hall with premium amenities. Perfect for high-end weddings and corporate events.'
),
(
    'Crystal Room',
    '321 Business District, District 2, Ho Chi Minh City',
    4500000.00,
    TRUE,
    40,
    'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?w=800',
    'Elegant crystal room with floor-to-ceiling windows offering stunning city views. Modern and sophisticated.'
),
(
    'Sunset Terrace',
    '654 Riverside Road, District 4, Ho Chi Minh City',
    3000000.00,
    TRUE,
    25,
    'https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800',
    'Charming terrace overlooking the river. Perfect for sunset ceremonies and romantic gatherings.'
)
ON DUPLICATE KEY UPDATE `lob_name` = `lob_name`;

-- Insert Sample Menus
INSERT INTO `menu` (
    `menu_name`, 
    `menu_price`, 
    `menu_is_active`, 
    `menu_image`
) VALUES
(
    'Premium Wedding Menu',
    1500000.00,
    TRUE,
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800'
),
(
    'Standard Wedding Menu',
    1000000.00,
    TRUE,
    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800'
),
(
    'Deluxe Wedding Menu',
    2000000.00,
    TRUE,
    'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=800'
),
(
    'Economy Wedding Menu',
    800000.00,
    TRUE,
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800'
),
(
    'VIP Wedding Menu',
    3000000.00,
    TRUE,
    'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=800'
),
(
    'Traditional Vietnamese Menu',
    1200000.00,
    TRUE,
    'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=800'
),
(
    'International Buffet Menu',
    1800000.00,
    TRUE,
    'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'
),
(
    'Vegetarian Menu',
    900000.00,
    TRUE,
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800'
)
ON DUPLICATE KEY UPDATE `menu_name` = `menu_name`;

-- Display summary
SELECT 'Seeder completed successfully!' AS Status;
SELECT COUNT(*) AS 'Total Lobbies' FROM `lobby` WHERE `lob_is_active` = TRUE;
SELECT COUNT(*) AS 'Total Menus' FROM `menu` WHERE `menu_is_active` = TRUE;
SELECT COUNT(*) AS 'Total Admin Users' FROM `user` WHERE `user_role` = 'ADMIN';

