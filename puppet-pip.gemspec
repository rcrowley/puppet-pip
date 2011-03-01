Gem::Specification.new do |s|
  s.name = "puppet-pip"
  s.version = "0.0.5"
  s.date = "2011-03-01"
  s.authors = ["Richard Crowley"]
  s.email = "r@rcrowley.org"
  s.summary = "Puppet provider of Python packages via pip."
  s.homepage = "http://github.com/rcrowley/puppet-pip"
  s.description = "Puppet provider of Python packages via pip."
  s.files = [
    "lib/puppet/provider/package/pip.rb",
    "spec/unit/provider/package/pip_spec.rb",
  ]
  s.add_dependency "puppet"
end
