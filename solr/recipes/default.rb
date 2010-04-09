#
# Cookbook Name:: solr
# Recipe:: default
#

include_recipe "s3"
require "aws/s3"
require 'digest/sha1'

AWS::S3::Base.establish_connection!(
    :access_key_id     => node[:s3][:access_key_id],
    :secret_access_key => node[:s3][:secret_access_key]
)

package "default-jdk"

directory "/var/log/solr" do
  owner "solr"
  group "bueda"
  mode 0755
  recursive true
end

#TODO register this as a service
remote_file "/etc/init.d/jetty" do
  source "jetty.sh"
  owner "root"
  group "root"
  mode 0755
end

template "/etc/default/jetty" do
  source "jetty.erb"
  owner "root"
  group "root"
  mode 0755
  variables({
    :config => node[:solr]
  })
end

remote_file "/tmp/apache-solr-1.4.0.tgz" do
  source "http://mirror.cloudera.com/apache/lucene/solr/1.4.0/apache-solr-1.4.0.tgz"
  owner "solr"
  group "bueda"
  mode 0755
end

execute "tar -xzf /tmp/apache-solr-1.4.0.tgz -C /tmp apache-solr-1.4.0/example" do
  creates "/tmp/apache-solr-1.4.0"
  action :run
end

execute "mv /tmp/apache-solr-1.4.0/example #{node[:solr][:home]}" do
  creates node[:solr][:home]
  action :run
end

execute "chown -R solr:bueda /mnt/solr"

remote_file "#{node[:solr][:home]}/etc/jetty-logging.xml" do
  source "jetty-logging.xml"
  owner "solr"
  group "bueda"
  mode 0755
end

#TODO how will we change this for different data sources?
remote_file "#{node[:solr][:home]}/solr/conf/schema.xml" do
  source node[:solr][:schema]
  owner "solr"
  group "bueda"
  mode 0755
end

#TODO config parameterize this
open("/tmp/freebase-index.tar.gz", "w") do |file|
  obj = AWS::S3::S3Object.find "freebase-index.tar.gz", "bueda.deploy"
  file.write obj.value
end unless File.exists?("/tmp/freebase-index.tar.gz")

execute "tar -xzf /tmp/index.tar.gz -C #{node[:solr][:home]}/solr/data/"

service "jetty" do
  action [:enable, :start]
end