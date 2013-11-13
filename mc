#!/bin/bash

#Minecraft-Server [Start|Stop|Restart|Reload|Backup|Status] Script

#Variablen

server_id=$2
screen_session_running=$(screen -ls | grep "$server_id")
game_dir=./mc_$server_id
backup_dir=/home/nigol-resu_nur/mc_backup/mc_$server_id
backup_file=/home/nigol-resu_nur/$server_id.tar
server_home_dir=/home/nigol-resu_nur


case "$1" in

#Start-----------------------------------------------------------------------------------------------------------------------------------------------------
    start)
        if [ "$screen_session_running" != "" ]
            then
                clear
                echo        "***Hinweis**"*
                echo
                echo -e     "\033[31mDer Server lÃ¤uft bereits!\033[0m"
                echo
                echo        "***Hinweis***"
                else
                cd "$server_home_dir"
                cd "$game_dir"
                ./start.sh
                sleep 25
        if [ "$screen_session_running" == "" ]
            then
                echo        "***Hinweis***"
                echo
                echo -e     "\033[31mDer Server konnte nicht gestartet werden bitte wenden Sie sich an den Systemadministrator!\033[0m"
                echo
                echo        "***Hinweis***"
            else
                clear
                echo        "***Hinweis***"
                echo
                echo -e     "\033[32mDer Server wurde erfolgreich gestartet. Mit \033[0m\033[4mscreen -r $server_id\033[0m\033[32m kÃ¶nnen Sie in die Serverkonsole wechseln!\033[0m"
                echo
                echo        "***Hinweis***"
            fi
            fi
        ;;
#Stop------------------------------------------------------------------------------------------------------------------------------------------------------
    stop)
        if [ "$screen_session_running" == "" ]
            then
                clear
                echo 	    "***Hinweis***"
                echo
                echo -e     "\033[31mDer Server konnte nicht gestoppt werden. Bitte stellen sie mit \033[0m\033[4m$server_id status\033[0m\033[31m sicher ob der Server lÃ¤uft.\033[0m"
                echo
                echo 	    "***Hinweis***"
            else
                clear
                echo 	    "***Hinweis***"
                echo
                echo -e		"\033[32mDer Server wird in 30 Sekunden heruntergefahren!"
                echo
                screen -r "$server_id" -X stuff $'say Der Server wird in 30 Sekunden heruntergefahren.\n'
                sleep 25
                screen -r "$server_id" -X stuff $'save-all\n'
                sleep 5
                screen -r "$server_id" -X stuff $'stop\n'
                echo -e		"\033[32mDer Server wurde erfolgreich gestoppt!\033[0m"
                echo
                echo 	    "***Hinweis***"
            fi
        ;;
#Restart---------------------------------------------------------------------------------------------------------------------------------------------------
    restart)
		if [ "$screen_session_running" == "" ]
            then
                clear
                echo        "***Hinweis***"
                echo
                echo -e     "\033[31mDer Server konnte nicht neugestartet werden. Bitte stellen Sie mit \033[0m\033[4m$server_id status\033[0m\033[31m sicher ob der Server lÃ¤uft.\033[0m"
                echo
                echo        "***Hinweis***"
            else
                clear
                echo        "***Hinweis***"
                echo
                echo -e     "\033[32mDer Server wird in 30 Sekunden neugestartet!"
                echo
                screen -r "$server_id" -X stuff $'say Der Server wird in 30 Sekunden neugestartet.\n'
                sleep 25
                screen -r "$server_id" -X stuff $'save-all\n'
                sleep 5
                screen -r "$server_id" -X stuff $'stop\n'
                echo -e		"\033[32mDer Server wurde erfolgreich gestoppt!\033[0m"
                sleep 1
                echo -e		"\033[32mDer Server wird gestartet!\033[0m"
                sleep 5
                $0 start
            fi
        ;;
#Backup----------------------------------------------------------------------------------------------------------------------------------------------------
   	backup)
        if [ "$screen_session_running" != "" ]
            then
                clear
                echo        "***Hinweis***"
                echo -e     "\033[32mStarte Backup fÃ¼r $server_id""!\033[0m"
                screen -r "$server_id" -X stuff $'say Es wird ein Backup erstellt dabei kÃ¶nnen Laggs auftreten!\n'
                screen -r "$server_id" -X stuff $'save-all\n'
                screen -r "$server_id" -X stuff $'save-off\n'
                screen -r "$server_id" -X stuff $'say Backup gestartet!\n'
                rm -R "$backup_dir"
                mkdir "$backup_dir"
                cd  "$server_home_dir"
                tar -vcf "$server_id".tar "$game_dir"
                cp "$backup_file" "$backup_dir"
                rm "$backup_file"
                screen -r "$server_id" -X stuff $'save-on\n'
                screen -r "$server_id" -X stuff $'save-all\n'
                screen -r "$server_id" -X stuff $'say Backup wurde erfolgreich erstellt!\n'
                echo -e     "\033[32mBackup wurde erfolgreich erstellt!\033[0m" 
                echo        "***Hinweis***"
            else
                clear
                echo        "***Hinweis***"
                echo -e     "\033[32mStarte Backup fÃ¼r $server_id""!\033[0m"
                rm -R "$backup_dir"
                mkdir "$backup_dir"
                cd  "$server_home_dir"
                tar -cf "$server_id".tar "$game_dir"
                cp "$backup_file" "$backup_dir"
                rm "$backup_file"
                echo -e     "\033[32mBackup wurde erfolgreich erstellt!\033[0m"
                echo        "***Hinweis***"
            fi
        ;;
#Reload----------------------------------------------------------------------------------------------------------------------------------------------------
	reload)	
		if [ "$screen_session_running" == "" ]
            then
                clear
                echo        "***Hinweis***"
                echo
                echo -e     "\033[31mDer Server lÃ¤uft nicht!\033[0m"
                echo
                echo        "***Hinweis***"
            else
                clear
                echo        "***Hinweis***"
                echo
                echo -e     "\033[32mDer Server wird neugeladen!\033[0m"
                echo
                echo        "***Hinweis***"
            fi
		;;
#Status----------------------------------------------------------------------------------------------------------------------------------------------------
    status)
        if [ "$screen_session_running" == "" ]
            then
                clear
                echo        "***Hinweis***"
                echo
                echo -e     "\033[31mDer Server lÃ¤uft nicht!\033[0m"
                echo
                echo        "***Hinweis***"
            else
                clear
                echo        "***Hinweis***"
                echo
                echo -e     "\033[32mDer Server lÃ¤uft!\033[0m"
                echo
                echo        "***Hinweis***"
            fi
        ;;
#Ausgabe bei falscher Eingabe------------------------------------------------------------------------------------------------------------------------------
    *)
                echo "Usage: $0 {start|stop|restart|backup|reload|status}{all|ftb|hbf|hardcore|survival}"
		;;
esac

case "$2" in
	all)
                mc "$1" ftb
                mc "$1" hbf
                mc "$1" hardcore
                mc "$1" survival
		;;
	ftb)
		;;
	hbf)
		;;
	hardcore)
		;;
	survival)
		;;
esac
