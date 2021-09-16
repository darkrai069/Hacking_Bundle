# MAC CHANGER using arguements (type III )

# !/usr/bin/env python

print("")

def mac_changer(interface, new_mac):
    print("[+] Changing the MAC address for " + interface + " to " + new_mac)

    subprocess.call(["ifconfig", interface, "down"])
    subprocess.call(["ifconfig", interface, "hw", "ether", new_mac])
    subprocess.call(["ifconfig", interface, "up"])

def get_args():
    parser = optparse.OptionParser()

    parser.add_option("-i", "--int", dest="interface", help="Interface to change its MAC address")
    parser.add_option("-m", "--mac", dest="new_mac", help="New MAC address")

    (val, arguements) = parser.parse_args()

    if not val.interface:
        parser.error("[+] Please specify an Interface, use --help for more information")
    elif not val.new_mac:
        parser.error("[+] Please specify an new MAC, use --help for more information")

    return val  ##OR return parser.parse_args()

def current_mac(int):

    # inter_print = value.interface
    # subprocess.call("echo -n [+] New MAC address for the value.interface is :  > file.txt", shell=True)
    # subprocess.call("ifconfig " + inter_print + "| grep ether | awk '{print $2}' >> file.txt ", shell=True)
    # subprocess.call("cat file.txt ", shell=True)

    ## ***************** OR *******************
    new = subprocess.check_output(["ifconfig", int])
    # print(new)
    # mac_now = re.search(r"\d.+\w:+\S+", new)          ### For Python 2 compilation
    # mac_now = re.search(r"\d.+\w:+\S+", str(new))       ### For Python 3 compilation
    mac_now = re.search(r"\w\w:\w\w:\w\w:\w\w:\w\w:\w\w", str(new)) ### For Python 3 compilation
    # print(mac_now.group(0))

    if mac_now:
        return mac_now.group(0)# re.search() gives you an object so the print fn should be as follows and not like normal case.
    else:
        print("[-] Could not read MAC address please check the interface you have given")

import subprocess
import optparse
import re

value = get_args()  ##OR (val,arguements) = get_args()

current_mac_addr = current_mac(value.interface)
print("Current MAC is : " + str(current_mac_addr))
print('')

mac_changer(value.interface, value.new_mac)

current_mac_addr = current_mac(value.interface)

if value.new_mac == current_mac_addr:
    print('')
    print("[+] Successfully Changed MAC Address : " + current_mac_addr)
    print('')
else:
    print("[-] Could not change the MAC address. use --help for more support")

##i/p = python MACchanger.py -i eth0 -m 00:11:22:33:44:55



