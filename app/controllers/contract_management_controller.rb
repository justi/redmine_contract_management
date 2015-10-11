#encoding: utf-8

class ContractManagementController < ApplicationController
  unloadable


  before_filter :find_contract_management_project
  skip_before_filter :verify_authenticity_token
  accept_api_auth :new_contract_issue
    
  def new_contract_issue
    if @project_cm && (contract_data = params[:data])
      build_contract_from_params(contract_data)
      if @contract
        @contract.project = @project_cm
        # @contract.author ||= User.current
        # @contract.tracker ||= @project.trackers.find((params[:issue] && params[:issue][:tracker_id]) || params[:tracker_id] || :first)
        # @contract.start_date ||= Date.today if Setting.default_issue_start_date_to_creation_date?
      end
    end
    #nip_object = invoice.contact.custom_value_for(ContactCustomField.find_by_name("Company nip number"))
    #if @contract.save
    #else
    #end
  end

  private 
    def build_contract_from_params(contract_data)
      parsed_data = serialize_contract_from_json(contract_data)
      #@contract = Issue.new(parsed_data)
    end

    def serialize_contract_from_json(contract_data)
      first_partner_name = contract_data["Nazwa Partnera"]
      first_partner_address = contract_data["Adres Partnera"]
      first_partner_nip_object = contract_data["NIP Partnera"]

      second_partner_name = contract_data["Podaj nazwę Drugiego Partnera"]
      second_partner_address = contract_data["Podaj adres drugiego Partnera"]
      second_partner_nip_object = contract_data["Podaj NIP drugiego Partnera"]

      contract_type = contract_data["Typ umowy"]
      start_ts = contract_data["Początek umowy"]
      end_ts = contract_data["Koniec umowy"]
      type_of_settlement = contract_data["Typ rozliczenia"]
      invoicing = contract_data["Fakturowanie"]
      contract_state = contract_data["Status umowy"]
      contract_setup_deadline_ts = contract_data["Data krytyczna na przygotowanie umowy"]
      contract_url = contract_data["Link do dokumentu"]

      first_partner_person_accept_lawyer = contract_data["Osoba akceptująca - Partner Prawnik"]
      first_partner_person_accept_management = contract_data["Osoba akceptująca - Partner Zarząd"]

      second_partner_person_accept_lawyer = contract_data["Osoba Akceptująca prawnik PArtner Drugi"]
      second_partner_person_accept_management = contract_data["Osoba akceptująca - Partner Drugi Zarząd"]

      first_partner_lawyer_acceptance = contract_data["Akceptacja prawna Partner Prawnik"]
      first_partner_lawyer_comments = contract_data["Uwagi od Prawnika Partnera"]
      first_partner_management_comments = contract_data["Uwagi Partner Zarząd"]

      negotiations_on_hold = contract_data["Negocjacje Zawieszone"]

      first_partner_contract_acceptance = contract_data["Partner akceptuje umowę"]
      second_partner_contract_acceptance = contract_data["Partner Drugi akceptacja"]

      contract_number = contract_data["Numer Umowy"]
    end

    def find_contract_management_project
      project_id = Setting['plugin_redmine_contract_management']['contract_management_project']
      @project_cm = Project.find_by_id(project_id)
    end
end
