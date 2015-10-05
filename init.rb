Redmine::Plugin.register :redmine_contract_management do
  settings default: {'empty' => true}, partial: 'redmine_contract_management/settings'
  name 'Redmine Contract Management plugin'
  author 'Justyna Wojtczak'
  description 'This is a plugin for Redmine'
  version '0.0.2'
end
