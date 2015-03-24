class Shipments
  
  def self.get_shipments(client,params)
    arr = Array.new
      parsed_time = params[:timestamp]#DateTime.strptime(params[:timestamp],'%Y/%m/%d %H:%M:%S')
      geckobot = client.Fulfillment.where
      geckobot.each do |fulfillment|
        if !geckobot.nil? && fulfillment.updated_at.to_datetime.iso8601>parsed_time
          arr<< fulfillment
        end
      end  
    return createWombatShipment(arr,client)
  end
  
  def self.createWombatShipment(shipments,client)
    obj = shipments.map do |shipment|
      raw_fulfillment = client.FulfillmentLineItem.find_many(shipment.fulfillment_line_item_ids)
      items = createWombatFulfillmentItem(raw_fulfillment,client)
      {
      :id => shipment.id,
      :trid => shipment.id,
      :order_id => shipment.order_id,
      :shipped_at => shipment.shipped_at,
      :shipping_method => shipment.delivery_type,
      :shipping_address => Addresses.getWombatAddress(shipment.shipping_address_id,client),
      :billing_address => Addresses.getWombatAddress(shipment.billing_address_id,client),
      :tracking => shipment.tracking_number,
      :status => shipment.status,
      :tracking_url => shipment.tracking_url,
      :created_at => shipment.created_at,
      :updated_at => shipment.updated_at,
      :fulfillment_line_item_ids => shipment.fulfillment_line_item_ids,
      :notes => shipment.notes,
      :items => items     
      }
    end
    
    return obj   
  end
  
  def self.createWombatFulfillmentItem(fulfillments,client)
    obj = fulfillments.map do |fulfillment|
      {
      :id => fulfillment.id,
      :trid => fulfillment.id,
      :fulfillment_id => fulfillment.fulfillment_id,
      :order_line_item_id => fulfillment.order_line_item_id,
      :quantity => fulfillment.quantity,
      :price => fulfillment.base_price, 
      :created_at => fulfillment.created_at,
      :updated_at => fulfillment.updated_at,  
      }
    end
    
    return obj   
  end
  
end

