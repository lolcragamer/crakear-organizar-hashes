# 🔓 Hash Cracking Automation Script

![Kali Linux](https://img.shields.io/badge/Kali_Linux-557C94?style=for-the-badge&logo=kali-linux&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Hashcat](https://img.shields.io/badge/Hashcat-000000?style=for-the-badge&logo=hashcat&logoColor=white)

> Script automatizado para cracking de múltiples tipos de hashes usando Hashcat en sistemas Linux

# Demo
![hashes](https://github.com/user-attachments/assets/46851c28-2aee-4fc9-ab69-c2e7b3adaaf4)

## ✨ Características

- 🔍 **Detección automática** de tipos de hash (MD5, SHA1, SHA-256, bcrypt, etc.)
- 🚀 **Ejecución optimizada** con soporte para GPU
- 📊 **Resultados organizados** en carpetas separadas
- 🎨 **Interfaz colorida** para mejor experiencia de usuario
- ⚡ **Optimización inteligente** para hashes lentos (bcrypt, SHA-512crypt)
- ❓ **Manejo de errores** con reporte de hashes no identificados

## 📋 Requisitos

- ✅ Kali Linux o distribución Linux compatible
- ✅ Hashcat instalado
- ✅ Diccionario de contraseñas (rockyou.txt recomendado)

## 🚀 Instalación Rápida

1. **Clona el repositorio**:
```bash
git clone https://github.com/lolcragamer/hash-cracking-automation.git
cd hash-cracking-automation
```

2. **Prepara el entorno**:
```bash
# Convierte formato de línea si es necesario
sudo apt install dos2unix
dos2unix crack_hashes.sh

# Da permisos de ejecución
chmod +x crack_hashes.sh

# Asegura que rockyou.txt esté descomprimido
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
```

## 🛠 Configuración

### Personalizar diccionario
Edita la variable `WORDLIST` en el script para usar tu propio diccionario:

```bash
# Abre el script con tu editor favorito
nano Crack_hashes.sh

# Busca y modifica esta línea (aprox. línea 25)
WORDLIST="/ruta/a/tu/diccionario.txt"
```

### Tipos de hash soportados
| Tipo de Hash | Modo Hashcat | Ejemplo |
|--------------|--------------|---------|
| MD5 | 0 | `48bb6e862e54f2a795ffc4e541caed4d` |
| SHA1 | 100 | `CBFDAC6008F9CAB4083784CBD1874F76618D2A97` |
| SHA-256 | 1400 | `1C8BFE8F801D79745C4631D09FFF36C82AA37FC4CCE4FC946683D7B336B63032` |
| bcrypt | 3200 | `$2y$12$Dwt1BZj6pcyc3Dy1FWZ5ieeUznr71EeNkJkUlypTsgbX1H68wsRom` |
| SHA-512crypt | 1800 | `$6$aReallyHardSalt$6WKUTqzq.UQQmrm0p/T7MPpMbGNnzXPMAXi4bJMl9be.cfi3/qxIf.hsGpS41BqMhSrHVXgMpdjS6xeKZAs02.` |

## 💻 Uso

### Ejecución básica
```bash
./crack_hashes.sh hashes.txt
```

### Ejemplo con archivo personalizado
```bash
# Crea tu archivo de hashes
echo "48bb6e862e54f2a795ffc4e541caed4d" > mis_hashes.txt
echo "CBFDAC6008F9CAB4083784CBD1874F76618D2A97" >> mis_hashes.txt

# Ejecuta el script
./crack_hashes.sh mis_hashes.txt
```

### Estructura de resultados
El script crea la siguiente estructura de carpetas:
```
hashcat_results/
├── md5_hashes.txt
├── sha1_hashes.txt
├── sha256_hashes.txt
├── bcrypt_hashes.txt
├── sha512crypt_hashes.txt
├── unknown_hashes.txt
├── resultados_md5.txt
├── resultados_sha1.txt
├── resultados_sha256.txt
├── resultados_bcrypt.txt
└── resultados_sha512crypt.txt
```
![muestra](https://github.com/user-attachments/assets/a90b3fe5-d2d5-44a2-a974-91dbd0128050)


## ⚠️ Solución de Problemas

### Error: "bad interpreter: /bin/bash^M"
```bash
# Solución:
sudo apt install dos2unix
dos2unix crack_hashes.sh
chmod +x crack_hashes.sh
```

### Error: "rockyou.txt not found"
```bash
# Solución:
sudo gunzip /usr/share/wordlists/rockyou.txt.gz
```

### Rendimiento lento con bcrypt
- El script aplica automáticamente optimizaciones para hashes bcrypt
- Considera usar una GPU para mejor rendimiento
- Para sistemas con poca RAM, reduce el parámetro `-w` en el script

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Por favor:

1. Haz un fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 👨‍💻 Autor

**lolcragamer**
- GitHub: [@lolcragamer](https://github.com/lolcragamer)


## 🔗 Enlaces Útiles

- [📚 Documentación de Hashcat](https://hashcat.net/wiki/)
- [🐧 Kali Linux Documentation](https://www.kali.org/docs/)
- [💾 Diccionarios de contraseñas comunes](https://github.com/danielmiessler/SecLists)

---

⭐️ ¡Si este proyecto te fue útil, por favor dale una estrella en GitHub!
