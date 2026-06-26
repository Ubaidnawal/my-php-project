<?php
session_start();

if (!isset($_SESSION['cart']) || empty($_SESSION['cart'])) {
    echo json_encode(['success' => false, 'message' => 'Cart is empty.']);
    exit;
}

$product_id = isset($_POST['id']) ? trim($_POST['id']) : '';
$new_qty = isset($_POST['quantity']) ? intval($_POST['quantity']) : 0;

if ($new_qty < 1) {
    echo json_encode(['success' => false, 'message' => 'Quantity must be at least 1.']);
    exit;
}

$updated = false;
foreach ($_SESSION['cart'] as &$item) {
    if ($item['id'] === $product_id) {
        $item['quantity'] = $new_qty;
        $updated = true;
        break;
    }
}
unset($item);

if (!$updated) {
    echo json_encode(['success' => false, 'message' => 'Product not found.']);
    exit;
}

$total_items = array_sum(array_column($_SESSION['cart'], 'quantity'));
$total_price = 0;
foreach ($_SESSION['cart'] as $item) {
    $total_price += $item['price'] * $item['quantity'];
}

echo json_encode([
    'success' => true,
    'message' => 'Cart updated.',
    'cart_count' => $total_items,
    'total_price' => number_format($total_price, 2)
]);
?>