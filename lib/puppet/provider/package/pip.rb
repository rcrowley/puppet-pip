# Puppet package provider for Python's `pip` package management
# frontend.
# <http://pip.openplans.org/>

require 'puppet/provider/package'

Puppet::Type.type(:package).provide :pip,
  :parent => ::Puppet::Provider::Package do

  desc "Python packages via `pip`."

  has_feature :installable, :uninstallable, :versionable

  # Enabling :upgradable and thus the ability to `ensure => latest`
  # will require talking to the PyPI XMLRPC interface because the
  # only way to figure out what the latest version number is from
  # the CLI is to download and unpack it.
  # <http://wiki.python.org/moin/PyPiXmlRpc>
  #has_feature :upgradeable

  if pathname = `which pip`.chomp
    commands :pip => pathname
  else
    raise NotImplementedError
  end

  def self.parse(line)
    if line.chomp =~ /^([^=]+)==([^=]+)$/
      {:ensure => $2, :name => $1, :provider => name}
    else
      nil
    end
  end

  def self.instances
    packages = []
    execpipe "#{command :pip} freeze" do |process|
      process.collect do |line|
        next unless options = parse(line)
        packages << new(options)
      end
    end
    packages
  end

  def query
    execpipe "#{command :pip} freeze" do |process|
      process.each do |line|
        options = self.class.parse(line)
        return options if options[:name] == @resource[:name]
      end
    end
    nil
  end

  def install
    arg = @resource[:name]
    if String === @resource[:ensure]
      arg = "#{arg}==#{@resource[:ensure]}"
    end
    pip "install", "-q", arg
  end

  # Uninstall won't work unless this issue gets fixed.
  # <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=562544>
  def uninstall
    pip "uninstall", "-y", "-q", @resource[:name]
  end

end
