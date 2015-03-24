class OrderLineItems
  def self.add_order_line_items(orderlines,client,order)
      geckobot = nil
      begin
        orderlines.each do |orderline|
          variant = client.Variant.where(sku: orderline[:product_id]).first
          if !variant.nil?
            geckobot = client.OrderLineItem.build(
            order_id: order.id,
            variant_id: variant.id,
            quantity: orderline.has_key?('quantity') ? orderline[:quantity] : "2",
            price: orderline.has_key?('price') ? orderline[:price] : "32",
            base_price: orderline.has_key?('base_price') ? orderline[:base_price] : "22",
            freeform: orderline.has_key?('freeform') ? orderline[:freeform] : "22",
            label: orderline.has_key?('label') ? orderline[:name] : "fdd"
            )
          if !geckobot.save
            return geckobot.errors.inspect
          end
          orderline[:trid] = geckobot.id
        end
        end
      rescue => e 
        return e
      end
    
    return orderlines
  end
  
  def self.update_order_line_items(orderlines,client,order)
    
    orderlines.each do |orderline|
      begin
      if !orderline.has_key?("trid")
        arr= Array.new
        arr<<orderline
        orderline = add_order_line_items(arr,client,order)
      else        
          geckobot = client.OrderLineItem.find(orderline[:trid])
          order_id = order.id,
          variant_id = orderline.has_key?('product_id') ? orderline[:product_id] : "",
          quantity = orderline.has_key?('quantity') ? orderline[:quantity] : "2",
          price = orderline.has_key?('price') ? orderline[:price] : "32",
          base_price = orderline.has_key?('base_price') ? orderline[:base_price] : "22",
          freeform = orderline.has_key?('freeform') ? orderline[:freeform] : "22",
          label = orderline.has_key?('label') ? orderline[:label] : "fdd"
          if !geckobot.save
            return geckobot.errors.inspect
          end
        end
      rescue => e 
        return e
      end
    end
    return orderlines
  end
  
end