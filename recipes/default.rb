#
# Cookbook Name:: zypper
# Recipe:: default
#
# Copyright 2013-2014, Thomas Boerger <thomas@webhippie.de>
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
# See the License for the specific language governing permissions and
# limitations under the License.
#

if node["platform_family"] == "suse"
  node["zypper"]["repos"].each do |repo|
    zypper_repository repo["alias"] do
      uri repo["uri"]
      title repo["title"]

      if repo["key"]
        key repo["key"]
      end

      if repo["keyserver"]
        keyserver repo["keyserver"]
      end

      notifies :run, "execute[zypper_refresh]"
    end
  end

  execute "zypper_refresh" do
    command "zypper --non-interactive --gpg-auto-import-keys refresh"
    ignore_failure true

    action :nothing
  end.run_action(:run)

  node["zypper"]["packages"].each do |name|
    package name do
      action :install
    end.run_action(:install)
  end
end
