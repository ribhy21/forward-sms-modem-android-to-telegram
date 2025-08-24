#!/bin/sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

REPO_URL="https://raw.githubusercontent.com/ribhy21/forward-sms-modem-android-to-telegram/main/sms%20forward"

loading_bar() {
    echo
    echo -ne "${CYAN}[*] Menyimpan konfigurasi...${NC}\n"
    for i in $(seq 0 100); do
        BAR=$(printf "%-${i}s" "#" | tr ' ' '#')
        echo -ne "\r${GREEN}[${BAR:0:50}]${NC} ${i}%%"
        sleep 0.02
    done
    echo
}

install_smsforward() {
    clear
    echo -e "====================================="
    echo -e "   🚀 Masukkan Konfigurasi Bot Telegram"
    echo -e "====================================="
    printf "🔑 Masukan Token Bot Telegram : "
    read -r BOT_TOKEN

    clear
    echo -e "====================================="
    echo -e "   🚀 Masukkan Konfigurasi Bot Telegram"
    echo -e "====================================="
    printf "💬 Masukan Chat ID Telegram   : "
    read -r CHAT_ID

    clear
    echo -e "====================================="
    echo -e "   🚀 Masukkan Konfigurasi Bot Telegram"
    echo -e "====================================="
    printf "🧵 Masukan Thread ID (kosongkan jika tidak ada): "
    read -r THREAD_ID

    # unduh file
    wget -qO /etc/init.d/smsforward        "$REPO_URL/etc/init.d/smsforward"
    wget -qO /etc/config/smsforward        "$REPO_URL/etc/config/smsforward"
    wget -qO /usr/bin/forward-loop-sms.sh  "$REPO_URL/usr/bin/forward-loop-sms.sh"

    chmod +x /etc/init.d/smsforward
    chmod +x /usr/bin/forward-loop-sms.sh

    cat > /etc/config/smsforward <<EOF
config smsforward 'main'
    option bot_token '$BOT_TOKEN'
    option chat_id '$CHAT_ID'
    option thread_id '$THREAD_ID'
EOF

    chmod 600 /etc/config/smsforward

    /etc/init.d/smsforward enable
    /etc/init.d/smsforward restart

    loading_bar

    clear
    echo -e "====================================="
    echo -e "✅ Konfigurasi berhasil disimpan."
    echo -e "📌 Bot Token : ${YELLOW}$BOT_TOKEN${NC}"
    echo -e "📌 Chat ID   : ${YELLOW}$CHAT_ID${NC}"
    if [ -z "$THREAD_ID" ]; then
        echo -e "📌 Thread ID : ${YELLOW}none${NC}"
    else
        echo -e "📌 Thread ID : ${YELLOW}$THREAD_ID${NC}"
    fi
    echo -e "====================================="
    echo -e "Terima kasih sudah menggunakan SMS Forward Bot 🚀"
    echo
    read -p "Tekan Enter untuk kembali ke menu..."
}

uninstall_smsforward() {
    echo "[*] Menghapus smsforward..."
    /etc/init.d/smsforward stop 2>/dev/null || true
    /etc/init.d/smsforward disable 2>/dev/null || true

    rm -f /etc/init.d/smsforward
    rm -f /etc/config/smsforward
    rm -f /usr/bin/forward-loop-sms.sh

    echo "[+] smsforward sudah dihapus."
    read -p "Tekan Enter untuk kembali ke menu..."
}

show_menu() {
    clear
    echo -e "====================================="
    echo -e "   📦 ${GREEN}SMS Forward Bot Installer${NC}"
    echo -e "====================================="
    echo -e " ${CYAN}1) Install${NC}"
    echo -e " ${CYAN}2) Uninstall${NC}"
    echo -e " ${CYAN}3) Cancel${NC}"
    echo -e "====================================="
    printf "Pilih opsi [1-3]: "
}

# MAIN
show_menu
read -r CHOICE
case "$CHOICE" in
    1) install_smsforward ;;
    2) uninstall_smsforward ;;
    3) clear; exit 0 ;;
    *) echo "Pilihan tidak valid."; exit 1 ;;
esac
