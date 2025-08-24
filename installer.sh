#!/bin/sh
# installer.sh — Installer smsforward for OpenWrt

set -e

echo "[*] Installing smsforward ..."

# Copy files ke tempat yang sesuai
install -Dm755 "sms forward/etc/init.d/smsforward" /etc/init.d/smsforward
install -Dm644 "sms forward/etc/config/smsforward" /etc/config/smsforward
install -Dm755 "sms forward/usr/bin/forward-loop-sms.sh" /usr/bin/forward-loop-sms.sh

# Tanyakan input user
printf "Masukkan Bot Token Telegram: "
read -r BOT_TOKEN
printf "Masukkan Chat ID Telegram: "
read -r CHAT_ID
printf "Masukkan Thread ID Telegram (boleh kosong): "
read -r THREAD_ID

# Tulis config baru
cat > /etc/config/smsforward <<EOF
config smsforward 'main'
    option bot_token '$BOT_TOKEN'
    option chat_id '$CHAT_ID'
    option thread_id '$THREAD_ID'
EOF

# Set permission
chmod 600 /etc/config/smsforward

# Enable service
/etc/init.d/smsforward enable
/etc/init.d/smsforward restart

echo "[+] Instalasi selesai."
echo "   Bot Token : $BOT_TOKEN"
echo "   Chat ID   : $CHAT_ID"
echo "   Thread ID : $THREAD_ID"
