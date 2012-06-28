# Allow plugins and DDLs to be shipped separately if desired
define mcollective::plugin::ddl($module = 'mcollective') {
  file { "${filebase}.ddl":
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/${module}/plugins/${name}.ddl",
    before => [Package['mcollective'], Service['mcollective']],
  }
}
