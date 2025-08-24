#!/bin/sh

# 🎨 Warna ANSI
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # Reset

REPO_URL="https://raw.githubusercontent.com/ribhy21/forward-sms-modem-android-to-telegram/main/sms%20forward"

loading_bar() {
    echo
    echo -e "${CYAN}[*] Menyimpan konfigurasi...${NC}"
    for i in $(seq 0 100); do
        filled=$((i/2))
        empty=$((50-filled))
        BAR="${GREEN}$(printf '#%.0s' $(seq 1 $filled))${RED}$(printf '.%.0s' $(seq 1 $empty))${NC}"
        echo -ne "\r${YELLOW}[${BAR}] ${CYAN}${i}%%%${NC}"
        sleep 0.02
    done
    echo
}

install_smsforward() {
    clear
    echo -e "${BLUE}=====================================${NC}"
    echo -e "   🚀 ${MAGENTA}Masukkan Konfigurasi Bot Telegram${NC}"
    echo -e "${BLUE}=====================================${NC}"
    printf "${YELLOW}🔑 Masukan Token Bot Telegram : ${NC}"
    read -r BOT_TOKEN

    clear
    echo -e "${BLUE}=====================================${NC}"
    echo -e "   🚀 ${MAGENTA}Masukkan Konfigurasi Bot Telegram${NC}"
    echo -e "${BLUE}=====================================${NC}"
    printf "${YELLOW}💬 Masukan Chat ID Telegram   : ${NC}"
    read -r CHAT_ID

    clear
    echo -e "${BLUE}=====================================${NC}"
    echo -e "   🚀 ${MAGENTA}Masukkan Konfigurasi Bot Telegram${NC}"
    echo -e "${BLUE}=====================================${NC}"
    printf "${YELLOW}🧵 Masukan Thread ID (kosongkan jika tidak ada): ${NC}"
    read -r THREAD_ID

    # Unduh file dari repo
    wget -qO /etc/init.d/smsforward        "$REPO_URL/etc/init.d/smsforward"
    wget -qO /etc/config/smsforward        "$REPO_URL/etc/config/smsforward"
    wget -qO /usr/bin/forward-loop-sms.sh  "$REPO_URL/usr/bin/forward-loop-sms.sh"

    chmod +x /etc/init.d/smsforward
    chmod +x /usr/bin/forward-loop-sms.sh

    # Simpan config
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
    echo -e "${BLUE}=====================================${NC}"
    echo -e "✅ ${GREEN}Konfigurasi berhasil disimpan.${NC}"
    echo -e "📌 Bot Token : ${CYAN}$BOT_TOKEN${NC}"
    echo -e "📌 Chat ID   : ${CYAN}$CHAT_ID${NC}"
    if [ -z "$THREAD_ID" ]; then
        echo -e "📌 Thread ID : ${CYAN}none${NC}"
    else
        echo -e "📌 Thread ID : ${CYAN}$THREAD_ID${NC}"
    fi
    echo -e "${BLUE}=====================================${NC}"
    echo -e "${MAGENTA}Terima kasih sudah menggunakan SMS Forward Bot 🚀${NC}"
    echo
    read -p "$(echo -e ${YELLOW}Tekan Enter untuk kembali ke menu...${NC})"
}

uninstall_smsforward() {
    clear
    echo -e "${RED}[*] Menghapus smsforward...${NC}"
    /etc/init.d/smsforward stop 2>/dev/null || true
    /etc/init.d/smsforward disable 2>/dev/null || true

    rm -f /etc/init.d/smsforward
    rm -f /etc/config/smsforward
    rm -f /usr/bin/forward-loop-sms.sh

    echo -e "${GREEN}[+] smsforward sudah dihapus.${NC}"
    echo
    read -p "$(echo -e ${YELLOW}Tekan Enter untuk kembali ke menu...${NC})"
}

show_menu() {
    clear
    echo -e "${BLUE}=====================================${NC}"
    echo -e "   📦 ${GREEN}SMS Forward Bot Installer${NC}"
    echo -e "${BLUE}=====================================${NC}"
    echo -e " ${CYAN}1) Install${NC}"
    echo -e " ${CYAN}2) Uninstall${NC}"
    echo -e " ${CYAN}3) Cancel${NC}"
    echo -e "${BLUE}=====================================${NC}"
    printf "${YELLOW}Pilih opsi [1-3]: ${NC}"
}

# === MAIN ===
show_menu
read -r CHOICE
case "$CHOICE" in
    1) install_smsforward ;;
    2) uninstall_smsforward ;;
    3) clear; exit 0 ;;
    *) echo -e "${RED}Pilihan tidak valid.${NC}"; exit 1 ;;
esac
