#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def namespace(namespace)
  cmd = ['kubectl', 'create', 'namespace', "#{namespace}"]
  stdout, stderr, status = Open3.capture3(cmd)
  raise Puppet::Error, stderr if status != 0
  { status: stdout.strip }
end

params = JSON.parse(STDIN.read)
namespace = params['namespace']

begin
  result = namespace(namespace)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message })
  exit 1
end