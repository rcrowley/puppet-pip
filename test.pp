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

package {
	"httplib2":
		ensure => latest,
		provider => pip;
	"socialregistration":
		ensure => "317a0dbed71b660c8ec7f7994f3ae42dadf2e992",
		provider => pip,
		source => "git+https://github.com/itmustbejj/django-socialregistration.git";
}
