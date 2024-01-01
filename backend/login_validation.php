<?php
require_once('db_connection.php');

function validate_login($username, $password) {
    global $conn;

    $stmt = $conn->prepare("SELECT user_id, password FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $stmt->bind_result($user_id, $hashed_password);

    if ($stmt->fetch()) {
        if (password_verify($password, $hashed_password)) {
            return $user_id;
        }
    }

    return false;
}
?>



