=begin
#<
This recipe installs and configures the application and its content. It also
installs Apache 2, if not installed already.
#>
=end

include_recipe 'phpipam::_check_ipam_version'
include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'phpipam::_install_apache2'

GIT_SRC = 'https://github.com/phpipam/phpipam.git'.freeze
DEV_SHA256 = '377139d7489376ac3622d936dbce16b1823358a1'.freeze

CONTENT_OWNER = 'www-data'.freeze
CONTENT_GROUP = 'www-data'.freeze

package 'git' do
  action :install
end

directory node['phpipam']['docroot'] do
  action :create
  group CONTENT_GROUP
  recursive true
  user CONTENT_OWNER
end

git 'ipam_download' do
  action :export
  destination node['phpipam']['docroot']
  group CONTENT_GROUP
  repository GIT_SRC
  if node['phpipam']['version'] == 'dev'
    revision DEV_SHA256
  else
    revision node['phpipam']['version']
  end
  user CONTENT_OWNER
end

template "#{node['phpipam']['docroot']}/.htaccess" do
  group CONTENT_GROUP
  mode 0644
  source "htaccess_#{node['phpipam']['version']}.erb"
  user CONTENT_OWNER
  variables(
    uri_base: node['phpipam']['uri_base'],
  )
end

template "#{node['phpipam']['docroot']}/config.php" do
  group CONTENT_GROUP
  mode 0644
  source "config.php_#{node['phpipam']['version']}.erb"
  user CONTENT_OWNER
  variables(
    db_host: node['phpipam']['db_host'],
    db_name: node['phpipam']['db_name'],
    db_password: node['phpipam']['db_password'],
    db_user: node['phpipam']['db_user'],
    uri_base: node['phpipam']['uri_base'],
  )
end
