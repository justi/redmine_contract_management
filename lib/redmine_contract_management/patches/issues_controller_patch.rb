# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2011-2015 Kirill Bezrukov
# http://www.redminecrm.com/
#
# redmine_contacts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts.  If not, see <http://www.gnu.org/licenses/>.

require_dependency 'issues_controller'

module RedmineContractManagement
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
        end
      end

      module InstanceMethods
        def new_contract_issue
          @deals = []
          q = (params[:q] || params[:term]).to_s.strip
          if q.present?
            scope = Deal.joins(:project).where({})
            scope = scope.limit(params[:limit] || 10)
            scope = scope.by_project(@project) if @project
            if q.match(/\A#?(\d+)\z/)
              @deals << scope.visible.find_by_id($1.to_i)
            end
            q.split(' ').collect{ |search_string| scope = scope.live_search(search_string) }
            @deals += scope.visible.order("#{Deal.table_name}.name")
            @deals.compact!
          end
          render :layout => false, :partial => 'deals'
        end
      end
    end
  end
end

unless IssuesController.included_modules.include?(RedmineContractManagement::Patches::IssuesControllerPatch)
  IssuesController.send(:include, RedmineContractManagement::Patches::IssuesControllerPatch)
end
