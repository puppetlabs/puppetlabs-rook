#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def create(config_file,kubeconfig)
  cmd = ['kubectl', 'create', '-f', "#{config_file}"]
  stdout, stderr, status = Open3.capture3({"KUBECONFIG" => "#{kubeconfig}"},*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, stderr if status != 0
  { status: stdout.strip }
end

params = JSON.parse(STDIN.read)
kubeconfig = params['kubeconfig']
config_file = params['config_file']


begin
  result = create(config_file,kubeconfig)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message })
  exit 1
end

