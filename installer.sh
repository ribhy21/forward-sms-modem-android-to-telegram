#!/bin/sh
# installer.sh — Forward SMS Modem Android to Telegram (OpenWrt)

set -e

REPO_URL="https://raw.githubusercontent.com/ribhy21/forward-sms-modem-android-to-telegram/main/sms%20forward"

show_menu() {
    clear
    echo "====================================="
    echo "   📦 SMS Forward Bot Installer"
    echo "====================================="
    echo " 1) Install"
    echo " 2) Uninstall"
    echo " 3) Cancel"
    echo "====================================="
    printf "Pilih opsi [1-3]: "
}

install_smsforward() {
    echo "[*] Mengunduh & menginstal smsforward..."

    wget -qO /etc/init.d/smsforward        "$REPO_URL/etc/init.d/smsforward"
    wget -qO /etc/config/smsforward        "$REPO_URL/etc/config/smsforward"
    wget -qO /usr/bin/forward-loop-sms.sh  "$REPO_URL/usr/bin/forward-loop-sms.sh"

    chmod +x /etc/init.d/smsforward
    chmod +x /usr/bin/forward-loop-sms.sh

    printf "Masukkan Bot Token Telegram: "
    read -r BOT_TOKEN
    printf "Masukkan Chat ID Telegram: "
    read -r CHAT_ID
    printf "Masukkan Thread ID Telegram (boleh kosong): "
    read -r THREAD_ID

    cat > /etc/config/smsforward <<EOF
config smsforward 'main'
    option bot_token '$BOT_TOKEN'
    option chat_id '$CHAT_ID'
    option thread_id '$THREAD_ID'
EOF

    chmod 600 /etc/config/smsforward

    /etc/init.d/smsforward enable
    /etc/init.d/smsforward restart

    echo
    echo "[+] Instalasi selesai."
    echo "   Bot Token : $BOT_TOKEN"
    echo "   Chat ID   : $CHAT_ID"
    echo "   Thread ID : $THREAD_ID"
}

uninstall_smsforward() {
    echo "[*] Menghapus smsforward..."
    /etc/init.d/smsforward stop 2>/dev/null || true
    /etc/init.d/smsforward disable 2>/dev/null || true

    rm -f /etc/init.d/smsforward
    rm -f /etc/config/smsforward
    rm -f /usr/bin/forward-loop-sms.sh

    echo "[+] smsforward sudah dihapus."
}

# --- MAIN ---
show_menu
read -r CHOICE

case "$CHOICE" in
    1) install_smsforward ;;
    2) uninstall_smsforward ;;
    3) echo "Batal."; exit 0 ;;
    *) echo "Pilihan tidak valid."; exit 1 ;;
esac

