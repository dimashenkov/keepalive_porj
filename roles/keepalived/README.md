ansible-keepalived: Ansible role for setting up keepalived
==========================================================

This role sets up keepalived for an standard setup of:
  - One virtual IP
  - Two hosts

You just need to provide an small amount of information to have it running
  - Add "keepalived" role to both hosts
  - Add variable keepalived_node_role: "master" | "slave" to the appropiate hosts
  - Add variable keepalived_virtual_ip: "virtual IP address" to both hosts

Other variables can be configured, overwriting defaults/main.yml

Keepalived can watch processes to influence on which node should be the master. Setting
variable "keepalived_script_check_process" to the name of the process will do. I use keepalived
to give high availability to haproxy, so I use.

keepalived_script_check_process: "haproxy"

Make sure that multicast traffic is allowed in your network.

You can check what node is serving data and is working as a MASTER
(have highest priority) with:
```bash
$ tcpdump -i <interface> vrrp -c 10 -v
```

You can check if virtual IP is connected to any interface on specific node with:
```bash
$ ip addr show
```

To get more logs from Keepalived you can start it with following command:
```bash
$ keepalived -d --log-detail --log-console --dont-fork
```

Dependencies
------------
Works with CentOS/RedHat.

Role Variables
--------------

### Mandatory variables

|              Name              |                         Description                          |
|--------------------------------|--------------------------------------------------------------|
| `keepalived_global_router_id`  | Global router id for node. Should be unique for each node.   |
| `keepalived_virtual_ip`        | Virtual IP address (e.g. "192.168.1.1").                     |
| `keepalived_binding_interface` | What interface should virtual IP be binded to (e.g. "eth0"). |

### Other variables

|                    Name                     |        Default Value        |                                                   Description                                                    |
|---------------------------------------------|-----------------------------|------------------------------------------------------------------------------------------------------------------|
| `keepalived_version`                        | 1.2.13                      | Version of Keepalived to install.                                                                                |
| `keepalived_iptables_network`               | `192.168.0.0/24`            | Limit network connections to vrrp and multicast ports to this address space.                                     |
| `keepalived_auth_pass`                      | "password"                  | Password used by Keepalived to authenticate connections.                                                         |
| `keepalived_node_role`                      | "BACKUP"                    | Role for Keepalived vrrp_instance (available roles: "MASTER", "BACKUP", "EQUAL").                                |
| `keepalived_node_priority`                  | 0                           | Priority of specific vrrp_instance.                                                                              |
| `keepalived_nopreempt`                      | false                       | Switch MASTER only when the current MASTER fails.                                                                |
| `keepalived_virtual_router_id`              | "60"                        | Router id for specific vrrp_instance. Should be same for all nodes in one Keepalived cluster.                    |
| `keepalived_script_check_process`           | "keepalived"                | What process Keepalived should monitor.                                                                          |
| `keepalived_script_interval`                | 2                           | How frequently Keepalived will check process status (in seconds).                                                |
| `keepalived_script_rise`                    | 5                           | How many times process should report being fine to be considered working.                                        |
| `keepalived_script_weight`                  | 2                           | How much node priority will change in case of process UP/DOWN status change.                                     |
| `keepalived_tracked_interfaces`             | Not set                     | List of interfaces that we monitor for state status. monitor                                                     |
| `keepalived_global_notification_email`      | "cluster-admin@example.org" | Who will get emails on alerts.                                                                                   |
| `keepalived_global_notification_email_from` | "noreply@example.org"       | From who emails will come.                                                                                       |
| `keepalived_global_smtp_server`             | "smtp.example.org"          | SMTP server address.                                                                                             |
| `keepalived_global_smtp_connect_timeout`    | 30                          | SMTP connection timeout.                                                                                         |
| `net_ipv4_conf_all_arp_ignore`              | 1                           | Set net.ipv4.conf.eth0.arp_ignore (to disable ARP for VIP).                                                      |
| `net_ipv4_conf_all_arp_announce`            | 2                           | Set net.ipv4.conf.eth0.arp_announce (to disable ARP for VIP).                                                    |
| `log_dir`                                   | "/var/log"                  | Log directory.                                                                                                   |
| `keepalived_log_file`                       | "/var/log/keepalived.log"   | File with all logs coming from Keepalived.                                                                       |
| `run_mode`                                  | "Deploy"                    | One of Deploy, Stop, Install, Start, or Use. The default is Deploy which will do Install, Configure, then Start. |


Example Playbook
-------------------------

    - hosts: s1
      roles:
         - { role: keepalived, keepalived_virtual_ip: "192.168.1.1", keepalived_node_role: "master" }

    - hosts: s2
      roles:
         - { role: keepalived, keepalived_virtual_ip: "192.168.1.1", keepalived_node_role: "backup" }





