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
            echo -n "Creando estructura de directorios................["
            ;;
        copiando_archivos)
            echo -n "Copiando archivos................................["
            ;;
        verificando_repositorio_local)
            echo -n "Verificando repositorio local....................["
            ;;
        clonando_repositorio)  
            echo -n "Clonando cpp.template............................["
            ;;
        eliminando_proyecto)
            echo -n "Limpiando el directorio..........................["
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
            echo -e "${skip_color}SKIP${NOC}]"
            ;;
      esac
}

function clean {
    if [ -d "src" ] || [ -d "obj" ] || [ -d "bin" ]; then

        echo -e "${message_title}Atención!"
        echo -e "\t${message_body}El proyecto se eliminará por completo y no se podra recuperar.${NOC}"
        echo
        read -p "¿Desea continuar? [S/n]:" answer
        case $answer in
                "")
                    mensaje eliminando_proyecto
                    rm -rf src/ obj/ bin/ Makefile .gitignore > /dev/null 2>&1
                    mensaje ok
                    ;;
                s | S)
                    mensaje eliminando_proyecto
                    rm -rf src/ obj/ bin/ Makefile .gitignore > /dev/null 2>&1
                    mensaje ok
                    ;;
                n | N)
                    exit 0
                    ;;
                *)
                    exit 0
                    ;;
            esac
    else 
        echo -e "${NOC}Nada que eliminar..."
    fi

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
    cp ${repositorio_local}${nombre_repositorio}/Makefile . > /dev/null 2>&1
    cp ${repositorio_local}${nombre_repositorio}/gitignore .gitignore > /dev/null 2>&1
    if [ -d "src" ]; then
        cp ${repositorio_local}${nombre_repositorio}/Launcher.cpp src/Launcher.cpp > /dev/null 2>&1
    else
        echo "el dir src no encontrado..."
    fi
    mensaje ok
}

function mensaje_terminate_script() {
   
    mensaje skip
    echo -e "${message_body}Los directorios ya existen, saliendo del scritp.${NOC}"
    exit -1
}

function crear_estructura_de_directorios() {

    mensaje creando_directorios
    if [ -d "src" ]; then
        mensaje_terminate_script
    else
       mkdir -p "src/clases" > /dev/null 2>&1  
    fi

    if [ -d "obj" ]; then
        mensaje_terminate_script
    else
       mkdir "obj" > /dev/null 2>&1  
    fi

    if [ -d "bin" ]; then
        mensaje_terminate_script
    else
       mkdir "bin" > /dev/null 2>&1  
    fi
    mensaje ok
}


if [ $# -gt 0 ]; then
    if [ $1 == "clean" ];then
        clean        
    else 
        mensaje bienvenida
    fi
else
    # Chequeando si existe el directorio con el repositorio.
    mensaje verificando_repositorio_local
    if [ -d "${repositorio_local}${nombre_repositorio}" ]; then
        # El repositorio existe y tiene los archivos para ser copiados en el directorio.
        mensaje ok
        crear_estructura_de_directorios
        copiar_archivos
    else
        mensaje fail
        echo -e "${message_title}Mensaje:${NOC}${message_body}\n\tEl repositorio no se encuentra en la ruta: ${repositorio_local}${NOC}"
        echo 
        read -p "¿Desea clonar el repositorio en la ruta por defecto? [Si/no]:" answer
        case $answer in
            "")
                clone_repo
                crear_estructura_de_directorios
                copiar_archivos
                ;;
             s | S)
                clone_repo
                crear_estructura_de_directorios
                copiar_archivos
                ;;
            n | N)
                echo -e "${message_body}\n\tcpp.template es necesario para crear las estructuras de directorio"
                echo -e "\tpara proeyctos en c++."
                echo -e "\tpuede clonarlo desde github y luego indicar su ruta en la variable del script"
                echo -e "\trepositorio_local="
                echo 
                echo -e "\tgit clone https://github.com/jaimefeldman/cpp.template.git"

                echo
                ;;
            *)
                echo "respuesta no valida..."
                echo -e "${message_body}script terminated...${NOC}"
                ;;
        esac
    fi
fi

