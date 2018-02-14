#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def rook_create(kubeconfig,config_file)
  cmd_string = ["KUBECONFIG=#{kubeconfig}", 'kubectl', 'create', '-f ' ]
  cmd_string << "#{config_file}" unless config_file.nil?
  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, stderr if status != 0
  { status: stdout.strip }
end
s
params = JSON.parse(STDIN.read)
kubeconfig = params['kubeconfig']
config_file = params['config_file']


begin
  result = rook_create(kubeconfig,config_file)
  puts result
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message })
  exit 1
end