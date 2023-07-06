#!/bin/bash
# Copyright (C) 2013 - Remy van Elst

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#variables to edit
VAR_PROXMOXHOST="192.168.0.25"
VAR_PROXMOXSSH="22"
VAR_PROXMOXUSER="root"
VAR_PROXMOX_NODE="proxmox"

# Also edit the case below for the templates. And make sure you have those templates and they're spelled correctly.

VAR_NODE_NODEID=$[ ( $RANDOM % 900+100 ) + 100 ]

function createct() {

	echo $0 $1 $2 $3 $4 $5 $6 $7 $8

	VAR_NODE_HOSTNAME=$2
	VAR_NODE_PASSWORD=$3

	case $4 in
        ubuntu10)
            VAR_NODE_TEMPLATE="local:vztmpl/ubuntu-10.04-x86.tar.gz"
            ;;
         
        ubuntu12)
            VAR_NODE_TEMPLATE="local:vztmpl/ubuntu-12.04-x86.tar.gz"
            ;;
         
        centos5)
            VAR_NODE_TEMPLATE="local:vztmpl/centos-5-x86.tar.gz"
        	;;
       	centos6)
            VAR_NODE_TEMPLATE="local:vztmpl/centos-6-x86.tar.gz"
            ;;
    esac

    VAR_NODE_RAM=$5
    VAR_NODE_SWAP=512
    VAR_NODE_DISK=$6
	VAR_NODE_CPU=1
	VAR_NODE_IP=$7
	VAR_NODE_VMID=$((RANDOM%400+200))

if [ ! -z "${8}" ]; then 
		VAR_NODE_VMID=$8
			echo "Creating ovz CT #: $VAR_NODE_VMID $VAR_NODE_HOSTNAME on $VAR_PROXMOX_NODE with password $VAR_NODE_PASSWORD, template: $4, IP: $VAR_NODE_IP, HDD: $VAR_NODE_DISK GB, RAM: $VAR_NODE_RAM MB."	
	else 
		VAR_NODE_VMID=$((RANDOM%990+300))

		echo "Creating ovz CT #: $VAR_NODE_VMID $VAR_NODE_HOSTNAME on $VAR_PROXMOX_NODE with password $VAR_NODE_PASSWORD, template: $4, IP: $VAR_NODE_IP, HDD: $VAR_NODE_DISK GB, RAM: $VAR_NODE_RAM MB."	
		read -p "Are you sure? Please enter y(es) or n(o): " CONFIRM
		case $CONFIRM in
		y|Y|YES|yes|Yes|ja|j|Ja|JA|jA);;
		n|N|no|NO|No|Nee|NEE|nEE|NeE)
		echo "You said $CONFIRM so we stop"
		exit 1
		;;
		*) echo "Please enter yes or no"
		exit 1
		;;
		esac
	fi

	ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
	#!/bin/bash
	TERM=linux
	export TERM
	(
	echo \"Creating OpenVZ Container CT $VAR_NODE_VMID\"	
	pvesh create /nodes/$VAR_PROXMOX_NODE/openvz -vmid $VAR_NODE_VMID -hostname $VAR_NODE_HOSTNAME -storage local -password \"$VAR_NODE_PASSWORD\" -ostemplate $VAR_NODE_TEMPLATE -memory $VAR_NODE_RAM -swap $VAR_NODE_SWAP -disk $VAR_NODE_DISK -cpus $VAR_NODE_CPU -ip_address $VAR_NODE_IP
	echo \"Starting CT $VAR_NODE_VMID\"
	pvesh create /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/start	
	)
	exit
	"
	 echo "Command finished"
}

function list_localcreated_cts () {
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"OpenVZ Containers\"
		pvesh get /nodes/$VAR_PROXMOX_NODE/openvz/ | grep \"name\|vmid\"
		#echo; 
		#echo \"KVM Virtual Machines:\"	
		#pvesh get /nodes/$VAR_PROXMOX_NODE/qemu/ | grep \"name\|vmid\" 		
		)
		exit
		"

}

function list_localcreated_vms () {
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"KVM Virtual Machines:\"	
		pvesh get /nodes/$VAR_PROXMOX_NODE/qemu/ | grep \"name\|vmid\" 		
		)
		exit
		"

}

function startct() {

	
if [ ! -z "${2}" ]; then 
		VAR_NODE_VMID=$2
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"Starting CT $VAR_NODE_VMID\"
		pvesh create /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/start	
		)
		exit
		"			
		echo "Command finished"
	else 
		list_localcreated_cts
		read -p "Enter VM ID please: " VAR_NODE_VMID
		if [ -z "${VAR_NODE_VMID}" ]; then 
			echo "Need VM ID, will now exit."; exit 1; 
		else 
			ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
			#!/bin/bash
			TERM=linux
			export TERM
			(
			echo \"Starting CT $VAR_NODE_VMID\"
			pvesh create /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/start	
			)
			exit
			"
			echo "Command finished"
		fi
	fi 
}


function get_ct_info() {

	
if [ ! -z "${2}" ]; then 
		VAR_NODE_VMID=$2
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"CT $VAR_NODE_VMID info:\"
		pvesh get /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/current	
		pvesh get /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/config	
		)
		exit
		"			
		echo "Command finished"
	else 
		list_localcreated_cts
		read -p "Enter VM ID please: " VAR_NODE_VMID
		if [ -z "${VAR_NODE_VMID}" ]; then 
			echo "Need VM ID, will now exit."; exit 1; 
		else 
			ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
			#!/bin/bash
			TERM=linux
			export TERM
			(
			echo \"CT $VAR_NODE_VMID info:\"
			pvesh get /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/current	
			pvesh get /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/config	
			)
			exit
			"
			echo "Command finished"
		fi
	fi 
}


function stopct() {

if [ ! -z "${2}" ]; then 
		VAR_NODE_VMID=$2
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"Stopping CT $VAR_NODE_VMID\"
		pvesh create /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/stop	
		)
		exit
		"			
		echo "Command finished"
else 
		list_localcreated_cts
		read -p "Enter VM ID please: " VAR_NODE_VMID
		if [ -z "${VAR_NODE_VMID}" ]; then 
			echo "${VAR_NODE_VMID}"
			echo "Need VM ID, will now exit."; 
			exit 1;
		else
			echo "Are you sure you want to STOP VM $VAR_NODE_VMID"?
			read -p "Please enter y(es) or n(o): " CONFIRM
			case $CONFIRM in
			y|Y|YES|yes|Yes|ja|j|Ja|JA|jA) ;;
			n|N|no|NO|No|Nee|NEE|nEE|NeE)
			echo "You said $CONFIRM so we stop"
			exit 1
			;;
			*) echo "Please enter yes or no"
			exit 1
			;;
			esac

			ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
			#!/bin/bash
			TERM=linux
			export TERM
			(
			echo \"Stopping CT $VAR_NODE_VMID\"
			pvesh create /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/stop	
			)
			exit
			"
			echo "Command finished"
		fi
fi
}

function deletect() {



if [ ! -z "${2}" ]; then 
		VAR_NODE_VMID=$2
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"Stopping CT $VAR_NODE_VMID\"
		pvesh create /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/stop		
		echo \"Removing CT $VAR_NODE_VMID\"
		pvesh delete /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/
		)
		exit
		"
		echo "Command finished"
else 
	list_localcreated_cts
	read -p "Enter VM ID please: " VAR_NODE_VMID
	if [ -z "${VAR_NODE_VMID}" ]; then 
		echo "Need VM ID, will now exit."; exit 1; 
	else
		echo "Are you sure you want to REMOVE VM $VAR_NODE_VMID"?
		read -p "Please enter y(es) or n(o): " CONFIRM
		case $CONFIRM in
		y|Y|YES|yes|Yes|ja|j|Ja|JA|jA) ;;
		n|N|no|NO|No|Nee|NEE|nEE|NeE)
		echo "You said $CONFIRM so we stop"
		exit 1
		;;
		*) echo "Please enter yes or no"
		exit 1
		;;
		esac
		
		echo "Are you really sure you want to remove VM $VAR_NODE_VMID? it will be gone forever and forever is a long time... "
		read -p "Please enter y(es) or n(o): " CONFIRM
		case $CONFIRM in
		y|Y|YES|yes|Yes|ja|j|Ja|JA|jA) ;;
		n|N|no|NO|No|Nee|NEE|nEE|NeE)
		echo "You said $CONFIRM so we stop"
		exit 1
		;;
		*) echo "Please enter yes or no"
		exit 1
		;;
		esac
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"Stopping CT $VAR_NODE_VMID\"
		pvesh create /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/status/stop		
		echo \"Removing CT $VAR_NODE_VMID\"
		pvesh delete /nodes/$VAR_PROXMOX_NODE/openvz/$VAR_NODE_VMID/
		)
		exit
		"
		echo "Command finished"
	fi
fi
}


function shelldrop() {

#first check if vm id is given. If so drop in shell, if not ask.	
if [ ! -z "${2}" ]; then 
		VAR_NODE_VMID=$2
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"Entering CT $VAR_NODE_VMID\"
		vzctl enter $VAR_NODE_VMID 
		)
		exit
		"
			echo "Command finished"
	else 
		list_localcreated_cts
		read -p "Enter VM ID please: " VAR_NODE_VMID
		if [ -z "${VAR_NODE_VMID}" ]; then 
			echo "Need VM ID, will now exit."; exit 1; 
		else 
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"Entering CT $VAR_NODE_VMID\"
		vzctl enter $VAR_NODE_VMID 
		)
		exit
		"

			echo "Command finished"
		fi
	fi 
}

function execinct() {

#first check if vm id is given. If so execute, if not stop.	
if [ ! -z "${2}" ]; then 
	if [ ! -z "${3}" ]; then
		VAR_NODE_VMID=$2
		VAR_NODE_COMMAND=""
		while [ "${3+defined}" ]; do
			VAR_NODE_COMMAND="$VAR_NODE_COMMAND $3" 
  			shift
		done			
		ssh -t -t $VAR_PROXMOXUSER@$VAR_PROXMOXHOST -p $VAR_PROXMOXSSH  "
		#!/bin/bash
		TERM=linux
		export TERM
		(
		echo \"Executing on $VAR_NODE_VMID\"
		vzctl exec $VAR_NODE_VMID \"$VAR_NODE_COMMAND\"
		)
		exit
		"
		echo "Command finished"
	else
	echo "Need command, will now exit."; exit 1; 
		fi 
else 
	echo "Need VM ID, will now exit."; exit 1; 
fi
}

function usage() {

	echo "Create oVZ VM: "
	echo "$0 createct node-hostname node-password node-template node-ram node-disk node-ip"
	echo " "
	echo "Example: $0 createct prod001 supersecret1 ubuntu12 1024 15  172.20.5.48"
	echo " "
	echo "Start vm: "
	echo "$0 startct"
	echo " "
	echo "Stop vm: "
	echo "$0 stopct"
	echo " "
	echo "Remove vm: "
	echo "$0 deletect"
	echo " "
	echo "List all containers (OpenVZ):"
	echo "$0 listcts"
	echo " "
	echo "Get CT info: "
	echo "$0 ctinfo"
	echo ""
	echo "List all virtual machines (KVM)"
	echo  "$0 listvms"
	echo  " "
	echo "Execute command in ct:"
	echo "$0 execinct ID \"COMMAND\""
	echo "Example: $0 execinct 103 \"apt-get update; apt-get -y upgrade \""
	echo
	echo "Shell dropper"
	echo "$0 shelldrop CTID"
	echo "$0 shelldrop 101"

}

case $1 in 
		createct)
			createct $1 $2 $3 $4 $5 $6 $7 $8
			;;

		startct)
			startct $1 $2
			;;

		stopct)
			stopct $1 $2
			;;

		deletect)
			deletect $1 $2
			;;

		shelldrop)	
			shelldrop $1 $2
			;;

		listcts)
			list_localcreated_cts
			;;
	
		listvms)
			list_localcreated_vms
			;;

		ctinfo)
			get_ct_info $1 $2
			;;

		execinct)
			execinct "$@"
			;;	

		*)
			usage
			;;
esac

			
			
