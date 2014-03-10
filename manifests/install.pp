class megaraid::install {

  file { '/etc/apt/sources.list.d/hwraid.list':
    ensure  => present,
    content => 'deb http://hwraid.le-vert.net/debian wheezy main
',
    notify  => Exec['apt-key-add'],
  }

  exec { 'apt-key-add':
    command     => '/usr/bin/wget -O - http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | /usr/bin/sudo apt-key add -',
    refreshonly => true,
    notify      => Exec['apt-update'],
  }

  exec { 'apt-update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }

  package { 'megacli':
    ensure  => present,
    require => Exec['apt-update'],
  }

  file { '/usr/lib/nagios/plugins/check_megaraid_sas':
    ensure  => present,
    mode    => '0755',
    source  => 'puppet:///modules/megaraid/check_megaraid_sas',
    require => Package['megacli'],
  }

}

