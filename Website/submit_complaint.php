<?php
// submit_complaint.php
session_start();
require_once __DIR__ . '/../includes/db_connect.php'; // aapki existing db connection

$errors = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get data
    $full_name = trim($_POST['fullName'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $whatsapp = trim($_POST['whatsapp'] ?? '');
    $country = trim($_POST['country'] ?? '');
    $order_id = trim($_POST['orderId'] ?? '');
    $account_type = trim($_POST['accountType'] ?? '');
    $complaint_type = trim($_POST['complaintType'] ?? '');
    $description = trim($_POST['description'] ?? '');
    $replacement = $_POST['replacement'] ?? 'No';
    $agree = isset($_POST['agree']) ? 1 : 0;

    // Validation (required fields)
    if (empty($full_name)) $errors[] = 'Full Name is required.';
    if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) $errors[] = 'Valid email is required.';
    if (empty($whatsapp)) $errors[] = 'WhatsApp is required.';
    if (empty($country)) $errors[] = 'Country is required.';
    if (empty($order_id)) $errors[] = 'Order ID is required.';
    if (empty($account_type)) $errors[] = 'Account Type is required.';
    if (empty($complaint_type)) $errors[] = 'Complaint Type is required.';
    if (empty($description)) $errors[] = 'Description is required.';
    if (!$agree) $errors[] = 'You must confirm the information is correct.';

    // File upload handling (optional)
    $evidence_path = '';
    if (isset($_FILES['evidence']) && $_FILES['evidence']['error'] === UPLOAD_ERR_OK) {
        $upload_dir = 'uploads/complaints/';
        if (!is_dir($upload_dir)) {
            mkdir($upload_dir, 0777, true);
        }
        $file_name = time() . '_' . basename($_FILES['evidence']['name']);
        $target = $upload_dir . $file_name;
        if (move_uploaded_file($_FILES['evidence']['tmp_name'], $target)) {
            $evidence_path = $target;
        } else {
            $errors[] = 'File upload failed.';
        }
    }

    if (empty($errors)) {
        // Insert into database
        $sql = "INSERT INTO complaints (full_name, email, whatsapp, country, order_id, account_type, complaint_type, description, replacement_required, evidence) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$full_name, $email, $whatsapp, $country, $order_id, $account_type, $complaint_type, $description, $replacement, $evidence_path]);

        // Success – redirect or show message
        header('Location: complain.php?success=1');
        exit;
    } else {
        // Store errors in session and redirect back
        $_SESSION['complaint_errors'] = $errors;
        $_SESSION['complaint_data'] = $_POST;
        header('Location: complain.php');
        exit;
    }
} else {
    // If accessed directly, redirect
    header('Location: complain.php');
    exit;
}
?>