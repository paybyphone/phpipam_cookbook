=begin
#<
This recipe installs the PHPIPAM database by creating the DB (root access
required to the DB server) and importing the schema. It also installs MySQL,
if `node['phpipam']['install_mysql']` is set to true (the default).
#>
=end

include_recipe 'phpipam::_check_ipam_version'
include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'phpipam::_install_mysql' if node['phpipam']['install_mysql']

cookbook = run_context.cookbook_collection[cookbook_name]
schema_cache_path = cookbook.preferred_filename_on_disk_location(
  run_context.node,
  :files,
  "ipam_schema_#{node['phpipam']['version']}.sql"
)

TABLE_COUNT_SQL = <<EOS.freeze
mysql -h localhost -u#{node['phpipam']['db_user']} \
-p#{node['phpipam']['db_password']} #{node['phpipam']['db_name']} -B -N \
-e "select count(*) from information_schema.tables \
  where table_type = 'BASE TABLE' \
  and table_schema = '#{node['phpipam']['db_name']}'" | egrep '^0$'
EOS

mysql_client 'default' do
  action :create
end

chef_gem 'mysql2' do
  compile_time false
  action :install
end

mysql_connection_info = {
  host:     node['phpipam']['db_host'],
  username: 'root',
  password: node['phpipam']['db_root_password']
}

mysql_database node['phpipam']['db_name'] do
  connection mysql_connection_info
  action :create
end

mysql_database_user node['phpipam']['db_user'] do
  connection mysql_connection_info
  password node['phpipam']['db_password']
  database_name node['phpipam']['db_name']
  host 'localhost'
  action :grant
end

execute 'import_ipam_schema' do
  command <<EOS
mysql -h localhost -u#{node['phpipam']['db_user']} \
-p#{node['phpipam']['db_password']} #{node['phpipam']['db_name']} \
< #{schema_cache_path}
EOS
  action :run
  only_if TABLE_COUNT_SQL
end
