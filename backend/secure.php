<?php
require_once('db_connection.php');

function report_note($note_id, $reporter_id, $report_text) {
    global $conn;

    $stmt = $conn->prepare("INSERT INTO reported_notes (note_id, reporter_id, report_text) VALUES (?, ?, ?)");
    $stmt->bind_param("iis", $note_id, $reporter_id, $report_text);
    $stmt->execute();
    $stmt->close();
}
?>
