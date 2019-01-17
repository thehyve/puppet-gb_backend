Puppet module to deploy glowing bear backend.

# Prerequisites

    - java 8 or later
    - PostgreSQL

# Install Puppet

	# For Debian 9 and Ubuntu 18.04
	sudo apt install puppet

	# For Ubuntu 16.04
	wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
	sudo dpkg -i puppet5-release-xenial.deb
	sudo apt update
	sudo apt install puppet5-release

	# Install puppet modules
	puppet module install puppet-archive

	# Check Puppet version, Puppet 4.8 and Puppet 5 should be fine.
	puppet --version

# Install module

	git submodule add https://github.com/thehyve/puppet-gb_backend.git gb_backend

# Parameters

## Keycloak parameters

Keycloak parameters. They should match with that ones that frontend glowing bear application uses.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::keycloak_server_url` || keycloak url that used. e.g. `https://keycloak.example.com/auth` |
| `gb_backend::keycload_realm` || keycloak realm. |
| `gb_backend::keycload_client_id` || keycloak client id. |

## Application db connection parameters

Database parameters used by the application to establish connnection.
*PostgeSQL* is used by default at the moment.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::db_user` | `gb` | Database user that used by the application to connect to the database. |
| `gb_backend::db_password` | `gb` | The user password to the database. |
| `gb_backend::db_host` | `localhost` | The database server host name. |
| `gb_backend::db_port` | `5432` | The database server port. |
| `gb_backend::db_name` | `gb_backend` | The database name. |

## Resource where to get the application

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::nexus_url` | `https://repo.thehyve.nl` | The Nexus/Maven repository server. |
| `gb_backend::reporsitory` | `snapshots` | The repository to use. `releases` or `snapshots` are only valid options. |


## OS parameters

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::user` | `transmart` | System user that runs the application. |
| `gb_backend::user_home` | `/home/${user}` | The user home directory. |

## Misc. application parameters

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::vesion` | `0.1-SNAPSHOT` | The version of application to install. |
| `gb_backend::app_port` | `8083` | The port the application runs on. |

# License

Copyright © 2019   The Hyve.

The puppet module for TranSMART is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
