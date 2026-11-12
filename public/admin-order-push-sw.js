self.addEventListener('push', event => {
    if (!event.data) return;
    const order = event.data.json();
    if (!Number.isInteger(order.id)) return;
    event.waitUntil(self.registration.showNotification('Vinmark · Đơn mới #' + order.id, {
        body: 'Bấm để mở chi tiết đơn hàng.',
        tag: 'vinmark-order-' + order.id,
        silent: false,
        data: { url: order.url }
    }));
});

self.addEventListener('notificationclick', event => {
    event.notification.close();
    const url = new URL(event.notification.data.url, self.location.origin);
    if (url.origin === self.location.origin) {
        event.waitUntil(clients.openWindow(url.href));
    }
});
