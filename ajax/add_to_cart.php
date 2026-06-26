<?php
session_start();

if (!isset($_SESSION['cart'])) {
    $_SESSION['cart'] = [];
}

$product_name = isset($_POST['name']) ? trim($_POST['name']) : '';
$product_price = isset($_POST['price']) ? floatval($_POST['price']) : 0;
$product_id = isset($_POST['id']) ? trim($_POST['id']) : uniqid();

if (empty($product_name) || $product_price <= 0) {
    echo json_encode(['success' => false, 'message' => 'Invalid product data.']);
    exit;
}

$found = false;
foreach ($_SESSION['cart'] as &$item) {
    if ($item['id'] === $product_id) {
        $item['quantity'] += 1;
        $found = true;
        break;
    }
}
unset($item);
if (!$found) {
    $_SESSION['cart'][] = [
        'id' => $product_id,
        'name' => $product_name,
        'price' => $product_price,
        'quantity' => 1
    ];
}

$total_items = array_sum(array_column($_SESSION['cart'], 'quantity'));

echo json_encode([
    'success' => true,
    'message' => 'Product added to cart!',
    'cart_count' => $total_items
]);
?>