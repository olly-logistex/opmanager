#!/bin/bash

### 
#TODO
# verification for $1 > into site var
#from list? 
#update list when run on certain server/ when keygen is run for site?


## check for existence of dir with function 

#date for backups
now=$(date +"%Y%m%d")
site=$1

get_permissions() {
    #check if run as root
if (( $EUID == 0 )); then
    echo "Please run as root..."
    return 1
fi
return 0
}

if_empty() {
    local files
    files=$(ls -qAH -- /home/chair/.ssh)
    if [ -z "$files" ]; then 
        return 0
    fi
    return 1
}

Help() {
    echo "SNMP config for OpManager"
    echo ""
    echo "Syntax: $ snmp  [-d|h|k|s]"
    echo "d         Do it"
    echo "h         Print this help page"
    echo "k         Generate new keys for site"    
    echo "s         Run setup of chair user"
}

gen_keys() {
    
    if [ -d /home/chair/.ssh ]; then
    # the directory exists
        if [ if_empty = 0 ]; then
        #check for presence of private key to prevent overwriting
            if [[ -f "$site"_"$now" ]]; then
                echo "Key-Pair already generated"        
                else
                #RSA 4096 no passphrase
                ssh-keygen -t rsa -b 4096 -f /home/chair/.ssh/"$site"_"$now" -P
                #copy backups to support
                cp -pv "$site"_"$now" /support/OpManager
                cp -pv "$site"_"$now".pub /support/OpManager
            fi
        fi  
    fi
    
    
    #check for presence of private key to prevent overwriting
    if [[ -f "$site"_"$now" ]]; then
        echo "Key-Pair already generated"        
        else
        #RSA 4096 no passphrase
        ssh-keygen -t rsa -b 4096 -f /home/chair/.ssh/"$site"_"$now" -P
        #copy backups to support
        cp -pv "$site"_"$now" /support/OpManager
        cp -pv "$site"_"$now".pub /support/OpManager
    fi
}

make_chair_user() {
    #create user + pass + perms
    useradd chair
    chpasswd chair:OpManager2022
    usermod -aG wheel chair
    #cd to user dir
    cd /home/chair || echo "directory not found" && return 1
    #make .ssh with perms
    mkdir -pv .ssh
    chmod 700 .ssh
    #make authkeys + perms
    touch authorized_keys
    chmod 600 authorized_keys
    #create backup with date 
    cp authorized_keys authorized_keys"$now" 
    #check if

    #scp public key from 

    public_key=/support/OpManager/"$site"_"$now".pub
    if [[ -f "$public_key" ]]; then
        # append to authkeys
        cat public_key >> authorized_keys
    else
        echo "public key not found"
        return 1
    fi
    return 0
}

install_snmp() {
    yum install net-snmp net-snmp-utils net-snmp-develyum install 
    return 0 
}

snmpv3_setup() {
    systemctl stop snmpd
    net-snmp-create-v3-user -ro -x AES -a SHA -A COCONUTS2022 -X COCONUTS2022 ChairHotline
    #look how to escape quotes
    echo 'createUser ChairHotline SHA "COCONUTS2022" AES COCONUTS2022' >> /var/lib/net-snmp/snmpd.conf
    ## may need to be inserted into specific section
    echo 'rouser ChairHotline' >> /etc/snmp/snmpd.conf
    echo 'AuthPriv' >> /etc/snmp/snmpd.conf
}

sysd_conf() {
    ## direct output to /dev/null to cleanup 
    systemctl enable snmpd
    systemctl start snmpd
    systemctl status snmpd
}

firewall_config() {
    firewall-cmd --zone=public --add-port=161/udp --permanent
    firewall-cmd --zone=public --add-port=161/tcp --permanent
    firewall-cmd --zone=public --add-port=162/udp --permanent
    firewall-cmd --zone=public --add-port=162/tcp --permanent
    firewall-cmd --reload
}

# Get the options
while getopts ":h:d:k:s" option; do
   case $option in
        h | *) # display Help
            Help
            exit;;
        k)
        ;;
        d)
        ;;
        s)
        ;;
   esac
done
