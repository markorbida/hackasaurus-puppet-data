class hackasaurus {
  $site = 'hackasaurus.org'
  $rootDir = '/var/hackasaurus.org'
  $wsgiDir = "$rootDir/wsgi-scripts"
  $staticFilesDir = "$rootDir/build"

  apache2::vhost { "$site":
    content => template("hackasaurus/apache-site.conf.erb"),
    require => Exec["update-$site"]
  }

  vcsrepo { "$rootDir":
    ensure => present,
    source => "git://github.com/hackasaurus/hackasaurus.org.git"
  }

  file { "$rootDir":
    require => Vcsrepo["$rootDir"],
    recurse => true,
    owner => 'www-data',
    group => 'www-data'
  }
  
  exec { "update-$site":
    command => "/usr/bin/curl --header \"Host: $site\" http://127.0.0.1/wsgi/update-site",
    require => [File["$rootDir"], Vcsrepo["$rootDir"]]
  }
}
