#!/bin/sh
# ---El archivo adjunto .servidores favor añadir en la /home/usuario/ si se va leer desde la misma carpeta borrar ~/ ---

# ---Para que no pida contraseña el ssh se usaron los siguientes comandos---
# 1. ssh-keygen -b 4096 -t rsa
# 2. ssh-copy-id informatica@192.168.0.111 --> UBUNTU
# 3. ssh-copy-id informatica@192.168.0.112 --> CENTOS

# --- /.servidores tener cuidado debe de estar hubicado en /home/usuario/ ---
direccion=~/.servidores
direccion_centos=/etc/redhat-release
direccion_ubuntu=/etc/lsb-release

tempfile1=/tmp/dialog_1_$$
tempfile2=/tmp/dialog_2_$$
tempfile3=/tmp/dialog_3_$$
tempfile4=/tmp/dialog_4_$$

trap "rm -f $tempfile1 $tempfile2 $tempfile3 $tempfile4" 0 1 2 5 15

_crear_usuario()
{
  titulo_o="CREAR USUARIO"

  dialog  --backtitle "$titulo_o" \
          --title "Agregar nuevo USUARIO" \
          --inputbox "Escriba nombre de usuario" 8 50 2> $tempfile2

  case $? in
        0)
            ;;
        1|255) _principal
            ;;
  esac

  dialog  --backtitle "$titulo_o" \
          --title "Confirme usuario" \
          --yesno "\n¿Desea crear el usuario $(cat $tempfile2)?" 7 50
   case $? in
        0)
            ssh_ip=""
            ssh_usuario=""
            ssh_contrasenia=""
            ssh_sw=0
            for i in $(cat $direccion)
            do
              case $ssh_sw in
                # ---Se extrae la IP del servidor de la lista .servidores---
                  0)
                    ssh_ip=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae el USUARIO del servidor de la lista .servidores---
                  1)
                    ssh_usuario=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae la CONTRASEÑA del usuario del servidor de la lista .servidores, además, se realiza operaciones de verificacion para la creación de un nuevo usuario---
                  2)
                    ssh_contrasenia=$i

                    sistema_operativo=0

                    # ---Se verifica que distribución linux es CentOS o Ubuntu---
                      sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_ubuntu ]; then echo 1; else echo 0; fi")

                      if [ $sistema_operativo -eq 0 ]
                      then
                        sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_centos ]; then echo 2; else echo 0; fi")
                      fi

                    # ---Se selecciona el tipo de destribución Linux CentOS o Ubuntu---
                      case $sistema_operativo in
                        # ---UBUNTU---
                          1)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                ssh $ssh_usuario@$ssh_ip "echo $ssh_contrasenia | sudo -S useradd -d /home/$(cat $tempfile2) -m -s /bin/bash $(cat $tempfile2)"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nEl USUARIO $(cat $tempfile2) fue creado exitosamente en el servidor $ssh_ip" 8 55
                                ;;
                              1)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO ya existe en el servidor $ssh_ip" 8 50
                                ;;
                            esac
                            ;;
                        # ---CENTOS---
                          2)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                ssh $ssh_usuario@$ssh_ip "useradd -d /home/$(cat $tempfile2) -m -s /bin/bash $(cat $tempfile2)"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nEl USUARIO $(cat $tempfile2) fue creado exitosamente en el servidor $ssh_ip" 8 55
                                ;;
                              1)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO ya existe en el servidor $ssh_ip" 8 50
                                ;;
                            esac
                            ;;
                        # ---NINGUNO---
                          0)
                            dialog  --backtitle "$titulo_o" \
                                    --title "ERROR" \
                                    --msgbox "\nEl servidor $ssh_ip no es CENTOS ni tampoco UBUNTU" 8 50
                            ;;
                      esac
                    ssh_sw=0
                    ;;
              esac
            done
            _principal
            ;;
        1|255) _principal
            ;;
   esac
}

_eliminar_usuario()
{
  titulo_o="ELIMINAR USUARIO"

  dialog  --backtitle "$titulo_o" \
          --title "Eliminar USUARIO" \
          --inputbox "Escriba usuario a eliminar" 8 50 2> $tempfile2

  case $? in
        0)
            ;;
        1|255) _principal
            ;;
  esac

  dialog  --backtitle "$titulo_o" \
          --title "Confirme usuario" \
          --yesno "\n¿Desea eliminar el usuario $(cat $tempfile2)?" 7 50
   case $? in
        0)
            ssh_ip=""
            ssh_usuario=""
            ssh_contrasenia=""
            ssh_sw=0
            for i in $(cat $direccion)
            do
              case $ssh_sw in
                # ---Se extrae la IP del servidor de la lista .servidores---
                  0)
                    ssh_ip=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae el USUARIO del servidor de la lista .servidores---
                  1)
                    ssh_usuario=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae la CONTRASEÑA del usuario del servidor de la lista .servidores, además, se realiza operaciones de verificacion para la eliminacion de un usuario---
                  2)
                    ssh_contrasenia=$i

                    sistema_operativo=0

                    # ---Se verifica que distribución linux es CentOS o Ubuntu---
                      sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_ubuntu ]; then echo 1; else echo 0; fi")

                      if [ $sistema_operativo -eq 0 ]
                      then
                        sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_centos ]; then echo 2; else echo 0; fi")
                      fi

                    # ---Se selecciona el tipo de destribución Linux CentOS o Ubuntu---
                      case $sistema_operativo in
                        # ---UBUNTU---
                          1)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "echo $ssh_contrasenia | sudo -S userdel -r $(cat $tempfile2)"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nEl USUARIO $(cat $tempfile2) fue eliminado exitosamente del servidor $ssh_ip" 8 55
                                ;;
                            esac
                            ;;
                        # ---CENTOS---
                          2)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "userdel -r $(cat $tempfile2)"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nEl USUARIO $(cat $tempfile2) fue eliminado exitosamente del servidor $ssh_ip" 8 55
                                ;;
                            esac
                            ;;
                        # ---NINGUNO---
                          0)
                            dialog  --backtitle "$titulo_o" \
                                    --title "ERROR" \
                                    --msgbox "\nEl servidor $ssh_ip no es CENTOS ni tampoco UBUNTU" 8 50
                            ;;
                      esac
                    ssh_sw=0
                    ;;
              esac
            done
            _principal
            ;;
        1|255) _principal
            ;;
   esac
}

_cambiar_contrasenia()
{
  titulo_o="CAMBIAR CONTRASEÑA"

  dialog  --backtitle "$titulo_o" \
          --title "Cambiar contraseña del USUARIO" \
          --inputbox "Escriba usuario" 8 50 2> $tempfile2

  case $? in
        0)
            dialog  --backtitle "$titulo_o" \
                    --title "Escriba nueva CONTRASEÑA" \
                    --passwordbox "Nueva CONTRASEÑA" 8 50 2> $tempfile1

            case $? in
                  0)
                    dialog  --backtitle "$titulo_o" \
                            --title "Vuelva a escribir nuevamente la CONTRASEÑA" \
                            --passwordbox "Escriba nuevamente la CONTRASEÑA" 8 50 2> $tempfile4
                    case $? in
                          0)
                              if [ "$(cat $tempfile1)" = "$(cat $tempfile4)" ]
                              then
                                contrasenia="$(cat $tempfile1)"
                              else
                                dialog  --backtitle "$titulo_o" \
                                    --title "ERROR" \
                                    --msgbox "\nLas CONTRASEÑAS no coinciden." 8 50

                                _principal
                              fi
                              ;;
                          1|255) _principal
                              ;;
                    esac
                    ;;
                  1|255)
                    _principal
                    ;;
            esac
            ;;
        1|255) _principal
            ;;
  esac

  dialog  --backtitle "$titulo_o" \
          --title "Confirme el cambio de CONTRASEÑA" \
          --yesno "\n¿Esta seguro de CAMBIAR LA CONTRASEÑA del usuario $(cat $tempfile2)?" 7 50
   case $? in
        0)
            ssh_ip=""
            ssh_usuario=""
            ssh_contrasenia=""
            ssh_sw=0
            for i in $(cat $direccion)
            do
              case $ssh_sw in
                # ---Se extrae la IP del servidor de la lista .servidores---
                  0)
                    ssh_ip=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae el USUARIO del servidor de la lista .servidores---
                  1)
                    ssh_usuario=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae la CONTRASEÑA del usuario del servidor de la lista .servidores, además, se realiza operaciones de verificacion---
                  2)
                    ssh_contrasenia=$i

                    sistema_operativo=0

                    # ---Se verifica que distribución linux es CentOS o Ubuntu---
                      sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_ubuntu ]; then echo 1; else echo 0; fi")

                      if [ $sistema_operativo -eq 0 ]
                      then
                        sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_centos ]; then echo 2; else echo 0; fi")
                      fi

                    # ---Se selecciona el tipo de destribución Linux CentOS o Ubuntu---
                      case $sistema_operativo in
                        # ---UBUNTU---
                          1)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "echo $ssh_contrasenia | sudo -S su; echo \"$(cat $tempfile2):$contrasenia\" | sudo chpasswd"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nLa CONTRASEÑA del USUARIO $(cat $tempfile2) fue cambiado en el servidor $ssh_ip" 8 55

                                ;;
                            esac
                            ;;
                        # ---CENTOS---
                          2)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "echo \"$(cat $tempfile2):$contrasenia\" | chpasswd"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nLa CONTRASEÑA del USUARIO $(cat $tempfile2) fue cambiado en el servidor $ssh_ip" 8 55
                                ;;
                            esac
                            ;;
                        # ---NINGUNO---
                          0)
                            dialog  --backtitle "$titulo_o" \
                                    --title "ERROR" \
                                    --msgbox "\nEl servidor $ssh_ip no es CENTOS ni tampoco UBUNTU" 8 50
                            ;;
                      esac
                    ssh_sw=0
                    ;;
              esac
            done
            _principal
            ;;
        1|255) _principal
            ;;
   esac
}

_expirar_contrasenia()
{
  titulo_o="EXPIRAR CONTRASEÑA"

  dialog  --backtitle "$titulo_o" \
          --title "Se precisa USUARIO para expirar contraseña" \
          --inputbox "Escriba usuario" 8 50 2> $tempfile2

  case $? in
        0)
            ;;
        1|255) _principal
            ;;
  esac

  dialog  --backtitle "$titulo_o" \
          --title "Confirme usuario" \
          --yesno "\n¿Desea expirar la contraseña del usuario $(cat $tempfile2)?" 7 50
   case $? in
        0)
            ssh_ip=""
            ssh_usuario=""
            ssh_contrasenia=""
            ssh_sw=0
            for i in $(cat $direccion)
            do
              case $ssh_sw in
                # ---Se extrae la IP del servidor de la lista .servidores---
                  0)
                    ssh_ip=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae el USUARIO del servidor de la lista .servidores---
                  1)
                    ssh_usuario=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae la CONTRASEÑA del usuario del servidor de la lista .servidores, además, se realiza operaciones de verificacion ---
                  2)
                    ssh_contrasenia=$i

                    sistema_operativo=0

                    # ---Se verifica que distribución linux es CentOS o Ubuntu---
                      sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_ubuntu ]; then echo 1; else echo 0; fi")

                      if [ $sistema_operativo -eq 0 ]
                      then
                        sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_centos ]; then echo 2; else echo 0; fi")
                      fi

                    # ---Se selecciona el tipo de destribución Linux CentOS o Ubuntu---
                      case $sistema_operativo in
                        # ---UBUNTU---
                          1)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "echo $ssh_contrasenia | sudo -S chage -E $(date +'%Y-%m-%d' --date='-1 day') $(cat $tempfile2)"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nEl USUARIO $(cat $tempfile2) fue expirada exitosamente del servidor $ssh_ip" 8 55
                                ;;
                            esac
                            ;;
                        # ---CENTOS---
                          2)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "chage -E $(date +'%Y-%m-%d' --date='-1 day') $(cat $tempfile2)"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nEl USUARIO $(cat $tempfile2) fue expirada exitosamente del servidor $ssh_ip" 8 55
                                ;;
                            esac
                            ;;
                        # ---NINGUNO---
                          0)
                            dialog  --backtitle "$titulo_o" \
                                    --title "ERROR" \
                                    --msgbox "\nEl servidor $ssh_ip no es CENTOS ni tampoco UBUNTU" 8 50
                            ;;
                      esac
                    ssh_sw=0
                    ;;
              esac
            done
            _principal
            ;;
        1|255) _principal
            ;;
   esac
}

_contrasenia_aleatoria()
{
  titulo_o="CONTRASEÑA ALEATORIA"

  dialog  --backtitle "$titulo_o" \
          --title "Cambiar contraseña aleatoria del USUARIO" \
          --inputbox "Escriba usuario" 8 50 2> $tempfile2

  case $? in
        0)
          ;;
        1|255) _principal
          ;;
  esac

  dialog  --backtitle "$titulo_o" \
          --title "Confirme el cambio de CONTRASEÑA ALEATORIA" \
          --yesno "\n¿Esta seguro de CAMBIAR LA CONTRASEÑA de forma ALEATORIA del usuario $(cat $tempfile2)?" 7 50

  #Genera contraseña aleatoria
    contrasenia_aleatoria=$(openssl rand -base64 6)

   case $? in
        0)
            ssh_ip=""
            ssh_usuario=""
            ssh_contrasenia=""
            ssh_sw=0
            for i in $(cat $direccion)
            do
              case $ssh_sw in
                # ---Se extrae la IP del servidor de la lista .servidores---
                  0)
                    ssh_ip=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae el USUARIO del servidor de la lista .servidores---
                  1)
                    ssh_usuario=$i
                    ssh_sw=$(expr $ssh_sw + 1)
                    ;;
                # ---Se extrae la CONTRASEÑA del usuario del servidor de la lista .servidores, además, se realiza operaciones de verificacion---
                  2)
                    ssh_contrasenia=$i

                    sistema_operativo=0

                    # ---Se verifica que distribución linux es CentOS o Ubuntu---
                      sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_ubuntu ]; then echo 1; else echo 0; fi")

                      if [ $sistema_operativo -eq 0 ]
                      then
                        sistema_operativo=$(ssh $ssh_usuario@$ssh_ip "if [ -f $direccion_centos ]; then echo 2; else echo 0; fi")
                      fi

                    # ---Se selecciona el tipo de destribución Linux CentOS o Ubuntu---
                      case $sistema_operativo in
                        # ---UBUNTU---
                          1)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "echo $ssh_contrasenia | sudo -S su; echo \"$(cat $tempfile2):$contrasenia_aleatoria\" | sudo chpasswd"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nLa CONTRASEÑA del USUARIO $(cat $tempfile2) es \"$contrasenia_aleatoria\" del servidor $ssh_ip" 8 55

                                ;;
                            esac
                            ;;
                        # ---CENTOS---
                          2)
                            existe_usuario=$(ssh $ssh_usuario@$ssh_ip "if grep -qi \"^$(cat $tempfile2):\" /etc/passwd; then echo 1; else echo 0; fi")

                            case $existe_usuario in
                              0)
                                dialog  --backtitle "$titulo_o" \
                                        --title "ERROR" \
                                        --msgbox "\nEl USUARIO no existe en el servidor $ssh_ip" 8 50
                                ;;
                              1)
                                ssh $ssh_usuario@$ssh_ip "echo \"$(cat $tempfile2):$contrasenia_aleatoria\" | chpasswd"

                                dialog  --backtitle "$titulo_o" \
                                        --title "EXITO" \
                                        --msgbox "\nLa CONTRASEÑA del USUARIO $(cat $tempfile2) es \"$contrasenia_aleatoria\" del servidor $ssh_ip" 8 55
                                ;;
                            esac
                            ;;
                        # ---NINGUNO---
                          0)
                            dialog  --backtitle "$titulo_o" \
                                    --title "ERROR" \
                                    --msgbox "\nEl servidor $ssh_ip no es CENTOS ni tampoco UBUNTU" 8 50
                            ;;
                      esac
                    ssh_sw=0
                    ;;
              esac
            done
            _principal
            ;;
        1|255) _principal
            ;;
   esac
}

_principal()
{
  dialog 	--title "ADMINISTRACIÓN DE CUENTAS DE USUARIO" \
         	--menu 	"Favor seleccione operación" 12 55 5 \
                 	1 "Crear usuario" \
                 	2 "Eliminar usuario" \
                 	3 "Cambiar contraseña" \
                  4 "Expirar contraseña" \
                  5 "Contraseña aleatoria" 2> $tempfile3

   retv=$?
   choice=$(cat $tempfile3)
   [ $retv -eq 1 -o $retv -eq 255 ] && exit

   case $choice in
        1)  _crear_usuario
            ;;
        2)  _eliminar_usuario
            ;;
        3)  _cambiar_contrasenia
            ;;
        4)  _expirar_contrasenia
            ;;
        5)  _contrasenia_aleatoria
            ;;
   esac
}

_principal
