<?php
require_once('db_connection.php');

function purchase_note($buyer_id, $note_id) {
    global $conn;

    $stmt = $conn->prepare("INSERT INTO transactions (buyer_id, note_id) VALUES (?, ?)");
    $stmt->bind_param("ii", $buyer_id, $note_id);
    $stmt->execute();
    $stmt->close();

    // Trigger to update note download statistics goes here

    // Trigger to log the note purchase goes here
}

function get_user_notes($user_id) {
    global $conn;

    $stmt = $conn->prepare("SELECT * FROM notes WHERE seller_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $notes = $result->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    return $notes;
}

// Add other note management functions as needed
?>
