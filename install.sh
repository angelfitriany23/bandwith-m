#!/bin/sh
# Buat folder
mkdir -p /www/bandwidth
# Install dependensi
opkg update
opkg install luci-mod-rpc
# Buat file HTML
cat > /www/bandwidth/index.html << 'EOFHTML'
<!DOCTYPE html>

<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OpenWRT Bandwidth Monitor</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

```
    body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        background: #0f172a;
        color: white;
        min-height: 100vh;
        padding: 20px;
    }

    .container {
        max-width: 1400px;
        margin: 0 auto;
    }

    .header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 30px;
        flex-wrap: wrap;
        gap: 20px;
    }

    .header-left {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .icon-box {
        width: 56px;
        height: 56px;
        background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 32px;
        box-shadow: 0 4px 20px rgba(6, 182, 212, 0.3);
    }

    .header-title h1 {
        font-size: 28px;
        margin-bottom: 4px;
        color: white;
    }

    .header-title p {
        color: #94a3b8;
        font-size: 14px;
    }

    .header-time {
        text-align: right;
        color: #94a3b8;
        font-size: 14px;
    }

    .time-display {
        font-size: 20px;
        font-family: monospace;
        margin-top: 4px;
        color: #06b6d4;
    }

    .dashboard {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 20px;
        padding: 30px;
        margin-bottom: 30px;
    }

    .dashboard h2 {
        font-size: 20px;
        margin-bottom: 30px;
        color: white;
    }

    .chart-container {
        background: #0f172a;
        border-radius: 16px;
        padding: 20px;
        border: 1px solid #1e293b;
        height: 300px;
        position: relative;
    }

    #realtimeChart {
        width: 100%;
        height: 100%;
    }

    .chart-legend {
        position: absolute;
        top: 20px;
        right: 20px;
        display: flex;
        gap: 20px;
        font-size: 13px;
        background: rgba(15, 23, 42, 0.8);
        padding: 10px 15px;
        border-radius: 8px;
    }

    .legend-item {
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .legend-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
    }

    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }

    .stat-card {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 16px;
        padding: 24px;
        transition: all 0.3s;
    }

    .stat-card:hover {
        border-color: #06b6d4;
        box-shadow: 0 4px 20px rgba(6, 182, 212, 0.2);
    }

    .stat-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
    }

    .stat-label {
        color: #94a3b8;
        font-size: 14px;
    }

    .stat-icon {
        font-size: 24px;
    }

    .stat-value {
        font-size: 32px;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .stat-info {
        color: #10b981;
        font-size: 14px;
    }

    .devices-section h2 {
        font-size: 20px;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: white;
    }

    .devices-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
        gap: 20px;
    }

    .device-card {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 20px;
        padding: 24px;
        transition: all 0.3s;
        cursor: pointer;
    }

    .device-card:hover {
        border-color: #06b6d4;
        box-shadow: 0 4px 20px rgba(6, 182, 212, 0.2);
    }

    .device-card.expanded {
        grid-column: 1 / -1;
        border-color: #06b6d4;
    }

    .device-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
    }

    .device-info {
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .device-icon {
        width: 48px;
        height: 48px;
        background: linear-gradient(135deg, #06b6d4 0%, #0891b2 100%);
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;
    }

    .device-name h3 {
        font-size: 18px;
        margin-bottom: 4px;
        color: white;
    }

    .device-ip {
        color: #94a3b8;
        font-size: 14px;
    }

    .device-status {
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
    }

    .status-online {
        background: rgba(16, 185, 129, 0.2);
        color: #10b981;
        border: 1px solid #10b981;
    }

    .status-offline {
        background: rgba(156, 163, 175, 0.2);
        color: #9ca3af;
        border: 1px solid #64748b;
    }

    .device-mac {
        color: #64748b;
        font-size: 12px;
        font-family: monospace;
        margin-bottom: 16px;
    }

    .device-speeds {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-bottom: 16px;
    }

    .speed-box h4 {
        color: #94a3b8;
        font-size: 14px;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .speed-value {
        font-size: 20px;
        font-weight: bold;
    }

    .download-color { color: #06b6d4; }
    .upload-color { color: #10b981; }

    .device-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding-top: 16px;
        border-top: 1px solid #334155;
    }

    .device-time {
        color: #94a3b8;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .device-total {
        color: #94a3b8;
        font-size: 14px;
    }

    .device-total span {
        color: white;
        font-weight: 600;
    }

    .device-details {
        display: none;
        margin-top: 24px;
        padding-top: 24px;
        border-top: 2px solid #334155;
    }

    .device-card.expanded .device-details {
        display: block;
    }

    .details-grid {
        display: grid;
        grid-template-columns: auto 1fr;
        gap: 40px;
        align-items: center;
    }

    .donut-chart {
        width: 200px;
        height: 200px;
    }

    .bandwidth-info h3 {
        font-size: 18px;
        margin-bottom: 24px;
        color: white;
    }

    .bandwidth-row {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 20px;
    }

    .bandwidth-dot {
        width: 12px;
        height: 12px;
        border-radius: 50%;
    }

    .bandwidth-label {
        color: #94a3b8;
        font-size: 14px;
        min-width: 80px;
    }

    .bandwidth-value {
        font-size: 24px;
        font-weight: bold;
    }

    .current-speeds {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-top: 24px;
        padding-top: 24px;
        border-top: 1px solid #334155;
    }

    .current-speed-box {
        background: #0f172a;
        border-radius: 12px;
        padding: 20px;
        border: 1px solid #1e293b;
    }

    .current-speed-box h4 {
        color: #94a3b8;
        font-size: 14px;
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .current-speed-value {
        font-size: 28px;
        font-weight: bold;
    }

    .footer {
        text-align: center;
        margin-top: 40px;
    }

    .footer-card {
        background: #1e293b;
        border: 1px solid #334155;
        border-radius: 16px;
        padding: 20px;
    }

    .footer p {
        color: #94a3b8;
        font-size: 14px;
        margin-bottom: 4px;
    }

    .footer .creator {
        color: #06b6d4;
        font-size: 14px;
        font-weight: 500;
    }

    .loading {
        text-align: center;
        padding: 40px;
        color: #94a3b8;
    }

    .error {
        background: rgba(239, 68, 68, 0.1);
        border: 1px solid #ef4444;
        color: #ef4444;
        padding: 16px;
        border-radius: 12px;
        margin-bottom: 20px;
    }

    @media (max-width: 768px) {
        .devices-grid {
            grid-template-columns: 1fr;
        }
        
        .stats-grid {
            grid-template-columns: 1fr;
        }

        .device-card.expanded {
            grid-column: 1;
        }

        .details-grid {
            grid-template-columns: 1fr;
        }

        .donut-chart {
            margin: 0 auto;
        }

        .chart-legend {
            position: static;
            justify-content: center;
            margin-top: 10px;
        }
    }
</style>
```

</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="header">
            <div class="header-left">
                <div class="icon-box">📡</div>
                <div class="header-title">
                    <h1>OpenWRT Bandwidth Monitor</h1>
                    <p>Monitor & kontrol bandwidth jaringan Anda</p>
                </div>
            </div>
            <div class="header-time">
                <div id="currentDate"></div>
                <div class="time-display" id="currentTime"></div>
            </div>
        </div>

```
    <div id="errorContainer"></div>

    <!-- Dashboard Grafik -->
    <div class="dashboard">
        <h2>📊 Grafik Bandwidth Real-time</h2>
        <div class="chart-container">
            <div class="chart-legend">
                <div class="legend-item">
                    <div class="legend-dot" style="background: #06b6d4;"></div>
                    <span class="download-color" id="legendDownload">Download: 0 MB/s</span>
                </div>
                <div class="legend-item">
                    <div class="legend-dot" style="background: #10b981;"></div>
                    <span class="upload-color" id="legendUpload">Upload: 0 MB/s</span>
                </div>
            </div>
            <canvas id="realtimeChart"></canvas>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="stats-grid" id="statsGrid">
        <div class="loading">Memuat data...</div>
    </div>

    <!-- Devices Section -->
    <div class="devices-section">
        <h2>📱 Perangkat Terhubung</h2>
        <div class="devices-grid" id="devicesGrid">
            <div class="loading">Memuat perangkat...</div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <div class="footer-card">
            <p>Data diperbarui setiap 2 detik</p>
            <p class="creator">Created by PakRT</p>
        </div>
    </div>
</div>

<script>
    // Configuration
    const API_BASE = window.location.origin;
    let authToken = null;
    let devices = [];
    let chartData = Array(60).fill(0).map(() => ({ download: 0, upload: 0 }));

    // Authenticate with OpenWRT
    async function authenticate() {
        try {
            const response = await fetch(`${API_BASE}/cgi-bin/luci/rpc/auth`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    id: 1,
                    method: 'login',
                    params: params: ['root', 'indonesia']
            });
            const data = await response.json();
            authToken = data.result;
            return authToken;
        } catch (error) {
            console.error('Authentication error:', error);
            return null;
        }
    }

    // Get DHCP leases (connected devices)
    async function getDevices() {
        try {
            const response = await fetch(`${API_BASE}/cgi-bin/luci/rpc/sys?auth=${authToken}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    id: 1,
                    method: 'net.dhcp_leases',
                    params: []
                })
            });
            const data = await response.json();
            return data.result || [];
        } catch (error) {
            console.error('Error fetching devices:', error);
            return [];
        }
    }

    // Get network statistics
    async function getNetworkStats(interface_name = 'wan') {
        try {
            const response = await fetch(`${API_BASE}/cgi-bin/luci/rpc/sys?auth=${authToken}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    id: 1,
                    method: 'net.deviceinfo',
                    params: [interface_name]
                })
            });
            const data = await response.json();
            return data.result || {};
        } catch (error) {
            console.error('Error fetching network stats:', error);
            return {};
        }
    }

    // Format functions
    function formatSpeed(bytes) {
        const kb = bytes / 1024;
        if (kb >= 1024) {
            return `${(kb / 1024).toFixed(2)} MB/s`;
        }
        return `${kb.toFixed(2)} KB/s`;
    }

    function formatData(bytes) {
        const gb = bytes / (1024 * 1024 * 1024);
        if (gb >= 1000) {
            return `${(gb / 1000).toFixed(2)} TB`;
        }
        return `${gb.toFixed(2)} GB`;
    }

    function formatTime(seconds) {
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        return `${h}j ${m}m ${s}s`;
    }

    // Update time
    function updateTime() {
        const now = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        document.getElementById('currentDate').textContent = now.toLocaleDateString('id-ID', options);
        document.getElementById('currentTime').textContent = now.toLocaleTimeString('id-ID');
    }

    // Create donut chart SVG
    function createDonutChart(download, upload, total) {
        const radius = 70;
        const strokeWidth = 20;
        const normalizedRadius = radius - strokeWidth / 2;
        const circumference = normalizedRadius * 2 * Math.PI;
        
        const downloadPercent = (download / total) * 100;
        const uploadPercent = (upload / total) * 100;
        
        const downloadOffset = circumference - (downloadPercent / 100) * circumference;
        const uploadOffset = circumference - (uploadPercent / 100) * circumference;
        const uploadRotation = downloadPercent * 3.6;

        return `
            <svg width="200" height="200" class="donut-chart">
                <circle stroke="#1e293b" fill="transparent" stroke-width="${strokeWidth}" 
                        r="${normalizedRadius}" cx="100" cy="100"/>
                <circle stroke="#06b6d4" fill="transparent" stroke-width="${strokeWidth}" 
                        stroke-dasharray="${circumference} ${circumference}" 
                        stroke-dashoffset="${downloadOffset}"
                        r="${normalizedRadius}" cx="100" cy="100"
                        stroke-linecap="round" transform="rotate(-90 100 100)"/>
                <circle stroke="#10b981" fill="transparent" stroke-width="${strokeWidth}" 
                        stroke-dasharray="${circumference} ${circumference}" 
                        stroke-dashoffset="${uploadOffset}"
                        r="${normalizedRadius}" cx="100" cy="100"
                        stroke-linecap="round" opacity="0.7"
                        transform="rotate(${uploadRotation - 90} 100 100)"/>
            </svg>
        `;
    }

    // Render stats
    function renderStats(totalDownloadSpeed, totalUploadSpeed, totalData, onlineCount) {
        const stats = [
            { label: 'Total Perangkat', value: devices.length, info: `${onlineCount} online`, icon: '👥', color: '#06b6d4' },
            { label: 'Download Speed', value: formatSpeed(totalDownloadSpeed), info: `Real-time`, icon: '⬇️', color: '#06b6d4' },
            { label: 'Upload Speed', value: formatSpeed(totalUploadSpeed), info: `Real-time`, icon: '⬆️', color: '#10b981' },
            { label: 'Total Data', value: formatData(totalData), info: 'Semua perangkat', icon: '📊', color: '#a855f7' }
        ];

        document.getElementById('statsGrid').innerHTML = stats.map(stat => `
            <div class="stat-card">
                <div class="stat-header">
                    <span class="stat-label">${stat.label}</span>
                    <span class="stat-icon">${stat.icon}</span>
                </div>
                <div class="stat-value" style="color: ${stat.color}">${stat.value}</div>
                <div class="stat-info">${stat.info}</div>
            </div>
        `).join('');
    }

    // Render devices
    function renderDevices() {
        if (devices.length === 0) {
            document.getElementById('devicesGrid').innerHTML = '<div class="loading">Tidak ada perangkat terhubung</div>';
            return;
        }

        document.getElementById('devicesGrid').innerHTML = devices.map((device, index) => `
            <div class="device-card" onclick="toggleDetails(${index})">
                <div class="device-header">
                    <div class="device-info">
                        <div class="device-icon">📱</div>
                        <div class="device-name">
                            <h3>${device.hostname || device.name || 'Unknown'}</h3>
                            <p class="device-ip">${device.ipaddr || device.ip}</p>
                        </div>
                    </div>
                    <span class="device-status ${device.connected ? 'status-online' : 'status-offline'}">
                        ${device.connected ? 'Online' : 'Offline'}
                    </span>
                </div>
                
                <div class="device-mac">${device.macaddr || device.mac}</div>
                
                <div class="device-speeds">
                    <div class="speed-box">
                        <h4>⬇️ Download</h4>
                        <div class="speed-value download-color">${formatSpeed(device.rx_bytes || 0)}</div>
                    </div>
                    <div class="speed-box">
                        <h4>⬆️ Upload</h4>
                        <div class="speed-value upload-color">${formatSpeed(device.tx_bytes || 0)}</div>
                    </div>
                </div>
                
                <div class="device-footer">
                    <div class="device-time">
                        🕐 ${formatTime(device.leasetime || device.expires || 0)}
                    </div>
                    <div class="device-total">
                        Total: <span>${formatData((device.rx_bytes || 0) + (device.tx_bytes || 0))}</span>
                    </div>
                </div>

                <div class="device-details">
                    <div class="details-grid">
                        ${createDonutChart(device.rx_bytes || 0, device.tx_bytes || 0, (device.rx_bytes || 0) + (device.tx_bytes || 0))}
                        <div class="bandwidth-info">
                            <h3>Penggunaan Bandwidth</h3>
                            <div class="bandwidth-row">
                                <div class="bandwidth-dot" style="background: #06b6d4;"></div>
                                <span class="bandwidth-label">Download</span>
                                <span class="bandwidth-value download-color">${formatData(device.rx_bytes || 0)}</span>
                            </div>
                            <div class="bandwidth-row">
                                <div class="bandwidth-dot" style="background: #10b981;"></div>
                                <span class="bandwidth-label">Upload</span>
                                <span class="bandwidth-value upload-color">${formatData(device.tx_bytes || 0)}</span>
                            </div>
                            <div class="bandwidth-row">
                                <span class="bandwidth-label" style="margin-left: 24px;">Total</span>
                                <span class="bandwidth-value">${formatData((device.rx_bytes || 0) + (device.tx_bytes || 0))}</span>
                            </div>
                        </div>
                    </div>
                    <div class="current-speeds">
                        <div class="current-speed-box">
                            <h4>⬇️ Download Speed</h4>
                            <div class="current-speed-value download-color">${formatSpeed(device.rx_rate || 0)}</div>
                        </div>
                        <div class="current-speed-box">
                            <h4>⬆️ Upload Speed</h4>
                            <div class="current-speed-value upload-color">${formatSpeed(device.tx_rate || 0)}</div>
                        </div>
                    </div>
                </div>
            </div>
        `).join('');
    }

    // Toggle device details
    function toggleDetails(index) {
        const cards = document.querySelectorAll('.device-card');
        cards.forEach((card, i) => {
            if (i !== index) card.classList.remove('expanded');
        });
        cards[index].classList.toggle('expanded');
    }

    // Real-time chart
    const canvas = document.getElementById('realtimeChart');
    const ctx = canvas.getContext('2d');

    function drawChart() {
        const width = canvas.width = canvas.offsetWidth;
        const height = canvas.height = canvas.offsetHeight;
        
        ctx.clearRect(0, 0, width, height);

        // Grid lines
        ctx.strokeStyle = '#334155';
        ctx.lineWidth = 1;
        for (let i = 0; i <= 4; i++) {
            const y = (height / 4) * i;
            ctx.beginPath();
            ctx.moveTo(0, y);
            ctx.lineTo(width, y);
            ctx.stroke();
        }

        // Find max value for scaling
        const maxValue = Math.max(...chartData.map(d => Math.max(d.download, d.upload))) || 1;

        // Draw download line
        ctx.strokeStyle = '#06b6d4';
        ctx.lineWidth = 2;
        ctx.beginPath();
        chartData.forEach((point, i) => {
            const x = (i / (chartData.length - 1)) * width;
            const y = height - (point.download / maxValue) * height * 0.9;
            if (i === 0) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        });
        ctx.stroke();

        // Draw upload line
        ctx.strokeStyle = '#10b981';
        ctx.beginPath();
        chartData.forEach((point, i) => {
            const x = (i / (chartData.length - 1)) * width;
            const y = height - (point.upload / maxValue) * height * 0.9;
            if (i === 0) ctx.moveTo(x, y);
            else ctx.lineTo(x, y);
        });
        ctx.stroke();
    }

    async function updateData() {
        try {
            // Get devices
            const dhcpLeases = await getDevices();
            devices = dhcpLeases.map(lease => ({
                ...lease,
                connected: true,
                rx_bytes: Math.random() * 1000000000, // Simulasi - ganti dengan data real
                tx_bytes: Math.random() * 500000000,
                rx_rate: Math.random() * 10000000,
                tx_rate: Math.random() * 5000000
            }));

            // Calculate totals
            const totalDownloadSpeed = devices.reduce((sum, d) => sum + (d.rx_rate || 0), 0);
            const totalUploadSpeed = devices.reduce((sum, d) => sum + (d.tx_rate || 0), 0);
            const totalData = devices.reduce((sum, d) => sum + (d.rx_bytes || 0) + (d.tx_bytes || 0), 0);
            const onlineCount = devices.filter(d => d.connected).length;

            // Update chart data
            chartData.shift();
            chartData.push({
                download: totalDownloadSpeed,
                upload: totalUploadSpeed
            });

            // Update legend
            document.getElementById('legendDownload').textContent = 
                `Download: ${formatSpeed(totalDownloadSpeed)}`;
            document.getElementById('legendUpload').textContent = 
                `Upload: ${formatSpeed(totalUploadSpeed)}`;

            // Render
            renderStats(totalDownloadSpeed, totalUploadSpeed, totalData, onlineCount);
            renderDevices();
            drawChart();

        } catch (error) {
            console.error('Update error:', error);
            document.getElementById('errorContainer').innerHTML = 
                '<div class="error">⚠️ Error: Tidak dapat mengambil data dari router. Pastikan skrip dipasang di OpenWRT dengan benar.</div>';
        }
    }

    // Initialize
    async function init() {
        updateTime();
        setInterval(updateTime, 1000);
        
        await authenticate();
        await updateData();
        setInterval(updateData, 2000);
    }

    // Responsive chart
    window.addEventListener('resize', drawChart);

    // Start
    init();
</script>
```

</body>
</html>
EOFHTML
# Set permission
chmod 755 /www/bandwidth
chmod 644 /www/bandwidth/index.html

# Restart uhttpd
/etc/init.d/uhttpd restart

echo "✅ Instalasi selesai!"
echo "Akses di: http://192.168.1.1/bandwidth/"
