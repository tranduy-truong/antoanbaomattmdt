(() => {
    const button = document.querySelector('[data-order-push]');
    if (!button) return;
    const status = document.getElementById('order-push-status');
    const canPush = window.isSecureContext && 'serviceWorker' in navigator
        && 'PushManager' in window && 'Notification' in window;
    if (!canPush) {
        button.disabled = true;
        status.textContent = 'Mở trang bằng HTTPS trên Chrome hoặc Edge.';
        return;
    }

    const updateServer = async (method, subscription) => {
        const response = await fetch(button.dataset.endpoint, {
            method,
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify(subscription)
        });
        if (!response.ok) throw new Error('Registration failed');
    };

    const worker = navigator.serviceWorker.register(button.dataset.worker, {scope: '/admin/'});
    worker.catch(() => { status.textContent = 'Không tải được dịch vụ thông báo.'; });
    let enabled = false;
    const render = () => { button.textContent = enabled ? 'Tắt báo đơn trên máy này' : 'Bật báo đơn trên máy này'; };

    worker.then(async registration => {
        const subscription = await registration.pushManager.getSubscription();
        if (subscription && Notification.permission === 'granted') {
            await updateServer('POST', subscription);
            enabled = true;
            render();
        }
    }).catch(() => { status.textContent = 'Chưa kết nối được thông báo đơn.'; });

    button.addEventListener('click', async () => {
        button.disabled = true;
        try {
            const permission = enabled ? Notification.permission : await Notification.requestPermission();
            if (permission !== 'granted' && !enabled) {
                status.textContent = 'Hãy cho phép thông báo cho Vinmark trong trình duyệt.';
                return;
            }
            await worker;
            const registration = await navigator.serviceWorker.ready;
            let subscription = await registration.pushManager.getSubscription();
            if (enabled && subscription) {
                await updateServer('DELETE', {endpoint: subscription.endpoint});
                await subscription.unsubscribe();
                enabled = false;
            } else {
                if (!subscription) {
                    const key = button.dataset.key.replace(/-/g, '+').replace(/_/g, '/');
                    subscription = await registration.pushManager.subscribe({
                        userVisibleOnly: true,
                        applicationServerKey: Uint8Array.from(atob(key.padEnd(Math.ceil(key.length / 4) * 4, '=')), c => c.charCodeAt(0))
                    });
                }
                await updateServer('POST', subscription);
                enabled = true;
            }
            status.textContent = enabled ? 'Máy này đã bật thông báo đơn mới.' : 'Máy này đã tắt thông báo đơn mới.';
            render();
        } catch {
            status.textContent = 'Chưa lưu được cài đặt thông báo. Hãy thử lại.';
        } finally {
            button.disabled = false;
        }
    });
})();
