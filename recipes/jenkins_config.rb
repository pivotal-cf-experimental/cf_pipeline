include_recipe 'jenkins::server'

template "#{node['jenkins']['server']['home']}/config.xml" do
  source 'jenkins_config.xml.erb'
  owner node['jenkins']['server']['user']
  group node['jenkins']['server']['user']
  mode 00644

  github_config = node['cf_pipeline']['github_oauth']

  variables(
    'cf_pipeline_version' => run_context.cookbook_collection['cf_pipeline'].metadata.version,
    'cf_jenkins_version' => run_context.cookbook_collection['cf-jenkins'].metadata.version,
    'use_security' => github_config['enable'],
    'github_user_org' => github_config['organization'],
    'github_user_admins' => github_config['admins'],
    'github_client_id' => github_config['client_id'],
    'github_client_secret' => github_config['client_secret']
  )

  notifies :restart, 'service[jenkins]', :delayed
end
