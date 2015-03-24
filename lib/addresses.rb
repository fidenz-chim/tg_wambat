require 'ostruct' 
class Addresses
  
  def self.add_addresses(address,client,company,address_type)
    begin
      label = nil
      if address_type == 1
        label = 'billing'
      else
        label = 'shipping'
      end
      reply =  OpenStruct.new
      geckobot = client.Address.build(
          company_id: company.id, 
          company_name: company.name,
          country: address.has_key?('country') ? address[:country] : "",
          label: label,
          state: address.has_key?('state') ? address[:state] : "",
          address1: address.has_key?('address1') ? address[:address1] : "edit address",
          address2: address.has_key?('address2') ? address[:address2] : "",
          zip_code: address.has_key?('zipcode') ? address[:zipcode] : "",
          email: address.has_key?('email') ? address[:email] : "",
          city: address.has_key?('city') ? address[:city] : "",
          phone_number: address.has_key?('phone') ? address[:phone] : ""
          )
      if !geckobot.save
          input_string = geckobot.errors.inspect.to_s
          reply.status = 0
          reply.data = Errors.tg_error(input_string)
          return reply
        end
        address[:trid] = geckobot.id
        address[:id] = geckobot.id
      rescue => e 
        reply.status = 0
        reply.data = e.message
        return reply
      end
    
    reply.status = 1
    reply.data = address
    return reply 
  end
  
  def self.update_addresses(address,client,company,addr_type)
    begin
        geckobot = nil
        reply =  OpenStruct.new
        if addr_type == 1
          geckobot = client.Address.where(label: 'billing',company_id: company.id).first
          if geckobot.nil?
            address = add_addresses(address,client,company,1)
          end
        else
          geckobot = client.Address.where(label: 'shipping',company_id: company.id).first
          if geckobot.nil?
            address = add_addresses(address,client,company,2)
          end
        end      
        if !geckobot.nil? 
            geckobot.company_id = company.id, 
            geckobot.company_name = company.name,
            geckobot.country = address.has_key?('country') ? address[:country] : geckobot.country,
            geckobot.city = address.has_key?('city') ? address[:city] : geckobot.city,
            geckobot.state = address.has_key?('state') ? address[:state] : geckobot.state,
            geckobot.address1 = address.has_key?('address1') ? address[:address1] : geckobot.address1,
            geckobot.address2 = address.has_key?('address2') ? address[:address2] : geckobot.address2,
            geckobot.zip_code = address.has_key?('zipcode') ? address[:zipcode] : geckobot.zip_code,
            geckobot.email = address.has_key?('email') ? address[:email] : geckobot.email,
            geckobot.phone_number = address.has_key?('phone') ? address[:phone] : geckobot.phone_number
            if !geckobot.save
              input_string = geckobot.errors.inspect.to_s
              reply.status = 0
              reply.data = Errors.tg_error(input_string)
              return reply
            end
        end
      rescue => e 
        reply.status = 0
        reply.data = e.message
        return reply
      end
    
    reply.status = 1
    reply.data = geckobot
    return reply 
  end
  
  def self.getWombatAddress(address_id,client)
    address = client.Address.find(address_id)
    obj = 
      {
      :id => address.id,
      :trid => address.id,
      :firstname => address.company_name,
      :address1 => address.address1,
      :address2 => address.address2,
      :zipcode => address.zip_code,
      :city => address.city,
      :state => address.state,
      :created_at => address.created_at,
      :updated_at => address.updated_at,
      :country => address.country,
      :phone => address.phone_number    
      }
    
    return obj   
  end
  
  def self.check_address(address,client)
      if address.has_key?("phone")
        if is_phone_exists(address[:phone],client)
          return 0
        else
          return 1
        end
      else
        return 2
      end   
  end
  
  def self.is_phone_exists(phone,client)
    geckobot = client.Address.where(phone_number: phone).first
        if geckobot.nil?
          return false
        end
        return false
  end
  
end