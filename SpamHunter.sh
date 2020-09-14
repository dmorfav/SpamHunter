#!/bin/bash
########################################
# Script para administrar bloqueo de direcciones o dominios en zimbra mail server
########################################

#Global variables
FILE="/opt/zimbra/conf/postfix_reject_sender"

#Check if the user is root
  function checkAccess() {
    if [ "$EUID" -ne 0 ]
      then echo "Ejecutar como root"
      exit
    fi
  }

#This method update the config of zimbra server
function updateServer() {
  su zimbra -c 'zmprov ms $(zmhostname) zimbraMtaSmtpdSenderRestrictions "actual_value, check_sender_access lmdb:$FILE"'
  su zimbra -c "/opt/zimbra/common/sbin/postmap $FILE"
  su zimbra -c "zmmtactl restart"
  exit
}

#This method list the file with all blocked domains and emails
function list() {
  if [ -f $FILE ]; then
      cat $FILE
  else
    echo "El fichero $FILE no existe"
  fi
}

#Function for count how much find a word in the file
function checkExist() {
  if grep -q "^$1:" $FILE
  then
    echo la entrada $1 ya existe en el sistema.
    exit
  fi
}

#This function is used for add a new domain or email to blocked list
#If pass a parameter then execute the process automatic else ask to user
function add() {
  action=" REJECT"
  checkExist $1
    if [ -n "$1" ];then
      echo $1$action >> $FILE
    else
      echo "Introduce el dominio o la cuenta que desea bloquear"
      read blocked
      checkExist $blocked
      echo $blocked$action >> $FILE
    fi
      echo "Agregado correctamente"
  updateServer
}

#This function is used for update a element of blocked list
#If pass a parameter then execute the process automatic else ask to user
function update() {
  checkExist $2
    if [[ -n "$1" && -n "$2" ]];then
      if [[ $1 != "" && $2 != "" ]]; then
        sed -i "s/$1/$2/" $FILE
      fi
    else
      echo "Listado de elementos"
      echo "####################"
      list
      echo ""
        # Text to search
      read -p "Introduce el elemento que desea remplazar: " search
        # Text to replace
      read -p "Introduce el nuevo valor: " replace
      checkExist $replace
      if [[ $search != "" && $replace != "" ]]; then
        sed -i "s/$search/$replace/" $FILE
      fi
    fi
  updateServer
}

#This function is used for delete a element of blocked list
#If pass a parameter then execute the process automatic else ask to user
function delete() {
  if [ -n "$1" ];then
    sed -i "/$1/d" $FILE
  else
    echo "Listado de los dominios bloqueados"
    echo "##################################"
    list
    echo "Introduce el dominio o la cuenta que desea eliminar del listado"
    read remove
    sed -i "/$remove/d" $FILE
 fi
 updateServer
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
        update $2 $3
        ;;
      'e' )
        delete $2
      ;;
    esac
}

checkAccess
case $1 in
  'a')
  echo "Actualizando un dominio o email bloqueado"
  echo "#######################################"
    execute $1 $2 $3
  ;;
  'd')
    echo "Agregando dominio o email para bloquear"
    echo "#######################################"
    execute $1 $2
  ;;
  'e')
  echo "Eliminando un dominio o email bloqueado"
  echo "#######################################"
    execute $1 $2
  ;;
  'l')
    echo "Listado de los dominios bloqueados"
    echo "##################################"
    execute $1 $2
  ;;
  'u' )
    updateServer
  ;;
  *)
    echo -e "\n (A) Actualizar la lista \n (D) adicionar elemento a la lista \n (E) Eliminar elemento de la lista \n (L) Listar"
    read option
    execute $option
  ;;
esac
