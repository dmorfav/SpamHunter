#!/bin/bash
########################################
# Script para administrar bloqueo de direcciones o dominios en zimbra mail server
########################################

#Global variables
FILE="/home/dmorfav/postfix_reject_sender"

#This method list the file with all blocked domains and emails
function list() {
  if [ -f $FILE ]; then
      cat $FILE
  else
    echo "El fichero $FILE no existe"
  fi
}

#This function is used for add a new domain or email to blocked list
#If pass a parameter then execute the process automatic else ask to user
function add() {
  action=" REJECT"
  if [ -n "$1" ];then
    echo $1$action >> $FILE
  else
    echo "Introduce el dominio o la cuenta que desea bloquear"
    read blocked
    echo $blocked$action >> $FILE
  fi
  echo "Agregado correctamente"
}

function update() {
  echo "Listado de elementos"
  echo "####################"
  list
  echo ""
    # Text to search
  read -p "Introduce el elemento que desea remplazar: " search
    # Text to replace
  read -p "Introduce el nuevo valor: " replace

  if [[ $search != "" && $replace != "" ]]; then
    sed -i "s/$search/$replace/" $FILE
  fi
}

#This function is used for create the file if not exist
function init() {
  if [ ! -f $FILE ]; then
      touch $FILE
  fi
}

function execute() {
  #Check if the config file exist
  init
    case $1 in
      'd' )
        add $2
        ;;
      'l' )
        list
        ;;
      'a' )
        update
        ;;
    esac
}

case $1 in
  'a')
  echo "Actualizando un dominio o email bloqueado"
  echo "#######################################"
    execute $1 $2
  ;;
  'd')
    echo "Agregando dominio o email para bloquear"
    echo "#######################################"
    execute $1 $2
  ;;
  'e')
    echo "remove"
    execute e
  ;;
  'l')
    echo "Listado de los dominios bloqueados"
    echo "##################################"
    execute l
  ;;
  *)
    echo -e "(A)ctualizar la lista \n a(D)icionar elemento a la lista \n (E)liminar elemento de la lista \n (L)istar"
    read option
    execute $option
  ;;
esac
