class mcollective::server(
  $collectives        = ['mcollective'],
  $connector_host     = 'localhost',
  $connector_password = 'mcollective',
  $connector_port     = '61614',
  $connector_ssl      = {},
  $connector_type     = 'activemq',
  $connector_user     = 'mcollective',
  $main_collective    = 'mcollective',
) {

  include mcollective::package::server

  # Mcollective will break itself by default, so we need to get there first
  file { '/etc/mcollective':
    ensure => directory,
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }

  concat { '/etc/mcollective/server.cfg':
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    before  => Package['mcollective'],
  }

  concat::fragment { 'mcollective base':
    order   => 0,
    content => template('mcollective/server.cfg.erb'),
    target  => '/etc/mcollective/server.cfg',
  }

  service { 'mcollective':
    ensure    => running,
    enable    => true,
    require   => Package['mcollective'],
    subscribe => File['/etc/mcollective/server.cfg'],
  }

  class { 'mcollective::connector':
    type => $connector_type,
    pool => [
      {
        host     => $connector_host,
        port     => $connector_port,
        user     => $connector_user,
        password => $connector_password,
        ssl      => $connector_ssl,
      }
    ],
  }

  include mcollective::server::defaultplugins
  include mcollective::server::plugindir

}
