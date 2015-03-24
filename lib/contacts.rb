class Contacts
   def self.add_contacts(contacts,client,company,customer)
      contact = nil
      if contacts.has_key?('phone')
        contacts_all = company.contacts
        contacts_all.each do |cnts|
          if cnts.phone==contacts[:phone]
            contact = cnts
          end
        end
      end
      if contact.nil?
      contact = client.Contact.build(
          company_id: company.id, 
          first_name: customer.has_key?('firstname') ? customer[:firstname] : company.name,
          last_name: customer.has_key?('lastname') ? customer[:lastname] : "",
          email: contacts.has_key?('email') ? customer[:email] : "",
          phone_number: contacts.has_key?('phone') ? contacts[:phone] : ""
          )
      if !contact.save
          return contact.errors.inspect
        end
      end
      
    
    return contact
  end
  
  def self.update_contacts(contacts,client,company,customer)
    contact = nil
      if contacts.has_key?('phone')
        contacts_all = company.contacts
        contacts_all.each do |cnts|
          if cnts.phone==contacts[:phone]
            contact = cnts
          end
        end
      end
      if !contact.nil?      
        contact.company_id = company.id, 
        contact.first_name = customer.has_key?('firstname') ? customer[:firstname] : company.name,
        contact.last_name = customer.has_key?('lastname') ? customer[:lastname] : "",
        contact.email = contacts.has_key?('email') ? customer[:email] : "",
        contact.phone_number = contacts.has_key?('phone') ? contacts[:phone] : ""
        if !contact.save
          return contact.errors.inspect
        end
      else
        contact = add_contacts(contacts,client,company,customer)
      end
      
    
    return contact
  end
end