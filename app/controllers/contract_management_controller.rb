#encoding: utf-8

class ContractManagementController < ApplicationController
  unloadable

  before_filter :find_contract_management_project
  skip_before_filter :verify_authenticity_token
  accept_api_auth :new_contract_issue
    
  def new_contract_issue
    if @project_cm && params
      @contract = Issue.new(project: @project_cm)
      
      contract_partner = find_or_create_partner(params)
      if contract_partner.present?
        update_custom_field("Partner umowy", contract_partner.id)
      end
      @contract.author = find_espeo_user
      @contract.assigned_to_id = @contract.author.id

      contract_subject = params["Opis"] || ("Umowa z " + contract_partner.first_name)
      @contract.subject = contract_subject

      process_name = params["process_name"]
      trackers = @project_cm.trackers
      if process_name == "Dodanie nowej umowy z Partnerem"
        tracker = trackers.find_by_name("Umowa")
        update_custom_field("Numer umowy / Contract number", params["Numer Umowy"])
        update_custom_field("Link do umowy", params["Link do dokumentu"])
        update_custom_field("Typ umowy", params["Typ umowy"])
      elsif process_name == "Nowe zlecenie do umowy"
        tracker = trackers.find_by_name("Zlecenie")
        update_custom_field("Numer umowy / Contract number", params["Numer umowy"])
        update_custom_field("Numer", params["Numer zlecenia"])
        update_custom_field("Typ umowy", params["Typ umowy"])
      elsif process_name.include? "Zgłoszenie błędu"
        tracker = trackers.find_by_name("Błąd")
        update_custom_field("Numer umowy / Contract number", params["Numer umowy"])
        update_custom_field("Numer", params["Numer błędu"])
        update_custom_field("Typ umowy", params["Typ umowa"])
      end

      @contract.tracker = tracker
      
      #update_custom_field("Fakturowanie", params["Fakturowanie"])
      start_ts = params["Początek umowy"]
      @contract.start_date = Time.at(start_ts/1000).utc.to_date if start_ts.present?

      end_ts = params["Koniec umowy"]
      @contract.due_date = Time.at(end_ts/1000).utc.to_date if end_ts.present?
    
      if @contract.save
        respond_to do |format|
          format.json { render_api_ok }
        end
      else
        render :json => { :errors => @contract.errors.full_messages }
      end
    end
  end

  private

    def update_custom_field(name, value)
      cf = CustomFieldValue.new
      cf.custom_field = IssueCustomField.find_by_name(name)
      cf.value = value
      @contract.custom_field_values << cf
    end

    def serialize_contract_from_json(params)
      # second_partner_name = params["Podaj nazwę Drugiego Partnera"]
      # second_partner_address = params["Podaj adres drugiego Partnera"]
      # second_partner_nip_object = params["Podaj NIP drugiego Partnera"]

      # type_of_settlement = params["Typ rozliczenia"]
      # contract_state = params["Status umowy"]
      # contract_setup_deadline_ts = params["Data krytyczna na przygotowanie umowy"]

      # first_partner_person_accept_lawyer = params["Osoba akceptująca - Partner Prawnik"]
      # first_partner_person_accept_management = params["Osoba akceptująca - Partner Zarząd"]

      # second_partner_person_accept_lawyer = params["Osoba Akceptująca prawnik PArtner Drugi"]
      # second_partner_person_accept_management = params["Osoba akceptująca - Partner Drugi Zarząd"]

      # first_partner_lawyer_acceptance = params["Akceptacja prawna Partner Prawnik"]
      # first_partner_lawyer_comments = params["Uwagi od Prawnika Partnera"]
      # first_partner_management_comments = params["Uwagi Partner Zarząd"]

      # negotiations_on_hold = params["Negocjacje Zawieszone"]

      # first_partner_contract_acceptance = params["Partner akceptuje umowę"]
      # second_partner_contract_acceptance = params["Partner Drugi akceptacja"]

    end

    def find_contract_management_project
      project_id = Setting['plugin_redmine_contract_management']['contract_management_project']
      @project_cm = Project.find_by_id(project_id)
    end

    def find_espeo_user
      #User.find_by_firstname("justi")
      User.find_by_firstname("Sylwia")
    end

    def find_or_create_partner(params)
      partner_name = params["Nazwa Partnera"]
      contact = Contact.by_project(@project_cm).find_by_first_name(partner_name)
      unless contact.present?
        contact = Contact.new(project: @project_cm, first_name: partner_name)
        if ContactCustomField.find_by_name("Company nip number")
          cf = CustomFieldValue.new
          cf.custom_field = ContactCustomField.find_by_name("Company nip number")
          nip_number = params["NIP Partnera"] || "brak"
          cf.value = nip_number
          contact.custom_field_values << cf
        end
        contact.is_company = true
        first_partner_address = params["Adres Partnera"]
        if first_partner_address.present?
          address = Address.new(full_address: first_partner_address)
          address.save
          contact.address = address
        end
        contact.save
      end
      contact
    end
end
