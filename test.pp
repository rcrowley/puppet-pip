stage { "pre": before => Stage["main"] }
class pre {
	package {
		"python": ensure => latest;
		"python-dev": ensure => latest;
		"python-setuptools": ensure => latest;
	}
	exec { "easy_install pip":
		path => "/usr/local/bin:/usr/bin:/bin",
		refreshonly => true,
		require => Package["python-setuptools"],
		subscribe => Package["python-setuptools"],
	}
}
class { "pre": stage => "pre" }

package { "httplib2":
	ensure => "0.6.0",
	provider => pip,
}
