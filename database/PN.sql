-- Database creation
CREATE DATABASE IF NOT EXISTS posted_notes;

-- Switch to the created database
USE posted_notes;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    is_instructor BOOLEAN DEFAULT 0,
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%') -- Basic email format check
);

-- Courses table
CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    instructor_id INT,
    commission_rate DECIMAL(5, 2) DEFAULT 0,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id)
);

-- Notes table
CREATE TABLE IF NOT EXISTS notes (
    note_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    seller_id INT,
    price DECIMAL(5, 2) NOT NULL,
    rating DECIMAL(3, 2) DEFAULT 0,
    is_handwritten BOOLEAN DEFAULT 1,
    file_type VARCHAR(5) NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

-- Permissions table
CREATE TABLE IF NOT EXISTS permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    user_id INT,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id INT,
    note_id INT,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES users(user_id),
    FOREIGN KEY (note_id) REFERENCES notes(note_id)
);

-- Commission payments table
CREATE TABLE IF NOT EXISTS commission_payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_id INT,
    amount DECIMAL(8, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id)
);

-- Input validation trigger example for price
DELIMITER //

CREATE TRIGGER before_insert_notes
BEFORE INSERT ON notes
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price cannot be negative';
    END IF;
END;
//

DELIMITER ;

-- User Ratings and Reviews
CREATE TABLE IF NOT EXISTS note_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    note_id INT,
    reviewer_id INT,
    rating INT,
    review_text TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(note_id),
    FOREIGN KEY (reviewer_id) REFERENCES users(user_id)
);

-- User Notifications
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    notification_text TEXT,
    is_read BOOLEAN DEFAULT 0,
    notification_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Reported Notes
CREATE TABLE IF NOT EXISTS reported_notes (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    note_id INT,
    reporter_id INT,
    report_text TEXT,
    report_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_resolved BOOLEAN DEFAULT 0,
    FOREIGN KEY (note_id) REFERENCES notes(note_id),
    FOREIGN KEY (reporter_id) REFERENCES users(user_id)
);

-- User Activity Log
CREATE TABLE IF NOT EXISTS user_activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    activity_type VARCHAR(255),
    activity_details TEXT,
    activity_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Note Download Statistics
CREATE TABLE IF NOT EXISTS note_download_statistics (
    statistic_id INT AUTO_INCREMENT PRIMARY KEY,
    note_id INT,
    download_count INT DEFAULT 0,
    last_download_date TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(note_id)
);
