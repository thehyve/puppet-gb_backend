class gb_backend(
    String $transmart_server_url = $::gb_backend::params::transmart_server_url,

    String $keycloak_server_url = $::gb_backend::params::keycloak_server_url,
    String $keycloak_realm = $::gb_backend::params::keycloak_realm,
    String $keycloak_client_id = $::gb_backend::params::keycloak_client_id,
    String $keycloak_offline_token = $::gb_backend::params::keycloak_offline_token,

    String $db_user = $::gb_backend::params::db_user,
    String $db_password = $::gb_backend::params::db_password,
    String $db_host = $::gb_backend::params::db_host,
    String $db_port = $::gb_backend::params::db_port,
    String $db_name = $::gb_backend::params::db_name,

    String $nexus_url = $::gb_backend::params::nexus_url,
    Enum['releases', 'snapshots'] $repository = $::gb_backend::params::repository,

    String $user = $::gb_backend::params::user,
    String $user_home = $::gb_backend::params::user_home,

    String $version = $::gb_backend::params::version,
    Integer[1, 65535] $app_port = $::gb_backend::params::app_port,

    Boolean $notifications_enabled = $::gb_backend::params::notifications_enabled,
    Integer $notifications_sets = $::gb_backend::params::notifications_sets,
    Integer[0,23] $notifications_trigger_hour = $::gb_backend::params::notifications_trigger_hour,
    Integer[0,59] $notifications_trigger_minute = $::gb_backend::params::notifications_trigger_minute,
    Optional[String] $sender_email = $::gb_backend::params::sender_email,
) inherits gb_backend::params {

    user { $user:
        ensure     =>  present,
        home       =>  $user_home,
        managehome =>  true,
    }

    case $::osfamily {
        'redhat': {
            class { '::java':
                package => 'java-1.8.0-openjdk'
            }
        }
        default: {
            class { '::java':
                package => 'openjdk-8-jdk' # Debian based distros
            }
        }
    }

    if $db_host == 'localhost' {
        postgresql::server::role { $db_user:
            password_hash => $db_password,
            superuser     => true,
        }
        -> postgresql::server::database { $db_name:
            notify =>  Service['gb-backend'],
            owner  => $db_user,
        }
    } else {
        warning('Skipping db management step. It exists for localhost only.')
    }

    $application_war_file = "${user_home}/gb-backend-${version}.war"
    archive::nexus { $application_war_file:
        user       =>  $user,
        url        =>  $nexus_url,
        gav        =>  "nl.thehyve.gb.backend:gb-backend:${version}",
        repository =>  $repository,
        packaging  =>  'war',
        mode       =>  '0444',
        creates    =>  $application_war_file,
        require    =>  User[$user],
        notify     =>  Service['gb-backend'],
        cleanup    =>  false,
    }

    $app_conf = "${user_home}/application.yml"
    file { $app_conf:
        ensure  =>  file,
        owner   =>  $user,
        content =>  template('gb_backend/application.yml.erb'),
        require =>  User[$user],
        notify  =>  Service['gb-backend'],
    }

    $start_script = "${user_home}/start.sh"
    file { $start_script:
        ensure  =>  file,
        owner   =>  $user,
        mode    =>  '0744',
        content =>  template('gb_backend/start.sh.erb'),
        require =>  [ User[$user], Class['::java'], Archive::Nexus[$application_war_file], File[$app_conf] ],
        notify  =>  Service['gb-backend'],
    }

    $service_conf = '/etc/systemd/system/gb-backend.service'
    file { $service_conf:
        ensure  =>  file,
        mode    =>  '0644',
        content =>  template('gb_backend/gb-backend.service.erb'),
        require =>  File[$start_script],
        notify  =>  Service['gb-backend'],
    }

    service { 'gb-backend':
        ensure   =>  running,
        provider =>  'systemd',
        require  =>  File[$service_conf],
    }

}
