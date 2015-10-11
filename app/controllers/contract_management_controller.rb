class ContractManagementController < ApplicationController
  unloadable
  
  skip_before_filter :verify_authenticity_token
  accept_api_auth :new_contract_issue
    
  def new_contract_issue
  
  end

end
