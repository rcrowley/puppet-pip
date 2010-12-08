Gem::Specification.new do |s|
  s.name = "puppet-pip"
  s.version = "0.0.2"
  s.date = "2010-12-08"
  s.authors = ["Richard Crowley"]
  s.email = "richard@devstructure.com"
  s.summary = "Puppet provider of Python packages via pip."
  s.homepage = "http://github.com/rcrowley/python-pip"
  s.description = "Puppet provider of Python packages via pip."
  s.files = ["lib/puppet/provider/package/pip.rb"]
  s.add_dependency "puppet"
end
