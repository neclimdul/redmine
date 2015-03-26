# comments!

mysql_service 'default' do
  version node['mysql']['version']
  action [:create, :start]
  initial_root_password node['mysql']['server_root_password']
end
