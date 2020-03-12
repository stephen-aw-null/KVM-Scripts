#!/bin/bash
# vm-provision.sh - Script to quickly stand up KVM VMs
# Parameter(s):
# $1 - Image file to use 
# $2 - Name of the VM
# $3 - Size of the VM's initial virtual hard drive; specified in gigabytes (e.g. 40 for 40GB of storage)
# $4 - Size of the VM's RAM; specified in megabytes (e.g. 4096 for 4GB)
# Exit Code(s):
# 0 - Parameter was missing
# 1 - Image file could not be found

vm-provision () {
        # Verify that every parameter was specified
        if [ -z $1 ] && [ -z $2 ] && [ -z $3 ] && [ -z $4 ]; then
                echo "You must supply every parameter for this script to function. Please rerun the script with every parameter supplied."
                exit 0
        fi

        # Verify that the image file is valid
        if ! [ -f $1 ]; then
                echo "The specified image file could not be found or was not valid. Exiting..."
                exit 1
        fi

        virt-install \
        -c $1 \
        -n "$2_$LOGNAME" \
        --disk size=$3 \
        --memory $4
}

vm-provision $1 $2 $3 $4
