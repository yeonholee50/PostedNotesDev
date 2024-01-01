-- Stored procedure to register a new user with hashed password
DELIMITER //

CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255),
    IN p_is_instructor BOOLEAN
)
BEGIN
    DECLARE hashed_password VARCHAR(255);
    SET hashed_password = SHA2(p_password, 256);

    INSERT INTO users (username, email, password, is_instructor)
    VALUES (p_username, p_email, hashed_password, p_is_instructor);
END;
//

DELIMITER ;

-- Trigger to log user registration
DELIMITER //

CREATE TRIGGER after_insert_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO user_activity_log (user_id, activity_type, activity_details)
    VALUES (NEW.user_id, 'Registration', CONCAT('User "', NEW.username, '" registered.'));
END;
//

DELIMITER ;

-- Stored procedure to report a note
DELIMITER //

CREATE PROCEDURE sp_report_note(
    IN p_note_id INT,
    IN p_reporter_id INT,
    IN p_report_text TEXT
)
BEGIN
    INSERT INTO reported_notes (note_id, reporter_id, report_text)
    VALUES (p_note_id, p_reporter_id, p_report_text);

    -- Trigger to log the note report
    INSERT INTO user_activity_log (user_id, activity_type, activity_details)
    VALUES (p_reporter_id, 'Note Report', CONCAT('User reported note ', p_note_id));
END;
//

DELIMITER ;

-- Stored procedure to purchase a note
DELIMITER //

CREATE PROCEDURE sp_purchase_note(
    IN p_buyer_id INT,
    IN p_note_id INT
)
BEGIN
    INSERT INTO transactions (buyer_id, note_id)
    VALUES (p_buyer_id, p_note_id);

    -- Trigger to update note download statistics
    UPDATE note_download_statistics
    SET download_count = download_count + 1,
        last_download_date = CURRENT_TIMESTAMP
    WHERE note_id = p_note_id;

    -- Trigger to log the note purchase
    INSERT INTO user_activity_log (user_id, activity_type, activity_details)
    VALUES (p_buyer_id, 'Note Purchase', CONCAT('User purchased note ', p_note_id));
END;
//

DELIMITER ;

-- Example of using the stored procedures
-- CALL sp_register_user('john_doe', 'john@example.com', 'password123', 0);
-- CALL sp_report_note(1, 2, 'Inappropriate content');
-- CALL sp_purchase_note(3, 1);
