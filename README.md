# check_nic_basic

A very simply Nagios/Icinga plugin for a basic check of a given NIC. Right now it includes: 

- is the NIC visible at all in the interface list
- is an IPv4 address assigned to the NIC

````
$ ./check_nic_basic.sh

 This plugin will perform 2 basic checks of a given NIC.


 Usage: check_nic_basic.sh -<h|n>

   -n: NIC
   -h: print this help

$
````
