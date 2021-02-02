#!/bin/sh


#
# Set user password
#
SetStimioPass()
{
    echo "stimio:$STIMIO_PASSWORD" | chpasswd
    echo "=> Done!"

    echo "========================================================================"
    echo "You can now connect to this container via SSH using:"
    echo ""
    echo "    ssh -p <port> stimio@<host>"
    echo "and enter the stimio password '$STIMIO_PASSWORD' when prompted"
    echo "========================================================================"
}


#
# Script entry point
#
main() {
    # Check if stimio password is set
    if [ "${STIMIO_PASSWORD}" == "NONE" ]; then
        echo " /!\ ERROR /!\ Stimio password isn't set, please specify it with STIMIO_PASSWORD variable."
        exit 1
    else
        SetStimioPass
        #exec /usr/sbin/sshd -D -e -E /var/log/stimio_reverse_ssh.log
	exec /usr/sbin/sshd -D  
    fi
}


main $@

