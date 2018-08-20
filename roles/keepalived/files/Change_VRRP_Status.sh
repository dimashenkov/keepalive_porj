#!/bin/bash

#
# Super simple script to set a file containing the current VRRP status
#

vrrp_script_dir=/etc/vrrp.d/

if [ ! -d $vrrp_script_dir ]
then
	echo "Error: Script dir $vrrp_script_dir missing"
	exit
fi

status () {

        if [ -f /var/state/MASTER ]
        then
                echo "I am master"
        else
                echo "I am in a fault/backup state"
        fi
}

run_scripts () {
	state=$1

	# OK, we can't use run-parts because we have to pass
	# args adn the redhat run-parts doesn't support that
	for vrrp_script in `ls -1 ${vrrp_script_dir}*`
	do
		echo "Executing $vrrp_script"
		${vrrp_script} $state
	done
}

case "$1" in
        master)
		run_scripts master
                ;;

        backup)
		run_scripts backup
                ;;

        fault)
		run_scripts fault
                ;;

        status)
                status
                ;;
        *)
                echo $"Usage: $0 {master | backup | fault | status}"
                exit 1
esac

