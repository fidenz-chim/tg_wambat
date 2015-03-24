require 'ostruct' 
class Customers
  
  def self.add_customer(customer,client)
    begin
        reply =  OpenStruct.new
        if !customer.has_key?('email')
          reply.status = 0
          reply.data = "email required"
          return reply
        end
        if !customer.has_key?('firstname') || !customer.has_key?('lastname')
          reply.status = 0
          reply.data = "name required"
          return reply
        end
        geckobot = client.Company.where(email: customer[:email]).first
        if !geckobot.nil?
          reply.status = 0
          reply.data = "email exists"
          return reply
        end
        
        geckobot = client.Company.build(
          name: customer[:firstname]+" "+customer[:lastname], 
          phone_number: customer[:phone_number],
          email: customer[:email], 
          company_type: 'consumer'
          )
        if !geckobot.save
          input_string = geckobot.errors.inspect.to_s
          reply.status = 0
          reply.data = Errors.tg_error(input_string)
          return reply
        end
    rescue => e
      reply.status = 0
      reply.data = e.message
      return reply
    end 
    if customer.has_key?("billing_address")
      addrs = Addresses.add_addresses(customer[:billing_address],client,geckobot,1)
      contact = Contacts.add_contacts(customer[:billing_address],client,geckobot,customer)
      customer[:billing_address] = addrs.data
    end
    if customer.has_key?("shipping_address")
      addrs = Addresses.add_addresses(customer[:shipping_address],client,geckobot,2)
      contact = Contacts.add_contacts(customer[:shipping_address],client,geckobot,customer)
      customer[:shipping_address] = addrs.data
    end
    if customer.has_key?("contacts")
      cnts = Contacts.add_contacts(customer[:contacts],client,geckobot)
      customer[:contacts] = cnts
    end
    customer[:trid] = geckobot.id
    customer[:id] = geckobot.id
    customer[:address] = geckobot.address_ids.first
    reply.status = 1
    reply.data = customer
    return reply 
  end
  
  def self.update_customer(customer,client)
      begin
        reply =  OpenStruct.new
        if !customer.has_key?('email')
          reply.status = 0
          reply.data = "email required"
          return reply
        end
        if !customer.has_key?('firstname') || !customer.has_key?('lastname')
          reply.status = 0
          reply.data = "name required"
          return reply
        end
        
        geckobot = client.Company.where(email: customer[:email]).first
        if geckobot.nil?
          reply.status = 0
          reply.data = "customer not available"
          return reply      
        else
          geckobot.name = customer.has_key?('firstname') ? customer[:firstname]+" "+customer[:lastname] : geckobot.name, 
          geckobot.phone_number = customer.has_key?('phone_number') ? customer[:phone_number] : geckobot.phone_number,
          geckobot.email = customer.has_key?('email') ? customer[:email] : geckobot.email, 
          geckobot.company_type = 'consumer'
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
    #geckobot = client.Company.where(email: customer[:email]).first
    if customer.has_key?("billing_address")
      stat = Addresses.update_addresses(customer[:billing_address],client,geckobot,1)      
      contact = Contacts.update_contacts(customer[:billing_address],client,geckobot,customer)  
      customer[:billing_address] = stat.data
    end
    if customer.has_key?("shipping_address")
      stat = Addresses.update_addresses(customer[:shipping_address],client,geckobot,2)
      contact = Contacts.update_contacts(customer[:shipping_address],client,geckobot,customer) 
      customer[:shipping_address] = stat.data
    end
    if customer.has_key?("contacts")
      stat = Contacts.update_contacts(customer[:contacts],client,geckobot)
      customer[:contacts] = stat
    end
    if !geckobot.save
            input_string = geckobot.errors.inspect.to_s
            reply.status = 0
            reply.data = Errors.tg_error(input_string)
            return reply
          end
    customer[:trid] = geckobot.id
    customer[:id] = geckobot.id
    reply.status = 1
    reply.data = customer
    return reply
  end
  
  def self.create_customer_from_order(order,client)
    customer ={
      firstname: order[:billing_address][:firstname],
      lastname: order[:billing_address][:lastname], 
      email: order[:email], 
      company_type: 'consumer',
      billing_address: order[:billing_address],
      shipping_address: order[:shipping_address]
    }.with_indifferent_access
    return add_customer(customer,client)
  end
  
  def self.update_customer_from_order(order,client)
    customer ={
      firstname: order[:billing_address][:firstname],
      lastname: order[:billing_address][:lastname], 
      email: order[:email], 
      company_type: 'consumer',
      billing_address: order[:billing_address],
      shipping_address: order[:shipping_address]
    }.with_indifferent_access
    return update_customer(customer,client)
  end
  
end

