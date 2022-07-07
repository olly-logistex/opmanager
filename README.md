# OpManager Config

## Usage
1. Create a folder called "OpManager" in the support direcrory of the project account 
    - `$ mkdir -pv /home/projectacc/support/OpManager`
    - take care as this is case sensistive 
    - this location is where backups will get stored 
2. Navigate to this directory ~/support/OpManager/ and upload opmanager.zip 
    - `$ cd ~/support/OpManager`
3. Unzip it using your favourite archive util
    - e.g `$ tar -xf opmanager.tar.gz`
4. Edit and complete the "opmanager.conf" file
    - All fields need to be changed from the default
5. The script needs to be run as root
    - `$ sudo su` or `$ su -`
    - prompt should now show `#` not `$`
6. Invoke the script with an option as below
    - `# ./opmanager -X` where `-X` is and option from the table below

### Here are the available options, dispalyed in cli with the -h option

      -d         Do it - will run these funcitons 
                    get_permissions - checks to see if the user is root
                    install_snmp - uses yum to install snmp and its required packages
                    make_chair_user - creates the relevant directories and sets permissions
                    snmpv3_setup - creates an snmpv3 user with the given credentials
                    sysd_conf - enables the snmpd service using sysd 
                    firewall_config - allows the relevant ports throught the firewall (161,162)
                    test_walk - performs a basic snmp-walk command to verify setup

      -h         Print this help page

      -k         Generate new keys for site - !take care with this option!
                    the keys are generated in the format nameofsite and nameofsite.pub
                    where $nameofsite is defined in opmanager.conf

      -r         Resets the installation
                    remove_snmp - uses yum to uninstall snmp and its packages 
                    del_chair_user - deletes the chair user and its directories
                    
    