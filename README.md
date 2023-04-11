# Ansible Role: pgAdmin on Docker <!-- omit in toc -->

[![github](https://github.com/organicveggie/ansible.pgadmin_docker/workflows/Molecule/badge.svg)](https://github.com/organicveggie/ansible.pgadmin_docker/actions)
[![github](https://github.com/organicveggie/ansible.pgadmin_docker/workflows/Lint/badge.svg)](https://github.com/organicveggie/ansible.pgadmin_docker/actions)
[![Issues](https://img.shields.io/github/issues/organicveggie/ansible.pgadmin_docker.svg)](https://github.com/organicveggie/ansible.pgadmin_docker/issues/)
[![PullRequests](https://img.shields.io/github/issues-pr-closed-raw/organicveggie/ansible.pgadmin_docker.svg)](https://github.com/organicveggie/ansible.pgadmin_docker/pulls/)
[![Last commit](https://img.shields.io/github/last-commit/organicveggie/ansible.pgadmin_docker?logo=github)](https://github.com/organicveggie/ansible.pgadmin_docker/commits/main)

An [Ansible](https://www.ansible.com/) role to setup and run the [pgAdmin](https://www.pgadmin.org/)
[Docker](http://www.docker.com) [container](https://hub.docker.com/r/dpage/pgadmin4).

## Contents <!-- omit in toc -->

- [Requirements](#requirements)
- [Role Variables](#role-variables)
  - [Container Settings](#container-settings)
  - [Login Settings](#login-settings)
  - [Docker Volumes](#docker-volumes)
  - [Docker Networks](#docker-networks)
  - [PostgreSQL Server Definitions](#postgresql-server-definitions)
  - [Traefik](#traefik)
  - [Mail Server Settings](#mail-server-settings)
- [Dependencies](#dependencies)
- [Example Playbooks](#example-playbooks)
  - [Common Settings](#common-settings)
  - [Extra networks](#extra-networks)
- [License](#license)
- [Author Information](#author-information)

## Requirements

Requires Docker. Reecommended role for Docker installation:
[geerlingguy.docker](https://galaxy.ansible.com/geerlingguy/docker).

## Role Variables

See [defaults/main.yml](defaults/main.yml) for a complete list.

### Container Settings

```yaml
# Name of the Docker container.
pgadmin_docker_name: "pgadmin"

# Base name of the Docker image to use for the container.
pgadmin_docker_image_name: "dpage/pgadmin4"

# Specific Docker image version to use for the container.
pgadmin_docker_image_version: "latest"

# TCP port number to expose to handle HTTP traffic.
pgadmin_docker_port: "5050"

# Number of vCPUs to allocate to the container.
pgadmin_docker_cpu: "1"

# Amount of memory to allocate to the container.
pgadmin_docker_memory: "1GB"
```

### Login Settings

```yaml
# Email address used as the initial administrator account.
pgadmin_default_email: "admin@example.com"

# Password for the initial administrator account.
pgadmin_default_password: "changeme"
```

### Docker Volumes

```yaml
# Create and use Docker volumes for storing data. True creates volumes and attaches them to the
# container. False creates folders and bind mounts them to the container.
pgadmin_docker_use_volumes: true
```

### Docker Networks

```yaml
# Name of the default Docker network for the container. The container will *always* attach to this
# network. If [pgadmin_docker_network_create] is true, this is also the name of the network which
# will be created.
pgadmin_docker_network_name: "pgadmin"

# List of additional networks the container should attach to. Elements should be dictionaries like
# https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html#parameter-networks.
pgadmin_docker_extra_networks: []

# List of aliases for this container in the default network. These names can be used in the default
# network to reach this container.
pgadmin_docker_network_aliases: []

# The container’s IPv4 address in the default network. Defaults to using DHCP.
pgadmin_docker_network_ipv4: null

# The container’s IPv6 address in the default network. Defaults to using DHCP. Only applies if
# IPv6 is enabled in the default network.
pgadmin_docker_network_ipv6: null

# Create the default Docker network. True creates network and attaches the container to it. False
# does not create the network.
pgadmin_docker_network_create: false
```

### PostgreSQL Server Definitions

```yaml
# Map of PostgreSQL server names to dictionaries of server details. Used to construct the
# `servers.json` config file. pgAdmin uses `servers.json` to perform an initial import of Postgres
# server definitions. Every server definition must include the following entries:
#   Name, Group, Port, Username, SSLMode, MaintenanceDB and one of Host, HostAddr or Service.
#
# See https://www.pgadmin.org/docs/pgadmin4/development/import_export_servers.html for more details.
pgadmin_docker_servers: {}
```

Example:

```yaml
pgadmin_docker_servers:
  postgres:
    name: "Postgres Example"
    group: "sample"
    port: "5432"
    username: "postgres"
    host: "db.example.com"
    ssl_mode: "prefer"
    maintenance_db: "postgres"
```

### Traefik

```yaml
# Enable use of Traefik as a proxy.
pgadmin_docker_available_externally: "true"

# Host name to use for the Traefik endpoint. Combined with [pgadmin_docker_host_domain] to form the
# FQDN for the endpoint.
pgadmin_docker_host_name: "pgadmin"

# Domain name to use for the Traefik endpoint. Combined with [pgadmin_docker_host_name] to form the
# FQDN for the endpoint. Also used by Traefik to create the necessary Let's Encrypt certificate.
pgadmin_docker_host_domain: "example.com"
```

### Mail Server Settings

These settings are used for confirming and resetting passwords etc. See:
[http://pythonhosted.org/Flask-Mail/](http://pythonhosted.org/Flask-Mail/) for more info

```yaml
pgadmin_docker_email_server: "example.com"
pgadmin_docker_email_port: "25"
pgadmin_docker_email_use_ssl: "False"
pgadmin_docker_email_user_tls: "False"
pgadmin_docker_email_username: null
pgadmin_docker_email_password: null
```

## Dependencies

None.

## Example Playbooks

### Common Settings

```yaml
- hosts: all
  vars:
    pgadmin_docker_network_name: "postgres"
    pgadmin_docker_servers:
        server1:
            name: "Server 1"
            group: "group1"
            port: "5432"
            username: "postgres"
            host: "server1.mydomain.example.com"
            ssl_mode: "prefer"
            maintenance_db: "postgres"
    pgadmin_docker_host_domain: "mydomain.example.com"
    pgadmin_default_email: "admin@mydomain.example.com"
    pgadmin_default_password: "{{ vault_pgadmin_admin_password }}"
  roles:
    - geerlingguy.docker
    - organicveggie.pgadmin_docker
```

### Extra networks

```yaml
- hosts: all
  vars:
    pgadmin_docker_network_name: "pgadmin"
    pgadmin_docker_network_create: "true"
    pgadmin_docker_network_driver: "bridge"
    pgadmin_docker_network_subnet: "172.10.1.0/24"
    pgadmin_docker_network_gateway: "172.10.1.1"
    pgadmin_docker_network_ipv4: "172.10.1.10"
    pgadmin_docker_extra_networks: ["network1", "network2"]
  roles:
    - geerlingguy.docker
    - organicveggie.pgadmin_docker
```

## License

[GNU AFFERO GPL](LICENSE)

## Author Information

[Sean Laurent](http://github/organicveggie)
