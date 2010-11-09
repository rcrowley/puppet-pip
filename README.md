puppet-pip
==========

Puppet provider of Python packages via `pip`.  Alliteration FTW.

* Puppet: <https://github.com/puppetlabs/puppet>
* Puppet `apt` package provider: <https://github.com/puppetlabs/puppet/blob/master/lib/puppet/provider/package/apt.rb>
* `pip`: <http://pip.openplans.org/>
* PyPI: <http://pypi.python.org/pypi>

Installation
------------

	gem install puppet-pip

Example
-------

	package { "httplib2":
		ensure => "0.6.0",
		provider => pip,
	}
