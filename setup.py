# This is the main setup script that reads the servers-config.json file
import json
import subprocess
import logging
from exports import read_server_config

logging.basicConfig(level=logging.INFO)

def read_responsibilities() -> dict:
    """
    lead in the responsibilities file
    """
    with open("responsibilities.json", "r") as file:
        data = json.load(file)
    return data

server_config = read_server_config()
responsibilities = read_responsibilities()

def setup_hadoop(ip_addr_list: list[str]) -> None:
    logging.info("running hadoop setup")
    command = ["bash","services/hadoop/install.sh", *ip_addr_list]
    process = subprocess.Popen(command, stdin=None, stdout=None, stderr=None)
    process.wait()

def setup_wireguard(ip_addr_list: list[str]) -> None:
    logging.info("running wireguard setup")
    command = ["bash","services/wireguard/vpn/install.sh", *ip_addr_list]
    process = subprocess.Popen(command, stdin=None, stdout=None, stderr=None)
    process.wait()

def install_on_machine(machine_ip_addr: str, service_name: str) -> None:
    logging.info(f"installing {service_name} on {machine_ip_addr}")
    command = ["bash","services/install_service.sh", machine_ip_addr, service_name]
    process = subprocess.Popen(command, stdin=None, stdout=None, stderr=None)
    process.wait()


def start_service_on_machine(machine_ip_addr: str, service_name: str) -> None:
    logging.info(f"starting {service_name} on {machine_ip_addr}")
    command = ["bash","services/start_service.sh", machine_ip_addr, service_name]
    process = subprocess.Popen(command, stdin=None, stdout=None, stderr=None)
    process.wait()

if __name__ == "__main__":
    # distributed systems stuff
    hadoop_machines = [machine for machine in server_config['machines'] if any('hadoop' in resp for resp in machine['responsibilities'])]
    hadoop_ip_list = [machine["ip-address"] for machine in hadoop_machines]
    master_node = [machine for machine in server_config['machines'] if 'hadoop-name-node' in machine['responsibilities']][0] # there is only 1 master node so it will be a list of length 1
    logging.info(f"hadoop machine list: {hadoop_ip_list}")
    logging.info(f"hadoop master node: {master_node['ip-address']}")

    vpn_machines = [machine for machine in server_config['machines'] if any('wg-' in resp for resp in machine['responsibilities'])]
    vpn_ip_list = [machine["ip-address"] for machine in vpn_machines]
    wg_monitor_machine = [machine for machine in server_config['machines'] if 'wg-monitor' in machine['responsibilities']][0]
    logging.info(f"wireguard ip list: {vpn_ip_list}")
    logging.info(f"wireguard monitor ip: {wg_monitor_machine['ip-address']}")

    # single machine responsibilities
    for machine in server_config["machines"]:
        for responsibility in machine["responsibilities"]:
            if not responsibilities[responsibility]["distributed"]:
                install_on_machine(machine["ip-address"], responsibility)
                start_service_on_machine(machine["ip-address"], responsibility)

    # install & setup hadoop
    setup_hadoop(hadoop_ip_list)
    start_service_on_machine(master_node["ip-address"], "hadoop")

    # install & setup wireguard
    setup_wireguard(vpn_ip_list)
    for wg_ip in vpn_ip_list:
        start_service_on_machine(wg_ip, "wireguard/vpn")

    install_on_machine(wg_monitor_machine["ip-address"], "wireguard/wg-monitor")
    start_service_on_machine(wg_monitor_machine["ip-address"], "wireguard/wg-monitor")
