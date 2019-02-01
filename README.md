# Puppet module to deploy glowing bear backend

[![Build Status](https://travis-ci.org/thehyve/puppet-gb_backend.svg?branch=master)](https://travis-ci.org/thehyve/puppet-gb_backend)

## How to install

    sudo apt-get update --fix-missing

    # For Debian 9 and Ubuntu 18.04
    sudo apt install puppet

    # For Ubuntu 16.04
    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    sudo dpkg -i puppet5-release-xenial.deb
    sudo apt update
    sudo apt install puppet5-release

    # Install puppet modules
    sudo puppet module install puppet-archive -v 3.2.1
    sudo puppet module install puppetlabs-java -v 3.3.0
    sudo puppet module install puppetlabs-postgresql -v 5.11.0

    # Check Puppet version, Puppet 4.8 and Puppet 5 should be fine.
    puppet --version

*Note:* module manages postgres database. It will create a database and user with password (see parameters [here](#application-db-parameters)) if it does note exist.

### Install module

    git submodule add https://github.com/thehyve/puppet-gb_backend.git gb_backend


### Dependencies

The instructions are for installing 
- the [Keycloak] identity provider,
- the [TranSMART API server](https://github.com/thehyve/transmart-core/tree/dev/transmart-api-server), and
- the [Glowing Bear] user interface for the backend.

#### Install the `transmart_core` and `glowing_bear` modules

Copy the `transmart_core` and `glowing_bear` module repositories to the `/etc/puppetlabs/code/modules` directory:
```bash
cd /etc/puppetlabs/code/modules
git clone https://github.com/thehyve/puppet-transmart_core.git transmart_core
git clone https://github.com/thehyve/puppet-glowing_bear.git glowing_bear
```

## Parameters

### Keycloak parameters

Keycloak parameters. They should match with that ones that frontend glowing bear application uses.

| hiera key | default value | description |
|-----------|---------------|-------------|
| `gb_backend::keycloak_server_url` || keycloak url that used. e.g. `https://keycloak.example.com/auth` |
| `gb_backend::keycloak_realm` || keycloak realm. |
| `gb_backend::keycloak_client_id` || keycloak client id. |

### Application parameters

| hiera key | default value | description |
|-----------|---------------|-------------|
| `gb_backend::transmart_server_url` || transmart url that used. e.g. `https://transmart.example.com` |

### Application db parameters

Database parameters used to create database if it does not exist and used by the application to establish connnection.
*Note:* Creationg of the databse supported only for `localhost` db host.
*PostgeSQL* is used by default at the moment.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::db_user` | `gb` | Database user that used by the application to connect to the database. |
| `gb_backend::db_password` | `gb` | The user password to the database. |
| `gb_backend::db_host` | `localhost` | The database server host name. |
| `gb_backend::db_port` | `5432` | The database server port. |
| `gb_backend::db_name` | `gb_backend` | The database name. |

### Resource where to get the application

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::nexus_url` | `https://repo.thehyve.nl` | The Nexus/Maven repository server. |
| `gb_backend::reporsitory` | `snapshots` | The repository to use. `releases` or `snapshots` are only valid options. |


### OS parameters

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::user` | `gb` | System user that runs the application. |
| `gb_backend::user_home` | `/home/${user}` | The user home directory. |

### Misc. application parameters

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::vesion` | `0.1-SNAPSHOT` | The version of application to install. |
| `gb_backend::app_port` | `8083` | The port the application runs on. |

### Query subscription notification parameters

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `gb_backend::notifications_enabled` | `false` | Enable notification for query subscriptions. |
| `gb_backend::notifications_sets` | `20` | Number of sets. |
| `gb_backend::notifications_trigger_hour` | `0` | Hour for daily notification trigger. |
| `gb_backend::notifications_trigger_minute` | `0` | Minute for daily notification trigger. |
| `gb_backend::sender_email` || Email address used in "from" field in the emails sent by the glowing bear. |

## Manage `systemd` services 

Start the `gb-backend` service:
```bash
sudo systemctl start gb-backend
```
Check the status of the service:
```bash
sudo systemctl status gb-backend
```
Stop the service:
```bash
sudo systemctl stop gb-backend
```
Check log of the service
```bash
sudo journalctl -u gb-backend.service
```

## Development

### Test

The module has been tested on Ubuntu 16.04 with Puppet version 5.5.0.
There are some automated tests, run using [rake](https://github.com/ruby/rake).

A version of `ruby` before `2.3` is required. [rvm](https://rvm.io/) can be used to install a specific version of `ruby`.
Use `rvm install 2.1` to use `ruby` version `2.1`.

The tests are automatically run on our Bamboo server: [PUPPET-PUPPETTS](https://ci.ctmmtrait.nl/browse/PUPPET-PUPPETTS).

#### Rake tests

Install rake using the system-wide `ruby`:
```bash
yum install ruby-devel
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
or using `rvm`:
```bash
rvm install 2.3
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
Run the test suite:
```bash
rake test
```

## License

Copyright © 2019   The Hyve.

The puppet module for gb-backend is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.


[Keycloak]: https://www.keycloak.org/
[Glowing Bear]: https://glowingbear.app/
