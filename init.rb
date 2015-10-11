Redmine::Plugin.register :redmine_contract_management do
  settings default: {'empty' => true}, partial: 'redmine_contract_management/settings'
  name 'Redmine Contract Management plugin'
  author 'Justyna Wojtczak'
  description 'This is a plugin for Redmine'
  version '0.0.2'

end

Rails.application.config.to_prepare do  
  project_id = Setting['plugin_redmine_contract_management']['contract_management_project']
  if project_id.present?
  	project_name = Project.find(project_id).try(:name)
  	Redmine::MenuManager.map(:top_menu)
  						.push(:project, { :controller => 'projects', :action => 'show', id: project_id }, :last => true,  :caption => project_name)
  end
  Redmine::MenuManager.map(:top_menu).delete(:help)

  # move administration link to end
  Redmine::MenuManager.map(:top_menu).delete :administration
  Redmine::MenuManager.map(:top_menu).push :administration, { :controller => 'admin', :action => 'index' }, :if => Proc.new { User.current.admin? }, :last => true
end