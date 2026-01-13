#!/bin/bash

# ======================================================
# ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗
# ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
# ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗     ██║   
# ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝     ██║   
# ███████╗ ╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   
# ╚══════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
#           🚀 LUMACRAFT MULTI-LANGUAGE KIT 🚀
#                By SrxMateo
# ======================================================

# Colores
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
WHITE="\033[1;37m"
RESET="\033[0m"

# --- SELECCIÓN DE IDIOMA ---
clear
echo -e "${CYAN}======================================================"
echo "    CHOOSE YOUR LANGUAGE / ELIGE TU IDIOMA"
echo -e "======================================================${RESET}"
echo "1) Español"
echo "2) English"
echo "3) Français"
read -p "Select (1-3): " lang_choice

case $lang_choice in
    1) # ESPAÑOL
       T_WELCOME="BIENVENIDO AL INSTALADOR DE LUMACRAFT"
       T_CLEAN="¿Quieres limpiar y actualizar la VPS?"; T_JAVA_TITLE="SELECCIÓN DE JAVA"
       T_JAVA_OPT="Elija una opción (1-5):"; T_TOOLS="¿Instalar Screen, Btop y UFW?"
       T_DB="¿Instalar MariaDB (MySQL)?"; T_NET="¿Crear carpetas y scripts de inicio?"
       T_NET_NAME="Nombre de la carpeta principal:"; T_FW="¿Activar Firewall (Puertos 22 y 25565)?"
       T_DONE="INSTALACIÓN COMPLETADA"; T_DESC="Resumen de acciones:"; S_YES="s";;
    2) # ENGLISH
       T_WELCOME="WELCOME TO LUMACRAFT INSTALLER"
       T_CLEAN="Do you want to clean and update the VPS?"; T_JAVA_TITLE="JAVA SELECTION"
       T_JAVA_OPT="Choose an option (1-5):"; T_TOOLS="Install Screen, Btop, and UFW?"
       T_DB="Install MariaDB (MySQL)?"; T_NET="Create folders and start scripts?"
       T_NET_NAME="Main folder name:"; T_FW="Enable Firewall (Ports 22 & 25565)?"
       T_DONE="INSTALLATION COMPLETED"; T_DESC="Actions summary:"; S_YES="y";;
    3) # FRANÇAIS
       T_WELCOME="BIENVENUE DANS L'INSTALLATEUR LUMACRAFT"
       T_CLEAN="Voulez-vous nettoyer et mettre à jour le VPS?"; T_JAVA_TITLE="SÉLECTION DE JAVA"
       T_JAVA_OPT="Choisissez une option (1-5) :"; T_TOOLS="Installer Screen, Btop et UFW ?"
       T_DB="Installer MariaDB (MySQL) ?"; T_NET="Créer des dossiers et scripts de démarrage ?"
       T_NET_NAME="Nom du dossier principal :"; T_FW="Activer le Firewall (Ports 22 & 25565) ?"
       T_DONE="INSTALLATION TERMINÉE"; T_DESC="Résumé des actions :"; S_YES="o";;
    *) echo "Invalid choice"; exit 1;;
esac

# Variables de seguimiento
INST_JAVA="No"; INST_TOOLS="No"; INST_DB="No"; INST_NET="No"; INST_FW="No"

# --- FUNCIONES ---
mostrar_logo() {
    clear
    echo -e "${CYAN}"
    echo " ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗"
    echo " ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝"
    echo " ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗     ██║   "
    echo " ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝     ██║   "
    echo " ███████╗ ╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   "
    echo " ╚══════╝  ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   "
    echo -e "            ${WHITE}• $T_WELCOME •${RESET}"
}

confirmar() {
    read -p "$(echo -e "${YELLOW}❓ $1 ($S_YES/n): ${RESET}")" choice
    case "$choice" in $S_YES|${S_YES^^} ) return 0;; * ) return 1;; esac
}

# --- INICIO ---
mostrar_logo
if confirmar "$T_CLEAN"; then sudo apt update && sudo apt upgrade -y; fi

echo -e "\n${CYAN}☕ $T_JAVA_TITLE${RESET}"
echo "1) Java 21  2) Java 17  3) Java 8  4) ALL  5) Skip"
read -p "$T_JAVA_OPT " j_choice
if [ "$j_choice" -le 4 ]; then
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add - &> /dev/null
    sudo add-apt-repository --yes https://packages.adoptium.net/artifactory/deb/ &> /dev/null
    sudo apt update &> /dev/null
    case $j_choice in
        1) sudo apt install -y temurin-21-jdk; INST_JAVA="Java 21" ;;
        2) sudo apt install -y temurin-17-jdk; INST_JAVA="Java 17" ;;
        3) sudo apt install -y temurin-8-jdk; INST_JAVA="Java 8" ;;
        4) sudo apt install -y temurin-8-jdk temurin-17-jdk temurin-21-jdk; INST_JAVA="8, 17 & 21" ;;
    esac
fi

if confirmar "$T_TOOLS"; then sudo apt install -y screen btop ufw; INST_TOOLS="Yes"; fi
if confirmar "$T_DB"; then sudo apt install -y mariadb-server; sudo systemctl start mariadb; INST_DB="Yes"; fi

if confirmar "$T_NET"; then
    read -p "$T_NET_NAME " n_dir
    mkdir -p ~/$n_dir/{Proxy,Lobby,Survival}
    echo "java -Xmx2G -jar server.jar nogui" > ~/$n_dir/Lobby/iniciar.sh
    chmod +x ~/$n_dir/Lobby/iniciar.sh
    INST_NET="~/$n_dir"
fi

if confirmar "$T_FW"; then
    sudo ufw allow 22/tcp && sudo ufw allow 25565/tcp
    echo "y" | sudo ufw enable; INST_FW="Active (22, 25565)"
fi

# --- RESUMEN FINAL ---
mostrar_logo
echo -e "${GREEN}         ✅ $T_DONE"
echo -e "======================================================${RESET}"
echo -e "${WHITE}$T_DESC${RESET}"
echo -e "${CYAN}🔹 Java:${RESET} $INST_JAVA | ${CYAN}🔹 Herramientas:${RESET} $INST_TOOLS"
echo -e "${CYAN}🔹 DB:${RESET} $INST_DB | ${CYAN}🔹 Net:${RESET} $INST_NET | ${CYAN}🔹 Firewall:${RESET} $INST_FW"
echo -e "\n${YELLOW}👉 Próximos pasos: l-kit (ejecución global)${RESET}"
