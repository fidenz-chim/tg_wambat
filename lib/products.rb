class Products
  
  def self.add_product(product,client)
    geckobot = client.Product.build(name: product[:name], description: product[:description],status: "active", supplier: "Suchith")
    geckobot.save    
  end
  
  def self.get_products(client,params)
    arr = Array.new
      parsed_time = params[:timestamp]#DateTime.strptime(params[:timestamp],'%Y/%m/%d %H:%M:%S')
      geckobot = client.Product.where
      geckobot.each do |product|
        if !geckobot.nil? && product.updated_at.to_datetime.iso8601>parsed_time
          arr<< product
        end
      end
    return createWombatProduct(arr,client)
  end
  
  def self.createWombatProduct(products,client)
    obj = products.map do |product|
      raw_variants = client.Variant.find_many(product.variant_ids)
      variants = createWombatVariant(raw_variants,client)
      {
      :id => product.id,
      :trid => product.id,
      :name => product.name,
      :description => product.description,
      :product_type => product.product_type,
      :options => {:opt1 => product.opt1,:op2 => product.opt2,:opt3 => product.opt3},
      :properties =>{:brand => product.brand},
      :status => product.status,
      :tags => product.tags,
      :variant_ids => product.variant_ids,
      :variants => variants     
      }
    end
    
    return obj   
  end
  
  def self.createWombatVariant(variants,client)
    obj = variants.map do |variant|
      {
      :id => variant.id,
      :trid => variant.id,
      :product_id => variant.product_id,
      :name => variant.name,
      :description => variant.description,
      :price => variant.retail_price,
      :sku => variant.sku,
      :status => variant.status,
      :options => {:opt1 => variant.opt1,:op2 => variant.opt2,:opt3 => variant.opt3},
      :quantity => variant.stock_on_hand,  
      :created_at => variant.created_at,
      :updated_at => variant.updated_at,  
      }
    end
    
    return obj   
  end
  
end

