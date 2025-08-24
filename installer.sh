#!/bin/sh
# installer.sh — Forward SMS Modem Android to Telegram (OpenWrt)
# Eksekusi langsung via: 
# bash -c "$(wget -qO - 'https://raw.githubusercontent.com/ribhy21/forward-sms-modem-android-to-telegram/main/installer.sh')"

set -e

REPO_URL="https://raw.githubusercontent.com/ribhy21/forward-sms-modem-android-to-telegram/main/sms%20forward"

echo "[*] Mengunduh & menginstal smsforward..."

# Unduh file dan pasang
wget -qO /etc/init.d/smsforward     "$REPO_URL/etc/init.d/smsforward"
wget -qO /etc/config/smsforward     "$REPO_URL/etc/config/smsforward"
wget -qO /usr/bin/forward-loop-sms.sh "$REPO_URL/usr/bin/forward-loop-sms.sh"

chmod +x /etc/init.d/smsforward
chmod +x /usr/bin/forward-loop-sms.sh

# Input user
printf "Masukkan Bot Token Telegram: "
read -r BOT_TOKEN
printf "Masukkan Chat ID Telegram: "
read -r CHAT_ID
printf "Masukkan Thread ID Telegram (boleh kosong): "
read -r THREAD_ID

# Tulis ulang config
cat > /etc/config/smsforward <<EOF
config smsforward 'main'
    option bot_token '$BOT_TOKEN'
    option chat_id '$CHAT_ID'
    option thread_id '$THREAD_ID'
EOF

chmod 600 /etc/config/smsforward

# Enable & jalankan service
/etc/init.d/smsforward enable
/etc/init.d/smsforward restart

echo
echo "[+] Instalasi selesai."
echo "   Bot Token : $BOT_TOKEN"
echo "   Chat ID   : $CHAT_ID"
echo "   Thread ID : $THREAD_ID"
