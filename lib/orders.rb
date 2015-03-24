require 'ostruct' 
class Orders
  
   def self.add_order(order,client)
     stat = nil
     customer_id = nil
     billing_addr_id = nil
     shipping_addr_id = nil
     reply =  OpenStruct.new
      begin
        if !order.has_key?('email')
          reply.status = 0
          reply.data = "email required"
          return reply
        end
        ord = client.Order.where(order_number: order[:id]).first
        if !ord.nil?
          reply.status = 0
          reply.data = "order number already assigned"
          return reply
        end
        geckobot = client.Company.where(email: order[:email]).first
        if geckobot.nil?
          customer = Customers.create_customer_from_order(order,client)
          if customer.status==0
            return customer
          else
            customer_id = customer.data[:id]
            billing_addr_id = customer.data[:billing_address][:id]
            shipping_addr_id = customer.data[:shipping_address][:id]
          end
        else
           customer_id = geckobot.id
           billing_addr_id = geckobot.address_ids.first
           shipping_addr_id = geckobot.address_ids.last
        end
        
        geckobot = client.Order.build(
          company_id: customer_id,
          shipping_address_id: shipping_addr_id,
          billing_address_id: billing_addr_id,
          order_number: order[:id],
          reference_number: order[:reference_number],
          status: order.has_key?('status') ? set_status(order[:status]) : "active",
          issued_at: order[:placed_on],
          created_at: order[:created_at],
          updated_at: order[:updated_at],
          payment_status: order.has_key?('payments') ? set_payment(order[:payments][0][:status]) : "unpaid"
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
    stat = nil
    if order.has_key?("line_items")
      order_lines = order[:line_items]
      stat = OrderLineItems.add_order_line_items(order_lines,client,geckobot)
      order[:line_items] = stat
    end
    order[:trid] = geckobot.id
    reply.status = 1
    reply.data = order
    return reply 
  end
  
  
 
  
  def self.update_order(order,client)
      stat = nil
     customer_id = nil
     billing_addr_id = nil
     shipping_addr_id = nil
     reply =  OpenStruct.new
      begin
        if !order.has_key?('email')
          reply.status = 0
          reply.data = "email required"
          return reply
        end
        geckobot = client.Company.where(email: order[:email]).first
        if geckobot.nil?
          customer = Customers.create_customer_from_order(order,client)
          if customer.status==0
            return customer
          else
            customer_id = customer.data[:id]
            billing_addr_id = customer.data[:billing_address][:id]
            shipping_addr_id = customer.data[:shipping_address][:id]
          end
        else
           customer = Customers.update_customer_from_order(order,client)
           customer_id = customer.data[:id]
           billing_addr_id = customer.data[:billing_address][:id]
           shipping_addr_id = customer.data[:shipping_address][:id]
        end
        geckobot = client.Order.where(order_number: order[:id]).first
        if geckobot.nil?
          reply.status = 0
          reply.data = "Order not available"
          return reply
        end
        geckobot.company_id = customer_id
        geckobot.shipping_address_id = shipping_addr_id
        geckobot.billing_address_id = billing_addr_id
        geckobot.order_number = geckobot.order_number
        geckobot.reference_number = order.has_key?('reference_number') ? order[:reference_number] : geckobot.reference_number
        geckobot.status = order.has_key?('status') ? set_status(order[:status]) : geckobot.status
        geckobot.issued_at = order.has_key?('palced_on') ? order[:placed_on] : geckobot.issued_at
        geckobot.created_at = order.has_key?('created_at') ? order[:created_at] : geckobot.created_at
        geckobot.updated_at = order.has_key?('updated_at') ? order[:updated_at] : geckobot.updated_at
        geckobot.payment_status = order.has_key?('payments') ? set_payment(order[:payments][0][:status]) : geckobot.payment_status
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
    if order.has_key?("line_items")
      order_lines = order[:line_items]
      stat = OrderLineItems.add_order_line_items(order_lines,client,geckobot)
      order[:line_items] = stat
    end
    order[:trid] = geckobot.id
    reply.status = 1
    reply.data = order
    return reply 
  end
  
  def self.cancel_order(order,client)
      begin
        geckobot = client.Order.where(order_number: order[:id]).first
        geckobot.status = 'void'
        if !geckobot.save
          input_string = geckobot.errors.inspect.to_s
          reply.status = 0
          reply.data = Errors.tg_error(input_string)
          return reply
        end
      rescue => e 
        return "Cannot find the order"
      end
    return "Order canceled"
  end
  
  def self.set_status(status)
    if status=='complete'
      status='finalized'
    else
      status='active'
    end
  end
  
  def self.set_payment(payment)
    if payment=='completed'
      payment='paid'
    else
      payment='unpaid'
    end
  end
  
end