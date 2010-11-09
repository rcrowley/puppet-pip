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

Resource:

	package { "httplib2":
		ensure => "0.6.0",
		provider => pip,
	}

Usage:

	RUBYLIB=/usr/lib/ruby/gems/1.8/gems/puppet-pip-0.0.1/lib puppet apply test.pp
