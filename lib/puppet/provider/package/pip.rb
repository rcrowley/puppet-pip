# Puppet package provider for Python's `pip` package management frontend.
# <http://pip.openplans.org/>

require 'puppet/provider/package'
require 'xmlrpc/client'

Puppet::Type.type(:package).provide :pip,
  :parent => ::Puppet::Provider::Package do

  desc "Python packages via `pip`."

  has_feature :installable, :uninstallable, :upgradeable, :versionable

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

  def latest
    client = XMLRPC::Client.new2("http://pypi.python.org/pypi")
    client.http_header_extra = {"Content-Type" => "text/xml"}
    result = client.call("package_releases", @resource[:name])
    result.first
  end

  def install
    case @resource[:ensure]
    when String
      pip "install", "-q", "#{@resource[:name]}==#{@resource[:ensure]}"
    when :latest
      pip "install", "-q", "--upgrade", @resource[:name]
    else
      pip "install", "-q", @resource[:name]
    end
  end

  # Uninstall won't work unless this issue gets fixed.
  # <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=562544>
  def uninstall
    pip "uninstall", "-y", "-q", @resource[:name]
  end

  def update
    install
  end

end
