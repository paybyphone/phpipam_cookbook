include_recipe 'apt::default'

PHP_EXTRA_PACKAGES = [
  'php-pear',
  'php5-cli',
  'php5-curl',
  'php5-gd',
  'php5-gmp',
  'php5-ldap',
  'php5-mcrypt',
  'php5-mysql'
].freeze

PHP5_MANUAL_ENABLE_MODS = %w(
  mcrypt
).freeze

include_recipe "php::#{node['php']['install_method']}"

package 'php-pear' do
  action :install
end

package 'php_extra_packages' do
  package_name PHP_EXTRA_PACKAGES
  action :install
end

PHP5_MANUAL_ENABLE_MODS.each do |phpmod|
  execute "php5enmod #{phpmod}" do
    action :run
    only_if "! php5query -s apache2 #{phpmod}"
    notifies :restart, 'service[apache2]', :delayed
  end
end

node.default['apache']['mpm'] = 'prefork'

web_app 'phpipam' do
  allow_override ['All']
  cookbook 'phpipam'
  docroot node['phpipam']['docroot'].end_with?('/') ? node['phpipam']['docroot'] : "#{node['phpipam']['docroot']}/"
  server_aliases node['phpipam']['vhost_aliases']
  server_name node['phpipam']['vhost_name']
  template 'apache2_vhost.erb'
  uri_base node['phpipam']['uri_base']
end

include_recipe 'apache2::mod_php5'
