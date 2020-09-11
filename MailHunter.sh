#!/bin/bash
########################################
# Script para administrar bloqueo de direcciones o dominios en zimbra mail server
########################################

#This function is used for create the file if not exist
function init() {
  if [ ! -f /opt/zimbra/common/conf/postfix_reject_sender ]; then
      touch /opt/zimbra/common/conf/postfix_reject_sender
  fi
}

function execute() {
  init
}

case $1 in
  'a')
    echo "update"
    execute a
  ;;
  'd')
    echo "add"
    execute d
  ;;
  'e')
    echo "remove"
    execute e
  ;;
  'l')
    echo "list"
    execute l
  ;;
  *)
    echo -e "(A)ctualizar la lista \n a(D)icionar elemento a la lista \n (E)liminar elemento de la lista \n (L)istar"
    read option
    execute $option
  ;;
esac
