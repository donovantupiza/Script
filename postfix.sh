#! /bin/bash
while true
do
echo -e  "\nMENU: \n 1. Instalar \n 2. Desinstalar \n 3. Ver Estado y cambiarlo \n 4. Bandeja de entrada \n 5. Docker \n 6. Salir \n"
	read -p "Elija una opcion: " orden
	case $orden in
		1)
			#COMPROBACION USUARIO SUDO
			usuario=`whoami`
			usuario_sudo=`id $usuario | grep sudo | wc -l`
			if [ $usuario_sudo -eq 0 ];
			then
				echo "\nNo tiene los permisos necesarios para instalar nada"
			else
				comprobacion=`service --status-all | grep postfix`
        	                comprobacion2=`whereis mailutils | wc -l`
                	        if [[ -z $comprobacion &&  $comprobacion2 -eq 0 ]];
	                        then
	                               #INSTALAR
	                                echo "---------------------------"
	                                sudo apt-get update
	                                echo "---------------------------"
	                                sudo apt-get upgrade
                                	echo "---------------------------"
                        	        sudo apt-get install postfix
                	                echo "---------------------------"
        	                        sudo apt-get install mailutils
	                                echo "---------------------------"
	                        elif [[ -z $comprobacion && $comprobacion2 -eq 1 ]];
	                        then
					#INSTALAR
       		                        echo "---------------------------"
        	                        sudo apt-get update
                        	        echo "---------------------------"
	                                sudo apt-get upgrade
					echo "---------------------------"
					sudo apt-get install postfix
					echo "---------------------------"
	                        elif [[ $comprobacion2 -eq 0 && -n $comprobacion ]];
	                        then
					#INSTALAR
	                                echo "---------------------------"
	                                sudo apt-get update
	                                echo "---------------------------"
                        	        sudo apt-get upgrade
                	                echo "---------------------------"
        	                        sudo apt-get install mailutils
	                                echo "---------------------------"

	                        else
	                                echo -e "El servicio esta instalado "
				fi
			fi
		;;
		2)
			#DESINSTALAR
			#COMPROBACION USUARIO SUDO
                        usuario=`whoami`
                        usuario_sudo=`id $usuario | grep sudo | wc -l`
                        if [ $usuario_sudo -eq 0 ];
                        then
                                echo "\nNo tiene los permisos necesarios para desinstalar nada"
                        else
				while true
				do
					read -p "¿Esta seguro que quiere desinstalar el servicio? (SI o NO)" respuesta1
					if [ -z $respuesta1 ];
	                                then
	   	                             echo "Responda SI o NO"
	                                elif [[ $respuesta1 != "SI" && $respuesta1 != "NO" ]];
	                                then
	        	                        echo "Responda SI o NO"
	                                elif [ $respuesta1 == "SI" ];
	                                then
	                	               sudo apt-get --purge remove postfix -y
		                                echo "\nServicio Desinstalado"
	                        	        break
	                                elif [ $respuesta1 == "NO" ];
	                                then
	        	                        break
	                                fi
				done
			fi
		;;
		3)

		#VER STATUS

			#COMPROBACION SI ESTA INSTALADO

			comprobacion=`service --status-all | grep postfix | wc -l`
			comprobacion2=`whereis mailutils | wc -l`
			if [[ $comprobacion -eq 0 &&  $comprobacion2 -eq 0 ]];
			then
				echo -e "\nEl servicio no esta instalado, ademas de no tener la herramienta mailutils \nELIJA LA OPCION 1 PARA INSTALARLOS"
			elif [  $comprobacion -eq 0 ];
			then
				echo -e "\nEl servicio no esta instalado \nELIJA LA OPCION 1 PARA INSTALARLO"
			elif [ $comprobacion2 -eq 0 ];
			then
				echo -e "\nLa herramienta mailutils no esta instalada \nELIJA LA OPCION 1 PARA INSTALARLA"
			else
				echo -e "\nEl servicio esta instalado "

				#COMPROBACION ESTADO SERVICIO

				activo=`systemctl is-active postfix`
				if [ $activo = "inactive" ];
				then
					echo -e "Ahora mismo se encuentra parado el servicio \n"
					while true
        	                        do
                	                        read -p "¿Quiere Activar el servicio? (SI o NO): " respuesta1
                        	                if [ -z $respuesta1 ];
                                	        then
                                        	        echo "Responda SI o NO"
	                                        elif [[ $respuesta1 != "SI" && $respuesta1 != "NO" ]];
        	                                then
	                                                echo "Responda SI o NO"
	                                        elif [ $respuesta1 == "SI" ];
	                                        then
		                                        `service postfix start`
							echo "\nServicio Activado"
							break
						elif [ $respuesta1 == "NO" ];
						then
							break
						fi
	                                done
				elif [ $activo = "active" ]; then
					echo -e "Ahora mismo el servicio esta activo  "
					while true
                    do
                        read -p "¿Quiere parar el servicio? (SI o NO): " respuesta2
                        if [ -z $respuesta2 ];
                        then
							echo "Responda SI o NO"
                            elif [[ $respuesta2 != "SI" && $respuesta2 != "NO" ]];
                            then
                            	echo "Responda SI o NO"
                            elif [ $respuesta2 == "SI" ];
                            then
                                `service postfix stop`
                                echo -e "\nServicio Parado"
								break
                            elif [ $respuesta2 == "NO" ];
                            then
                                break
                            fi
                    done
				fi
			fi
		;;
		4)
			#BANDEJA DE ENTRADA
			mail
		;;
		5)
			echo "---------------------------"
			docker search donovandockertupiza
			echo "---------------------------"
			while true
                        do
                        read -p "¿Quiere crear un contenedor con esa imagen? (SI o NO): " respuesta2
	                        if [ -z $respuesta2 ];
	                        then
	        	                echo "Responda SI o NO"
	                        elif [[ $respuesta2 != "SI" && $respuesta2 != "NO" ]];
	                        then
	                                echo "Responda SI o NO"
	                        elif [ $respuesta2 == "SI" ];
	                        then
	                                read -p "Escriba el nombre de la imagen: " imagen
					echo "-------------------------------"
					echo -e "Descargando la imagen"
					docker pull $imagen
					echo "-------------------------------"
					echo -e "Creando contenedor \n"
					docker run -it $imagen
					echo "-------------------------------"
					echo "Proceso Completado"
					break
	                        elif [ $respuesta2 == "NO" ];
	                        then
                        	         break
                		fi
                        done
		;;
		6)
			break
		;;
		*)
			echo "Elija la opcion correcta"
		;;
	esac
done
