#########################################################################################
#  mkcpp : cración de estructuras de directorios para proyectos en c++
#          Jan 13, 2021 by Jaime Feldman B.
#########################################################################################

#!/bin/bash

#############
#  Colores  #
#############
red='\033[1;91m'
flatRed='\033[0;91m'
green='\033[1;92m'
blue='\033[1;94m'
Yellow='\033[1;93m'
Magenta='\033[1;95m'
NOC='\033[0m'
dark_blue='\033[0;34m'
dark_purple='\033[0;36m'
message_title='\033[1;33m'
message_body='\033[1;02m'
skip_color='\033[0;35m'

###################
#  Configuración  #
###################
repositorio_local="";
nombre_repositorio="cpp.template"
os_name=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    repositorio_local="/home/$USER/development/c++/templates/"
    os_name="Linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    repositorio_local="/Users/$USER/development/c++/templates/"
    os_name="MacOS"
fi

function mensaje() {
    case $1 in
        creando_directorios)
            echo -n "Creando estructura de directorios.....................................["
            ;;
        copiando_archivos)
            echo -n "Copiando archivos.....................................................["
            ;;
        verificando_repositorio_local)
            echo -n "Verificando existencia de repositorio local...........................["
            ;;
        clonando_repositorio)  
            echo -n "Clonando repositorio cpp.template.....................................["
            ;;
        bienvenida)
            echo -e "Creando estructura de proyecto en ${dark_blue}C++${NOC} para${dark_blue} ${os_name}${NOC}"
            ;;
        ok)
            echo -e "${green}OK${NOC}]"
            ;;
        fail)
            echo -e "${red}FAIL${NOC}]"
            ;;
        skip)
            echo -e "${red}SKIP${NOC}]"
            ;;
    esac
}

function clone_repo() {
    echo ""
    mensaje clonando_repositorio
    mkdir -p ${repositorio_local}
    git clone https://github.com/jaimefeldman/cpp.template.git  ${repositorio_local}/cpp.template > /dev/null 2>&1
    mensaje ok
    echo -e "${message_body}repositorio clonado en ${repositorio_local}${NOC}"
}

function copiar_archivos() {
    mensaje copiando_archivos
    echo -e "${message_body}Copindo Makefile..."
    cp ${repositorio_local}/cpp.template/Makefile . > /dev/null 2>&1
    echo -e "Copiando .gitignore..." 
    cp ${repositorio_local}/cpp.template/gitignore .gitignore > /dev/null 2>&1
    mensaje ok
}

function crear_estructura_de_directorios() {

    mensaje creando_directorios
    if [ -d "src" ]; then
        mensaje skip
        exit
    else
       mkdir "src" > /dev/null 2>&1  
    fi

    if [ -d "obj" ]; then
        echo "directorio obj ya existe..."
    else
       mkdir "obj" > /dev/null 2>&1  
    fi

    if [ -d "bin" ]; then
        echo "directorio bin ya existe..."
    else
       mkdir "bin" > /dev/null 2>&1  
    fi
    mensaje ok

}

mensaje bienvenida
if [ $# -gt 0 ]; then
    echo "existen argumentos para analizar..."
else
    # Chequeando si existe el directorio con el repositorio.
    mensaje verificando_repositorio_local
    if [ -d "${repositorio_local}${nombre_repositorio}" ]; then
        # El repositorio existe y tiene los archivos para ser copiados en el directorio.
        mensaje ok
        crear_estructura_de_directorios
    else
        mensaje fail
        echo -e "${message_title}Mensaje:${NOC}${message_body}\n\tEl repositorio no se encuentra en ${repositorio_local}"
        echo -e "\tmodifique la variable del script ${0} en la linea repositorio_local="
		echo -e "\the indique la ruta al repositorio${NOC}"
        echo 
        read -p "¿Desea clonar el repositorio en la ruta por defecnto? [Si/no]:" answer
        case $answer in
            "")
                clone_repo
                ;;
             s | S)
                clone_repo
                ;;
            n | N)
                echo -e "${message_body}\n\tPuede clonar el repositorio cpp.template, desde github"
                echo -e "\ten su equipo y luego indicar la ruta en la variable repositorio_local="
                echo -e "\ten el archivo de script $0"
                echo 
                echo -e "\tgit clone https://github.com/jaimefeldman/cpp.template.git"

                echo
                ;;
            *)
                echo "respuesta no valida..."
                echo -e "${message_body}adios..${NOC}"
                ;;
        esac
    fi
fi

