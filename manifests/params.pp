class mcollective::params {

  $topicprefix = '/topic/'
  $sharedir    = '/usr/share/mcollective'
  $libdir      = "${sharedir}/plugins"
  $logfile     = '/var/log/mcollective.log'

  $loglevel = hiera('mcollective_loglevel', 'warn')

  $host = hiera('mcollective_host')
  # port 61613 is more standard for the stomp protocol
  $port = hiera('mcollective_port', '61614')

  $user     = hiera('mcollective_user')
  $password = hiera('mcollective_password')

  $psk = hiera('mcollective_psk')

  $connector_host     = hiera(mcollective::server::connector_host)
  $connector_port     = hiera(mcollective::server::connector_port)
  $connector_user     = hiera(mcollective::server::connector_user)
  $connector_password = hiera(mcollective::server::connector_password)
  $connector_ssl      = hiera(mcollective::server::connector_ssl)
}
