<?php
// includes/db_connect.php
// 🔴 IMPORTANT: Replace with your AwardSpace MySQL details
//    AwardSpace Dashboard → Hosting Tools → MySQL Databases

$host     = 'localhost';
$dbname   = 'gmail_website';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Database connection failed: " . $e->getMessage());
}
?>