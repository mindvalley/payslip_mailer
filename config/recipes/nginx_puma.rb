namespace :nginx_puma do
  desc "Setup nginx configuration for this application (puma)"
  task :setup, roles: :web do
    template "nginx_puma.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
  end
  after 'nginx_puma:setup', 'nginx:restart'
end