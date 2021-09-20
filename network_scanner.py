#!/use/bin/env python

import scapy.all as scapy
import optparse

def get_args():
    parser = optparse.OptionParser()

    parser.add_option("-i","--ip-address", dest="ip", help="Network IP address to scan ")
    parser.add_option("-s","--subnet", dest="net_mask", help="Network Subnet mask ")

    (val, arguement) = parser.parse_args()
    # print(val.ip)
    # print(val.net_mask)

    if not val.ip:
        parser.error("[+] Please specify the network ip address to scan or check your options; use --help for more information")
    elif not val.net_mask:
        parser.error("[+] Please specify the subnet mask, use --help for more information")

    return val

# SCANS THE IP AND RETURN THE IP AND CORRESPONDING MAC ADDRESS IN A LIST OF DICTIONARIES
def net_scan(ip):
#                   PART A1
    arp_req = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")

#                   PART A2
    arp_req_bc = broadcast/arp_req
    ans_list = scapy.srp(arp_req_bc, timeout=1, verbose=False)[0]

#                   PART B and PART C
    client_list = list()
    for element in ans_list:
        client_dict=dict()
        client_dict= {"ip":element[1].psrc, "mac":element[1].hwsrc}
        client_list.append(client_dict)
        # print(element[1].psrc + "\t\t" + element[1].hwsrc)

    return (client_list)

#PRINTS THE LIST FROM THE SCAN(FUNCTION) IN A NEAT MANNER
def print_results(results_list):
    print("IP\t\t\tMAC ADDRESS\n-----------------------------------------")
    for clients in results_list:
        print(clients['ip'] + "\t\t" + clients['mac'])
        # print(clients)


#**************************Getting the function executable********************************
value = get_args()
ip_scan = value.ip
mask_scan = value.net_mask
item = str(ip_scan + "/" + mask_scan)
# print(item)
#*****************************************************************************************


scan_result = net_scan(item)
print_results(scan_result)
print("")
