class gb_backend(
    String $keycloak_server_url = $::gb_backend::params::keycloak_server_url,
    String $keycloak_realm = $::gb_backend::params::keycloak_realm,
    String $keycloak_client_id = $::gb_backend::params::keycloak_client_id,

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
) inherits gb_backend::params {

    user { $user:
        ensure     =>  present,
        home       =>  $user_home,
        managehome =>  true,
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
    $start_script = "${user_home}/start.sh"

    file { $app_conf:
        ensure  =>  file,
        owner   =>  $user,
        content =>  template('gb_backend/application.yml.erb'),
        notify  =>  Service['gb-backend'],
    }
    -> file { $start_script:
        ensure  =>  file,
        owner   =>  $user,
        mode    =>  '0744',
        content =>  template('gb_backend/start.sh.erb'),
        notify  =>  Service['gb-backend'],
    }
    -> file { '/etc/systemd/system/gb-backend.service':
        ensure  =>  file,
        mode    =>  '0644',
        content =>  template('gb_backend/gb-backend.service.erb'),
        notify  =>  Service['gb-backend'],
    }
    -> service { 'gb-backend':
        ensure   =>  running,
        provider =>  'systemd',
        require  =>  [ Archive::Nexus[$application_war_file] ],
    }

}
