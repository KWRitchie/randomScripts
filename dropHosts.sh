#!/bin/bash

## script to drop all ssh connections except your own
## need to define yourIP var 
yourIP=

# determine if host is vers 6 or 7  
linuxVers=$(cat /etc/redhat-release | grep 7) 

# determine all ips currently connected and add drop rules to iptables (vers 6) or firewalld (vers 7)
if [[ ! -z $linuxVers ]]; then
  hosts=$(w -i | grep -vw $yourIP | awk '{print $3}' | sed 1,2d)
  for ips in $hosts; do firewall-cmd --permanent --add-rich-rule="rule family='ipv4' source address=$ips reject" > /dev/null 2>&1; done
  for ips in $hosts; do firewall-cmd --add-rich-rule="rule family='ipv4' source address=$ips reject" > /dev/null 2>&1; done
fi

# add $hosts to tcpwrappers hosts.deny to prevent them of reconnecting to any services
for hostIP in $hosts; do
  if [[ -z $(cat /etc/hosts.deny | grep $hostIP) ]]; 
    then echo "ALL: $hostIP" >> /etc/hosts.deny 
  fi 
done

# kill all pts connections except your own
for ip in $(w -i | grep -vw $yourIP | awk '{print $2}' | sed 1,2d); do kill -9 $(ps -ft $ip | sed 1d | awk '{print $2}'); done
