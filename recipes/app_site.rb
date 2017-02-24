=begin
#<
This recipe installs and configures the application and its content. It also
installs Apache 2, if `node['phpipam']['install_apache']` is set to true (the
default).
#>
=end

include_recipe 'phpipam::_check_version'
include_recipe 'apt::default'
include_recipe 'phpipam::_install_apache2' if node['phpipam']['install_apache']

GIT_SRC = 'https://github.com/phpipam/phpipam.git'.freeze

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
  revision node['phpipam']['version']
  user CONTENT_OWNER
end

template "#{node['phpipam']['docroot']}/.htaccess" do
  group CONTENT_GROUP
  mode 0644
  source "htaccess_#{node['phpipam']['version']}.erb"
  user CONTENT_OWNER
  variables(
    uri_base: node['phpipam']['uri_base']
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
    uri_base: node['phpipam']['uri_base']
  )
end
