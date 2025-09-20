#!/bin/bash

# Script para automatizar cracking de hashes con hashcat
# Uso: ./crack_hashes.sh archivo_de_hashes.txt

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que se proporcionó un archivo de hashes
if [ $# -eq 0 ]; then
    echo -e "${RED}Error:${NC} Debes proporcionar un archivo con hashes."
    echo "Uso: $0 archivo_de_hashes.txt"
    exit 1
fi

HASH_FILE="$1"
WORDLIST="RUTA DE DICCIONARIO"

# Verificar que el archivo de hashes existe
if [ ! -f "$HASH_FILE" ]; then
    echo -e "${RED}Error:${NC} El archivo '$HASH_FILE' no existe."
    exit 1
fi

# Verificar que la wordlist existe
if [ ! -f "$WORDLIST" ]; then
    echo -e "${RED}Error:${NC} No se encuentra la wordlist '$WORDLIST'."
    echo "Asegúrate de que rockyou.txt esté descomprimido."
    exit 1
fi

# Crear directorio para resultados
RESULTS_DIR="hashcat_results"
mkdir -p "$RESULTS_DIR"

# Función para clasificar hashes por tipo
clasificar_hashes() {
    echo -e "${YELLOW}[+] Clasificando hashes por tipo...${NC}"
    
    # Inicializar archivos temporales
    > "${RESULTS_DIR}/md5_hashes.txt"
    > "${RESULTS_DIR}/sha1_hashes.txt"
    > "${RESULTS_DIR}/sha256_hashes.txt"
    > "${RESULTS_DIR}/bcrypt_hashes.txt"
    > "${RESULTS_DIR}/sha512crypt_hashes.txt"
    > "${RESULTS_DIR}/unknown_hashes.txt"
    
    # Leer cada hash y clasificarlo
    while IFS= read -r hash; do
        # Eliminar espacios en blanco
        hash=$(echo "$hash" | xargs)
        
        # Saltar líneas vacías
        if [ -z "$hash" ]; then
            continue
        fi
        
        # Clasificar por patrón
        if [[ $hash =~ ^[0-9a-fA-F]{32}$ ]]; then
            echo "$hash" >> "${RESULTS_DIR}/md5_hashes.txt"
            echo -e "${GREEN}[+]${NC} Hash clasificado como MD5: $hash"
        elif [[ $hash =~ ^[0-9a-fA-F]{40}$ ]]; then
            echo "$hash" >> "${RESULTS_DIR}/sha1_hashes.txt"
            echo -e "${GREEN}[+]${NC} Hash clasificado como SHA1: $hash"
        elif [[ $hash =~ ^[0-9a-fA-F]{64}$ ]]; then
            echo "$hash" >> "${RESULTS_DIR}/sha256_hashes.txt"
            echo -e "${GREEN}[+]${NC} Hash clasificado como SHA-256: $hash"
        elif [[ $hash == *'$2y$'* ]] || [[ $hash == *'$2a$'* ]] || [[ $hash == *'$2b$'* ]]; then
            echo "$hash" >> "${RESULTS_DIR}/bcrypt_hashes.txt"
            echo -e "${GREEN}[+]${NC} Hash clasificado como bcrypt: $hash"
        elif [[ $hash == *'$6$'* ]]; then
            echo "$hash" >> "${RESULTS_DIR}/sha512crypt_hashes.txt"
            echo -e "${GREEN}[+]${NC} Hash clasificado como SHA-512crypt: $hash"
        else
            echo "$hash" >> "${RESULTS_DIR}/unknown_hashes.txt"
            echo -e "${RED}[!]${NC} Tipo de hash desconocido: $hash"
        fi
    done < "$HASH_FILE"
}

# Función para ejecutar hashcat
ejecutar_hashcat() {
    local modo=$1
    local archivo_hashes=$2
    local nombre_salida=$3
    
    if [ -s "$archivo_hashes" ]; then
        echo -e "${YELLOW}[+] Ejecutando hashcat para modo $modo...${NC}"
        
        # Opción de optimización para hashes lentos
        local opciones_extra=""
        if [ "$modo" -eq 3200 ] || [ "$modo" -eq 1800 ]; then
            opciones_extra="-O -w 3"
            echo -e "${YELLOW}[+] Usando optimización para hash lento (modo $modo)${NC}"
        fi
        
        hashcat -m "$modo" -a 0 $opciones_extra -o "${RESULTS_DIR}/${nombre_salida}" "$archivo_hashes" "$WORDLIST"
        
        # Mostrar resultados
        if [ -f "${RESULTS_DIR}/${nombre_salida}" ]; then
            echo -e "${GREEN}[+] Resultados para modo $modo:${NC}"
            cat "${RESULTS_DIR}/${nombre_salida}"
            echo ""
        fi
    else
        echo -e "${YELLOW}[!] No hay hashes de tipo $modo para crackear${NC}"
    fi
}

# Clasificar los hashes
clasificar_hashes

# Ejecutar hashcat para cada tipo de hash
ejecutar_hashcat 0 "${RESULTS_DIR}/md5_hashes.txt" "resultados_md5.txt"
ejecutar_hashcat 100 "${RESULTS_DIR}/sha1_hashes.txt" "resultados_sha1.txt"
ejecutar_hashcat 1400 "${RESULTS_DIR}/sha256_hashes.txt" "resultados_sha256.txt"
ejecutar_hashcat 3200 "${RESULTS_DIR}/bcrypt_hashes.txt" "resultados_bcrypt.txt"
ejecutar_hashcat 1800 "${RESULTS_DIR}/sha512crypt_hashes.txt" "resultados_sha512crypt.txt"

# Mostrar hashes no clasificados
if [ -s "${RESULTS_DIR}/unknown_hashes.txt" ]; then
    echo -e "${RED}[!] Hashes con tipo desconocido:${NC}"
    cat "${RESULTS_DIR}/unknown_hashes.txt"
fi

echo -e "${GREEN}[+] Proceso completado. Resultados guardados en la carpeta '$RESULTS_DIR'${NC}"
