include_recipe 'apt::default'

mysql_client 'default' do
  action :create
end

chef_gem 'mysql2' do
  compile_time false
  action :install
end

mysql_service 'default' do
  initial_root_password node['phpipam']['db_root_password']
  action [:create, :start]
end

# Symlink default mysqld socket path
directory '/var/run/mysqld' do
  recursive true
  action :delete
end

link '/var/run/mysqld' do
  to '/var/run/mysql-default'
  action :create
end

# Delete distribution mysql init script
file '/etc/init.d/mysql' do
  action :delete
end

