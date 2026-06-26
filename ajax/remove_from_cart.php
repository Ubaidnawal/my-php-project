<?php
session_start();

$product_id = isset($_POST['id']) ? trim($_POST['id']) : '';

if (empty($product_id)) {
    echo json_encode(['success' => false, 'message' => 'Invalid product.']);
    exit;
}

if (isset($_SESSION['cart'])) {
    foreach ($_SESSION['cart'] as $key => $item) {
        if ($item['id'] === $product_id) {
            unset($_SESSION['cart'][$key]);
            $_SESSION['cart'] = array_values($_SESSION['cart']);
            break;
        }
    }
}

$total_items = array_sum(array_column($_SESSION['cart'], 'quantity'));
$total_price = 0;
foreach ($_SESSION['cart'] as $item) {
    $total_price += $item['price'] * $item['quantity'];
}

echo json_encode([
    'success' => true,
    'message' => 'Item removed.',
    'cart_count' => $total_items,
    'total_price' => number_format($total_price, 2)
]);
?>