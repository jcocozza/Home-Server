import sys
import json

def read_server_config() -> dict:
    """
    load in the server-config file
    """
    with open("servers-config.json", "r") as file:
        data = json.load(file)

    return data

if __name__ == "__main__":

    # this reads the config file and then returns the vpn-ip-address associated with a given machine ip-address
    ipaddr = sys.argv[1]
    data = read_server_config()
    vpn_ip_lst = [machine for machine in data['machines'] if ipaddr == machine['ip-address']]
    vpn_ip = vpn_ip_lst[0]["vpn-ip-address"]
    print(vpn_ip)