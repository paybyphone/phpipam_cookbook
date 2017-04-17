SUPPORTED_VERSIONS = [
  '1.2',
  'dev'
].freeze

raise "Unsupported IPAM version: #{node['phpipam']['version']}" unless SUPPORTED_VERSIONS.include?(node['phpipam']['version'])
