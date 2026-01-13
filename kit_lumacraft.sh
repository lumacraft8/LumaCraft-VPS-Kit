#!/bin/bash

# ======================================================
# ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗
# ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
# ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗      ██║   
# ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝      ██║   
# ███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   
# ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   
#
#           🚀 INSTALADOR INTEGRAL LUMACRAFT 🚀
#                By SrxMateo & Gemini AI
# ======================================================

# Colores y estilo
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
WHITE="\033[1;37m"
RESET="\033[0m"

# Variables de seguimiento
INST_JAVA="No"
INST_TOOLS="No"
INST_DB="No"
INST_NET="No"
INST_FW="No"

# --- FUNCIÓN DE LOGO ---
mostrar_logo() {
    clear
    echo -e "${CYAN}"
    echo " ██╗      ██╗   ██╗███╗   ███╗ █████╗  ██████╗██████╗  █████╗ ███████╗████████╗"
    echo " ██║      ██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝"
    echo " ██║      ██║   ██║██╔████╔██║███████║██║     ██████╔╝███████║█████╗      ██║   "
    echo " ██║      ██║   ██║██║╚██╔╝██║██╔══██║██║     ██╔══██╗██╔══██║██╔══╝      ██║   "
    echo " ███████╗╚██████╔╝██║ ╚═╝ ██║██║  ██║╚██████╗██║  ██║██║  ██║██║        ██║   "
    echo " ╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝        ╚═╝   "
    echo -e "            ${WHITE}• KIT PROFESIONAL PARA VPS •${RESET}"
    echo -e "==========================================================================${RESET}"
}

# Función de pregunta
confirmar() {
    read -p "$(echo -e "${YELLOW}❓ $1 (s/n): ${RESET}")" choice
    case "$choice" in 
      s|S|y|Y ) return 0;;
      * ) return 1;;
    esac
}

mostrar_logo

# 1. Limpieza inicial
if confirmar "¿Quieres limpiar y actualizar la VPS antes de empezar?"; then
    echo -e "${GREEN}🔄 Limpiando software innecesario y actualizando...${RESET}"
    sudo apt update && sudo apt upgrade -y
    sudo apt autoremove -y &> /dev/null
fi

# 2. Selección de Java
echo -e "\n${CYAN}☕ SELECCIÓN DE JAVA${RESET}"
echo "1) Java 21 (Recomendado: 1.20.5+ y Velocity)"
echo "2) Java 17 (Para 1.17 hasta 1.20.4)"
echo "3) Java 8  (Para 1.8)"
echo "4) Instalar TODOS (8, 17 y 21)"
echo "5) Omitir"
read -p "Opción (1-5): " j_choice

if [ "$j_choice" -le 4 ]; then
    echo -e "${GREEN}📥 Configurando repositorios de Java...${RESET}"
    wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add - &> /dev/null
    sudo add-apt-repository --yes https://packages.adoptium.net/artifactory/deb/ &> /dev/null
    sudo apt update &> /dev/null
    case $j_choice in
        1) sudo apt install -y temurin-21-jdk; INST_JAVA="Java 21" ;;
        2) sudo apt install -y temurin-17-jdk; INST_JAVA="Java 17" ;;
        3) sudo apt install -y temurin-8-jdk; INST_JAVA="Java 8" ;;
        4) sudo apt install -y temurin-8-jdk temurin-17-jdk temurin-21-jdk; INST_JAVA="8, 17 y 21" ;;
    esac
fi

# 3. Herramientas y DB
echo -e "\n${CYAN}🛠️ HERRAMIENTAS Y BASE DE DATOS${RESET}"
if confirmar "¿Instalar herramientas de gestión (Screen, Btop, UFW)?"; then
    sudo apt install -y screen btop ufw
    INST_TOOLS="Screen, Btop y UFW"
fi

if confirmar "¿Instalar MariaDB (MySQL)?"; then
    sudo apt install -y mariadb-server
    sudo systemctl start mariadb
    INST_DB="MariaDB (Instalada)"
fi

# 4. Estructura de Red y Scripts
echo -e "\n${CYAN}📁 GESTIÓN DE ARCHIVOS${RESET}"
if confirmar "¿Crear estructura de carpetas y scripts de inicio?"; then
    read -p "Nombre de la carpeta de la Network: " n_dir
    mkdir -p ~/$n_dir/{Proxy,Lobby,Survival}
    
    # Crear script de inicio base
    cat <<EOT > ~/$n_dir/Lobby/iniciar.sh
#!/bin/bash
java -Xms1G -Xmx2G -jar server.jar nogui
EOT
    chmod +x ~/$n_dir/Lobby/iniciar.sh
    INST_NET="~/$n_dir (Con scripts base)"
fi

# 5. Firewall
echo -e "\n${CYAN}🛡️ SEGURIDAD${RESET}"
if confirmar "¿Activar Firewall (Puertos 22 y 25565)?"; then
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow 22/tcp
    sudo ufw allow 25565/tcp
    echo "y" | sudo ufw enable
    INST_FW="Protegido (SSH:22, MC:25565)"
fi

# ======================================================
# 🏁 EXPLICACIÓN FINAL Y RESUMEN
# ======================================================
mostrar_logo
echo -e "${GREEN}         ✅ INSTALACIÓN COMPLETADA CON ÉXITO"
echo -e "==========================================================================${RESET}"
echo -e "${WHITE}Resumen de configuración en esta VPS:${RESET}"
echo ""
echo -e "${CYAN}🔹 Java Instalado: ${YELLOW}$INST_JAVA${RESET}"
echo -e "${CYAN}🔹 Utilidades:    ${YELLOW}$INST_TOOLS${RESET}"
echo -e "${CYAN}🔹 Base de Datos: ${YELLOW}$INST_DB${RESET}"
echo -e "${CYAN}🔹 Directorio:    ${YELLOW}$INST_NET${RESET}"
echo -e "${CYAN}🔹 Seguridad:     ${YELLOW}$INST_FW${RESET}"
echo ""
echo -e "${WHITE}Explicación de acciones realizadas:${RESET}"

if [ "$INST_FW" != "No" ]; then
    echo "- Seguridad: Tu VPS ahora solo acepta tráfico por el puerto del Proxy (25565) y tu consola (22)."
else
    echo -e "- ${RED}¡ALERTA!: El Firewall está desactivado. Tu red es vulnerable.${RESET}"
fi

if [ "$INST_NET" != "No" ]; then
    echo "- Archivos: Tienes la estructura lista. Se ha incluido un 'iniciar.sh' de ejemplo."
fi

echo -e "\n${YELLOW}👉 Próximos pasos: Sube tus .jar y usa 'screen -S nombre ./iniciar.sh'${RESET}"
echo -e "${CYAN}==========================================================================${RESET}"
