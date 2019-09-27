class gb_backend::params (
    String $transmart_server_url = lookup('gb_backend::transmart_server_url', String, first, ''),

    String $keycloak_server_url = lookup('gb_backend::keycloak_server_url', String, first, ''),
    String $keycloak_realm = lookup('gb_backend::keycloak_realm', String, first, ''),
    String $keycloak_client_id = lookup('gb_backend::keycloak_client_id', String, first, ''),
    String $keycloak_offline_token = lookup('gb_backend::keycloak_offline_token', String, first, ''),

    String $db_user = lookup('gb_backend::db_user', String, first, 'gb'),
    String $db_password = lookup('gb_backend::db_password', String, first, 'gb'),
    String $db_host = lookup('gb_backend::db_host', String, first, 'localhost'),
    Integer $db_port = lookup('gb_backend::db_port', Integer, first, 5432),
    String $db_name = lookup('gb_backend::db_name', String, first, 'gb_backend'),

    String $nexus_url = lookup('gb_backend::nexus_url', String, first, 'https://repo.thehyve.nl'),
    Enum['releases', 'snapshots'] $repository = lookup('gb_backend::repository', Enum['releases', 'snapshots'], first, 'snapshots'),

    String $user = lookup('gb_backend::user', String, first, 'gb'),
    String $user_home = lookup('gb_backend::user_home', String, first, "/home/${user}"),

    String $version = lookup('gb_backend::version', String, first, '0.1-SNAPSHOT'),
    Integer[1, 65535] $app_port = lookup('gb_backend::app_port', Integer[1, 65535], first, 8083),

    Boolean $notifications_enabled       = lookup('gb_backend::notifications_enabled', Boolean, first, false),
    Integer $notifications_sets          = lookup('gb_backend::notifications_sets', Integer, first, 20),
    Integer[0,23] $notifications_trigger_hour = lookup('gb_backend::notifications_trigger_hour', Integer[0,23], first, 0),
    Integer[0,59] $notifications_trigger_minute = lookup('gb_backend::notifications_trigger_minute', Integer[0,59], first, 0),
    String $notifications_client_app_name = lookup('gb_backend::notifications_client_app_name', String, first, 'Glowing Bear'),
    Optional[String] $notifications_client_app_url = lookup('gb_backend::notifications_client_app_url', Optional[String], first, undef),
    Optional[String] $sender_email = lookup('gb_backend::sender_email', Optional[String], first, undef),
) {
    if $transmart_server_url == '' {
        fail('No transmart server URL specified. Please configure gb_backend::transmart_server_url')
    }

    if $keycloak_server_url == '' {
        fail('No keyckloak server URL specified. Please configure gb_backend::keycloak_server_url')
    }

    if $keycloak_realm == '' {
        fail('No keycloak realm specified. Please configure gb_backend::keycloak_realm')
    }

    if $keycloak_client_id == '' {
        fail('No keycloak client id specified. Please configure gb_backend::keycloak_client_id')
    }

    if $keycloak_offline_token == '' {
        fail('No keycloak offline token specified. Please configure gb_backend::keycloak_offline_token')
    }
}
