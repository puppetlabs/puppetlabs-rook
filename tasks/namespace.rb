#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def create(namespace,kubeconfig)
  cmd = ['kubectl', 'create', 'namespace', "#{namespace}"]
  stdout, stderr, status = Open3.capture3({"KUBECONFIG" => "#{kubeconfig}"},*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, stderr if status != 0
  { status: stdout.strip }
end

params = JSON.parse(STDIN.read)
namespace = params['namespace']
kubeconfig = params['kubeconfig']

begin
  result = create(namespace,kubeconfig)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end