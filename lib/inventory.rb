class Inventory
  
  def self.get_inventory(client,params)
    arr = Array.new
      parsed_time = params[:timestamp]#DateTime.strptime(params[:timestamp],'%Y/%m/%d %H:%M:%S')
      geckobot = client.Product.where
      geckobot.each do |product|
        if !geckobot.nil?
          product.variant_ids.each do |id|
            if !geckobot.nil?
              arr<<id
            end
          end
        end
      end  
    return createWombatInventory(arr,client)
  end
  
 def self.createWombatInventory(ids,client)
    variants = client.Variant.find_many(ids)
    obj = variants.map do |variant|
      {
      :id => variant.id,
      :trid => variant.id,
      :product_id => variant.product_id,
      :quantity => variant.stock_on_hand.to_f,  
      :created_at => variant.created_at,
      :updated_at => variant.updated_at,  
      }
    end
    
    return obj   
  end
  
end

