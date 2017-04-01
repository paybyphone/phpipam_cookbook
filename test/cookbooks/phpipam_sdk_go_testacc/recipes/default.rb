cookbook = run_context.cookbook_collection[cookbook_name]
file_cache_path = cookbook.preferred_filename_on_disk_location(
  run_context.node,
  :files,
  'testacc_configure.sql'
)

execute 'configure_ipam_testacc' do
  command <<EOS
mysql -h localhost -u#{node['phpipam']['db_user']} \
-p#{node['phpipam']['db_password']} #{node['phpipam']['db_name']} \
< #{file_cache_path}
EOS
  action :run
end
