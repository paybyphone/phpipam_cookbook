=begin
#<
This recipe installs backups using the [Ruby backup gem][1]. Options are
available in node attributes for sending the backups to S3, syslog logging, and
specifying notifier configuration through the
`node['phpipam']['backup_notifiers']` array. See the description section for
examples.

[1]: https://github.com/backup/backup

#>
=end

package 'zlib1g-dev' do
  action :install
end

ruby_runtime '2'

ruby_gem 'backup'

group node['phpipam']['backup_user'] do
  action :create
end

user node['phpipam']['backup_user'] do
  action :create
  gid node['phpipam']['backup_user']
  home node['phpipam']['backup_home']
  manage_home true
end

[
  "#{node['phpipam']['backup_home']}/etc",
  "#{node['phpipam']['backup_home']}/etc/models",
  "#{node['phpipam']['backup_home']}/log",
  "#{node['phpipam']['backup_home']}/data",
  "#{node['phpipam']['backup_tmp_path']}",
  "#{node['phpipam']['backup_storage_path']}"
].each do |dir|
  directory dir do
    user node['phpipam']['backup_user']
    group node['phpipam']['backup_user']
    action :create
  end
end

template "#{node['phpipam']['backup_home']}/etc/config.rb" do
  action :create
  group node['phpipam']['backup_user']
  source 'backup_config.rb.erb'
  user node['phpipam']['backup_user']
  variables(
    backup_home:              node['phpipam']['backup_home'],
    backup_tmp_path:          node['phpipam']['backup_tmp_path'],
    backup_enable_logfile:    node['phpipam']['backup_enable_logfile'],
    backup_enable_syslog:     node['phpipam']['backup_enable_syslog'],
    ignore_warning_messages:  node['phpipam']['backup_ignore_warning_messages']
  )
end

template "#{node['phpipam']['backup_home']}/etc/models/phpipam_backup.rb" do
  action :create
  group node['phpipam']['backup_user']
  source 'backup_model.rb.erb'
  user node['phpipam']['backup_user']
  variables(
    db_name:                      node['phpipam']['db_name'],
    db_username:                  node['phpipam']['db_user'],
    db_password:                  node['phpipam']['db_password'],
    db_host:                      node['phpipam']['db_host'],
    backup_storage_path:          node['phpipam']['backup_storage_path'],
    backup_keep_days_local:       node['phpipam']['backup_keep_days_local'],
    backup_s3_enabled:            node['phpipam']['backup_s3_enabled'],
    backup_s3_access_key_id:      node['phpipam']['backup_s3_access_key_id'],
    backup_s3_secret_access_key:  node['phpipam']['backup_s3_secret_access_key'],
    backup_s3_region:             node['phpipam']['backup_s3_region'],
    backup_s3_bucket:             node['phpipam']['backup_s3_bucket'],
    backup_s3_path:               node['phpipam']['backup_s3_path'],
    backup_keep_days_s3:          node['phpipam']['backup_keep_days_s3'],
    backup_notifiers:             node['phpipam']['backup_notifiers']
  )
end

cron 'ipam_backup' do
  action :create
  command  "backup perform --config-file #{node['phpipam']['backup_home']}/etc/config.rb --trigger phpipam_backup"
  hour     node['phpipam']['backup_cron_hour']
  minute   node['phpipam']['backup_cron_minute']
  user     node['phpipam']['backup_user']
  weekday  node['phpipam']['backup_cron_weekday']
end
