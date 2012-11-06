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

  include '::mcollective::package::server'
  include '::mcollective::params'

  file { '/etc/mcollective':
    ensure  => directory,
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    require => Class['mcollective::package::server'],
  }

  concat { '/etc/mcollective/server.cfg':
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
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

  mcollective::connector { 'base':
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
