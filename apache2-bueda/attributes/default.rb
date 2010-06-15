#
# Cookbook Name:: apache2-bueda
# Recipe:: default
#
# Copyright 2010, Bueda Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and # limitations under the License.
#

set_unless[:apache][:head_symlink] = "current"
set_unless[:apache][:wsgi_user] = "www-data"
set_unless[:apache][:wsgi_group] = "bueda"
set_unless[:apache][:log_facility] = "local1"
set_unless[:apache][:log_level] = "info"
