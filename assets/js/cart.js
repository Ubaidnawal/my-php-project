// assets/js/cart.js

document.addEventListener('DOMContentLoaded', function() {
    // ---- Toast Notification ----
    function showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.className = 'toast-notification ' + type;
        toast.textContent = message;
        toast.style.position = 'fixed';
        toast.style.bottom = '20px';
        toast.style.right = '20px';
        toast.style.padding = '15px 25px';
        toast.style.background = type === 'success' ? '#28a745' : '#dc3545';
        toast.style.color = '#fff';
        toast.style.borderRadius = '8px';
        toast.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
        toast.style.zIndex = '9999';
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.3s ease';
        document.body.appendChild(toast);
        setTimeout(() => { toast.style.opacity = '1'; }, 10);
        setTimeout(() => {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 300);
        }, 3000);
    }

    // ---- Update cart counter ----
    function updateCartCount(count) {
        const counters = document.querySelectorAll('.cart-counter');
        counters.forEach(counter => {
            counter.textContent = count;
            if (count > 0) {
                counter.classList.add('visible');
                counter.style.display = '';
            } else {
                counter.classList.remove('visible');
                counter.style.display = 'none';
            }
        });
    }

    // ---- Add to Cart (product cards) ----
    // Uses event delegation because cart.js is loaded in header.php
    // before the product card buttons exist in the DOM.
    document.addEventListener('click', function(e) {
        // Use composedPath() as the primary lookup — it is computed by the
        // browser before any handlers run, so it remains correct even when
        // a synchronous inline handler replaces innerHTML (which detaches
        // child nodes and breaks e.target.closest() in the bubble phase).
        let button = null;
        if (e.composedPath) {
            button = e.composedPath().find(function(el) {
                return el.classList && el.classList.contains('addCartBtn');
            });
        }
        if (!button) {
            button = e.target.closest('.addCartBtn');
        }
        if (!button) return;
        e.preventDefault();

        const productName = button.dataset.name;
        if (!productName) {
            showToast('Invalid product data.', 'error');
            return;
        }

        // Read price from the card's visible .current-price element, not from hardcoded data-price
        const card = button.closest('.attract-card') || button.closest('.col');
        let productPrice = 0;
        const priceEl = card ? card.querySelector('.current-price') : null;
        if (priceEl) {
            const txt = priceEl.textContent.trim().replace('$', '');
            productPrice = parseFloat(txt) || 0;
        }
        if (!productPrice) productPrice = parseFloat(button.dataset.price) || 0;
        if (!productPrice) {
            showToast('Invalid product price.', 'error');
            return;
        }

        const productId = productName.toLowerCase().replace(/\s+/g, '_') + '_' + Date.now();

        fetch('/Gmail Website/ajax/add_to_cart.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `id=${encodeURIComponent(productId)}&name=${encodeURIComponent(productName)}&price=${encodeURIComponent(productPrice)}`
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showToast('🛒 ' + productName + ' added to cart!');
                if (data.cart_count !== undefined) {
                    updateCartCount(data.cart_count);
                }
            } else {
                showToast(data.message || 'Error adding product.', 'error');
            }
        })
        .catch(error => {
            showToast('Error adding to cart. Please try again.', 'error');
            console.error('Add to cart error:', error);
        });
    });

    // ---- Modal "Add to Cart" button ----
    const modalAddBtn = document.getElementById('modalAddToCartBtn');
    if (modalAddBtn) {
        modalAddBtn.addEventListener('click', function() {
            const productName = document.getElementById('modalProductName')?.textContent || '';
            const priceText = document.getElementById('detailProductPrice')?.textContent || '0';
            const productPrice = parseFloat(priceText.replace(/[^0-9.]/g, ''));
            const productId = 'modal_' + productName.toLowerCase().replace(/\s+/g, '_');

            if (!productName || !productPrice || productPrice <= 0) {
                showToast('Invalid product data.', 'error');
                return;
            }

            fetch('/Gmail Website/ajax/add_to_cart.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `id=${encodeURIComponent(productId)}&name=${encodeURIComponent(productName)}&price=${encodeURIComponent(productPrice)}`
            })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showToast(data.message);
                    if (data.cart_count !== undefined) {
                        updateCartCount(data.cart_count);
                    }
                    // Close modal
                    const modal = bootstrap.Modal.getInstance(document.getElementById('productDetailModal'));
                    if (modal) modal.hide();
                } else {
                    showToast(data.message || 'Error adding product.', 'error');
                }
            })
            .catch(error => {
                showToast('Network error. Please try again.', 'error');
                console.error('Modal add to cart error:', error);
            });
        });
    }

    // ---- Cart page: update quantity ----
    document.querySelectorAll('.cart-item .qty-input').forEach(input => {
        input.addEventListener('change', function() {
            const item = this.closest('.cart-item');
            const productId = item.dataset.id;
            const newQty = parseInt(this.value) || 1;
            if (newQty < 1) { this.value = 1; return; }

            fetch('/Gmail Website/ajax/update_cart.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `id=${encodeURIComponent(productId)}&quantity=${newQty}`
            })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    const price = parseFloat(item.querySelector('.item-price')?.textContent.replace('$', '')) || 0;
                    const subtotal = price * newQty;
                    item.querySelector('.item-subtotal').textContent = '$' + subtotal.toFixed(2);
                    document.getElementById('totalQuantity').textContent = data.cart_count;
                    document.getElementById('grandTotal').textContent = data.total_price;
                    const items = document.querySelectorAll('.cart-item');
                    document.getElementById('totalProducts').textContent = items.length;
                    showToast('Cart updated.');
                } else {
                    showToast(data.message || 'Update failed.', 'error');
                }
            })
            .catch(error => {
                showToast('Network error.', 'error');
                console.error('Update cart error:', error);
            });
        });
    });

    // ---- Remove item ----
    document.querySelectorAll('.remove-item').forEach(button => {
        button.addEventListener('click', function() {
            const item = this.closest('.cart-item');
            const productId = item.dataset.id;
            if (!confirm('Remove this item?')) return;

            fetch('/Gmail Website/ajax/remove_from_cart.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `id=${encodeURIComponent(productId)}`
            })
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    item.remove();
                    document.getElementById('totalQuantity').textContent = data.cart_count;
                    document.getElementById('grandTotal').textContent = data.total_price;
                    const remaining = document.querySelectorAll('.cart-item');
                    document.getElementById('totalProducts').textContent = remaining.length;
                    if (remaining.length === 0) {
                        location.reload();
                    }
                    showToast('Item removed.');
                } else {
                    showToast(data.message || 'Remove failed.', 'error');
                }
            })
            .catch(error => {
                showToast('Network error.', 'error');
                console.error('Remove item error:', error);
            });
        });
    });

    // ---- Load initial cart count from server ----
    // We set the cart counter from PHP-rendered data in the HTML
    // This just makes sure hidden counters with value > 0 are shown
    document.querySelectorAll('.cart-counter').forEach(counter => {
        const count = parseInt(counter.textContent) || 0;
        if (count > 0) {
            counter.classList.add('visible');
        } else {
            counter.classList.remove('visible');
        }
    });
});