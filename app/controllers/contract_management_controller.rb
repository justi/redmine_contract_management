#encoding: utf-8

class ContractManagementController < ApplicationController
  unloadable


  before_filter :find_contract_management_project
  skip_before_filter :verify_authenticity_token
  accept_api_auth :new_contract_issue
    
  def new_contract_issue
    if @project_cm && params
      contract = Issue.new(project: @project_cm)
      contract_partner = find_or_create_partner(params)
      contact.custom_field_values = { IssueCustomField.find_by_name("Partner umowy").id => contract_partner.id} if contract_partner.present?
      contract.author = find_espeo_user

      process_name = contract_data["process_name"]
      trackers = @project_cm.trackers
      tracker = if precess_name = "Dodanie nowej umowy z Partnerem"
                  trackers.find_by_name("Umowa")
                elsif process_name == "Nowe zlecenie do umowy"
                  trackers.find_by_name("Zlecenie")
                elsif process_name.include? "Zgłoszenie błędu"
                  rackers.find_by_name("Błąd")
                end

      contract.tracker = tracker

      contract_number = contract_data["Numer Umowy"]
      contact.custom_field_values = { IssueCustomField.find_by_name("Numer umowy / Contract number").id => contract_number }
        
      contract_type = contract_data["Typ umowy"]
      if IssueCustomField.find_by_name("Typ umowy").possible_values.include? contract_type
        contact.custom_field_values = { IssueCustomField.find_by_name("Typ umowy").id => contract_type }
      end

      invoicing = contract_data["Fakturowanie"]
      if IssueCustomField.find_by_name("Fakturowanie").possible_values.include? invoicing
        contact.custom_field_values = { IssueCustomField.find_by_name("Fakturowanie").id => invoicing }
      end

      start_ts = contract_data["Początek umowy"]
      contract.start_date = Time.at(start_ts).utc if start_ts.present?

      end_ts = contract_data["Koniec umowy"]
      contract.due_date = Time.at(end_ts).utc if end_ts.present?

      contract_url = contract_data["Link do dokumentu"]
      contact.custom_field_values = { IssueCustomField.find_by_name("Link do umowy").id => contract_url }

      error_number = contract_data["Numer błędu"]
      contact.custom_field_values = { IssueCustomField.find_by_name("Numer").id => error_number }
    end

    if contract.save
    else
    end
  end

  private 

    def serialize_contract_from_json(contract_data)
    #{"process_name":"Nowe zlecenie do umowy", "Nazwa Partnera":"Netmachina","Typ umowy":"Ramowa","Numer umowy":"UR 1\/2013","Numer zlecenia":"001","Opis":"opisjest","Data realizacji":1446246000000,"Akceptacja b\u0142\u0119du":true}'

      # second_partner_name = contract_data["Podaj nazwę Drugiego Partnera"]
      # second_partner_address = contract_data["Podaj adres drugiego Partnera"]
      # second_partner_nip_object = contract_data["Podaj NIP drugiego Partnera"]

      # type_of_settlement = contract_data["Typ rozliczenia"]
      # contract_state = contract_data["Status umowy"]
      # contract_setup_deadline_ts = contract_data["Data krytyczna na przygotowanie umowy"]

      # first_partner_person_accept_lawyer = contract_data["Osoba akceptująca - Partner Prawnik"]
      # first_partner_person_accept_management = contract_data["Osoba akceptująca - Partner Zarząd"]

      # second_partner_person_accept_lawyer = contract_data["Osoba Akceptująca prawnik PArtner Drugi"]
      # second_partner_person_accept_management = contract_data["Osoba akceptująca - Partner Drugi Zarząd"]

      # first_partner_lawyer_acceptance = contract_data["Akceptacja prawna Partner Prawnik"]
      # first_partner_lawyer_comments = contract_data["Uwagi od Prawnika Partnera"]
      # first_partner_management_comments = contract_data["Uwagi Partner Zarząd"]

      # negotiations_on_hold = contract_data["Negocjacje Zawieszone"]

      # first_partner_contract_acceptance = contract_data["Partner akceptuje umowę"]
      # second_partner_contract_acceptance = contract_data["Partner Drugi akceptacja"]

    end

    def find_contract_management_project
      project_id = Setting['plugin_redmine_contract_management']['contract_management_project']
      @project_cm = Project.find_by_id(project_id)
    end

    def find_espeo_user
      User.find_by_firstname("Sylwia")
    end

    def find_or_create_partner(contract_data)
      partner_name = contract_data["Nazwa Partnera"]
      contact = Contact.by_project(@project_cm).find_by_first_name(partner_name)
      unless contact.present?
        contact = Contact.new(project: @project_cm, first_name: partner_name)
        nip_number = contract_data["NIP Partnera"] || "brak"
        contact.custom_field_values = { ContactCustomField.find_by_name("Company nip number").id => nip_number}
        first_partner_address = contract_data["Adres Partnera"]
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
