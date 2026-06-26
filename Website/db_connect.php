<?php
$host = 'localhost';
$dbname = 'gmail_website';
$username = 'root
';
$password = '';
try {
    // Create PDO connection
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    
    // Set error mode to exception (helps catch errors)
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Set default fetch mode to associative array
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    
    // (Optional) Uncomment below line to see connection success
    // echo "Connected successfully";
    
} catch (PDOException $e) {
    // If connection fails, stop script and show error
    die("Database connection failed: " . $e->getMessage());
}
?>