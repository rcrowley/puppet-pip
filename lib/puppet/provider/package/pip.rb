# Puppet package provider for Python's `pip` package management frontend.
# <http://pip.openplans.org/>

require 'puppet/provider/package'
require 'xmlrpc/client'

Puppet::Type.type(:package).provide :pip,
  :parent => ::Puppet::Provider::Package do

  desc "Python packages via `pip`."

  has_feature :installable, :uninstallable, :upgradeable, :versionable

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
  rescue Puppet::DevError
    []
  end

  def query
    execpipe "#{command :pip} freeze" do |process|
      process.each do |line|
        options = self.class.parse(line)
        return options if options[:name] == @resource[:name]
      end
    end
    nil
  rescue Puppet::DevError
    nil
  end

  def latest
    client = XMLRPC::Client.new2("http://pypi.python.org/pypi")
    client.http_header_extra = {"Content-Type" => "text/xml"}
    result = client.call("package_releases", @resource[:name])
    result.first
  end

  def install
    args = %w{install -q}
    if @resource[:source]
      args << "-e"
      if String === @resource[:ensure]
        args << "#{@resource[:source]}@#{@resource[:ensure]}#egg=#{
          @resource[:name]}"
      else
        args << "#{@resource[:source]}#egg=#{@resource[:name]}"
      end
    else
      case @resource[:ensure]
      when String
        args << "#{@resource[:name]}==#{@resource[:ensure]}"
      when :latest
        args << "--upgrade" << @resource[:name]
      else
        args << @resource[:name]
      end
    end
    lazy_pip *args
  end

  # Uninstall won't work unless this issue gets fixed.
  # <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=562544>
  def uninstall
    lazy_pip "uninstall", "-y", "-q", @resource[:name]
  end

  def update
    install
  end

  private
  def lazy_pip(*args)
    pip *args
  rescue NoMethodError
    if pathname = `which pip`.chomp
      self.class.commands :pip => pathname
      retry
    else
      raise e
    end
  end

end
