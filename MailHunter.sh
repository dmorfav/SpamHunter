#!/bin/bash
########################################
# Script para administrar bloqueo de direcciones o dominios en zimbra mail server
########################################

#Global variables
FILE="/home/dmorfav/postfix_reject_sender"

#This function is used for add a new domain or email to blocked list
#If pass a parameter then execute the process automatic else ask to user
function add() {
  if [ -n "$1" ];then
    echo $1 >> $FILE
  else
    echo "Introduce el dominio o la cuenta que desea bloquear"
    read blocked
    echo $blocked >> $FILE
  fi
}


#This function is used for create the file if not exist
function init() {
  if [ ! -f $FILE ]; then
      touch $FILE
  fi
}

#This method list the file with all blocked domains and emails
function list() {
  if [ ! -f $FILE ]; then
      cat $FILE
  else
    echo "El fichero $FILE no existe"
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
    esac
}

case $1 in
  'a')
    echo "update"
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
