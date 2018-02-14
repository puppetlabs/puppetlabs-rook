#!/opt/puppetlabs/puppet/bin/ruby
require 'json'
require 'open3'
require 'puppet'

def rook_namespace(kubeconfig,namespace)
  cmd_string = ["KUBECONFIG=#{kubeconfig}", 'kubectl', 'create', 'namespace  ']
  cmd_string << "#{namespace}" unless namespace.nil?
  stdout, stderr, status = Open3.capture3(cmd_string)
  raise Puppet::Error, stderr if status != 0
  { status: stdout.strip }
end

params = JSON.parse(STDIN.read)
kubeconfig= params['kubeconfig']
namespace = params['namespace']


begin
  result = rook_namespace(kubeconfig,namespace)
  puts result
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message })
  exit 1
end