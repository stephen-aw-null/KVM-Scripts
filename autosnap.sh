#!/bin/bash
# vm-auto-snap.sh - Script to automatically create snapshots of each VM on the system
# Parameter(s):
# $1 - Set the new snapshots to be current
# Error Code(s):
# 1 - Script could not determine if the snapshots should be made current

autosnap () {
        # If the user doesn't specify whether the new snapshots should be made current, exit.
        [ -z $1 ] && echo "$0: Specify whether the new snapshots will be made current with (true,false). Exiting..." && exit 1
        make_current=$1

        # If it doesn't exist, create a new directory in /var/log for snapshot dumps.
        [ ! -d /var/log/snapdump ] && mkdir -p /var/log/snapdump

        # Capture a list of the VMs on the system.
        vm_list=$(virsh list --all --name)

        # Create the snapshots.
        for instance in $vm_list
        do
                # Make the new snapshots and append their names with the current month, day, hour, and minute.
                virsh snapshot-create-as $instance "$instance-snap-$(date +%m%e%H%M)" --atomic > /dev/null
                # If specified, make the new snapshot current.
                [ $make_current ] && virsh snapshot-current $instance "$instance-snap-$(date +%m%e%H%M)" > /dev/null || echo "Snapshot fo
r $instance not made current."
                # Send the snapshot info to a file.
                virsh snapshot-list $instance --tree --current >> /var/log/snapdump/snapdump-$(date +%m%e%H%M)
        done
}

autosnap $1
