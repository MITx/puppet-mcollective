class mcollective::package::server {

  # ---
  # package requirements

  case $::osfamily {
    Debian: {
      # Switch to a gem because of how outdated the stomp package is.
      package { 'stomp':
        ensure   => present,
        provider => gem,
        before   => Package['mcollective'],
      }
    }
  }

  package { 'mcollective':
    ensure  => present,
  }

  # Mcollective packages currently install into ruby/1.8 instead of vendor_ruby
  # for compatibility with hardy. If the current rubyversion is 1.9 then we
  # need symlinks so mcollective can find itself.
  if $::rubyversion =~ /^1\.9/ {
    file {
      '/usr/lib/ruby/vendor_ruby/mcollective.rb':
        ensure => link,
        target => '/usr/lib/ruby/1.8/mcollective.rb',
        before => Service['mcollective'];
      '/usr/lib/ruby/vendor_ruby/mcollective':
        ensure => link,
        target => '/usr/lib/ruby/1.8/mcollective',
        before => Service['mcollective'];
    }
  }
}
