require 'require_all'
require 'sinatra'
require 'json'
require 'active_support/core_ext/hash/indifferent_access'

require_all 'lib'


class TwilioApp < Sinatra::Base
  
  post '/add_order' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Orders.add_order(order,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data }.to_json + "\n" 
      else
        { order: status.data,request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.inspect}.to_json + "\n" 
    end
    
  end
  
  post '/update_order' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Orders.update_order(order,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data }.to_json + "\n" 
      else
        { order: status.data,request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.inspect}.to_json + "\n" 
    end
    
  end
  
  post '/update_customer' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      customer = payload[:customer]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Customers.update_customer(customer,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data }.to_json + "\n" 
      else
        { request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.inspect}.to_json + "\n" 
    end
    
  end
  
  post '/add_customer' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      customer = payload[:customer]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Customers.add_customer(customer,client)
      if status.status == 0
        status 500
        { request_id: request_id, summary: status.data }.to_json + "\n" 
      else
        { customer: status.data,request_id: request_id, summary: "success"}.to_json + "\n"
      end
    
    rescue => e
      return {request_id: request_id, summary: e.inspect}.to_json + "\n" 
    end
    
  end
  
  post '/cancel_order' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Orders.cancel_order(order,client)
      if status==false
        status 500
        { request_id: request_id, summary: "Order is not in a cancelable state" }.to_json + "\n" 
      else
        { request_id: request_id, summary: status }.to_json + "\n" 
      end
    
    rescue => e
      return { orders: status,request_id: request_id, summary: "Invalid credentials"}.to_json + "\n" 
    end
    
  end
  
  post '/get_products' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      order = payload[:order]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Products.get_products(client,params)
      timestamp = {:timestamp => DateTime.now.to_datetime.iso8601}
      if status==false
        status 500
        { request_id: request_id, summary: "Error occurred",parameters: timestamp }.to_json + "\n" 
      else
        { product: status,parameters: timestamp,request_id: request_id, summary: "success"}.to_json + "\n" 
      end
    
    rescue => e
      return { product: status,request_id: request_id, summary: e.message}.to_json + "\n" 
    end
  end
  
  post '/get_shipments' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Shipments.get_shipments(client,params)
      timestamp = {:timestamp => DateTime.now.to_datetime.iso8601}
      if status==false
        status 500
        { request_id: request_id, summary: "Error occurred",parameters: timestamp }.to_json + "\n" 
      else
        { shipment: status,parameters: timestamp,request_id: request_id, summary: "success"}.to_json + "\n" 
      end
    
    rescue => e
      return {request_id: request_id, summary: e.message}.to_json + "\n" 
    end
  end
  
  post '/get_inventory' do
    
    begin
      content_type :json
      payload = JSON.parse(request.body.read).with_indifferent_access
      request_id = payload[:request_id]
      params = payload[:parameters]
      tg_code = params[:appid]
      tg_secret = params[:secret]
      tg_username = params[:username]
      tg_password = params[:password]
      
      client = Gecko::Client.new(tg_code, tg_secret)
      client.access_token = code(tg_username,tg_password,tg_code, tg_secret)
      
      status = Inventory.get_inventory(client,params)
      timestamp = {:timestamp => DateTime.now.to_datetime.iso8601}
      if status==false
        status 500
        { request_id: request_id, summary: "Error occurred",parameters: timestamp }.to_json + "\n" 
      else
        { inventory: status,parameters: timestamp,request_id: request_id, summary: "success"}.to_json + "\n" 
      end
    
    rescue => e
      return { inventory: status,request_id: request_id, summary: e.message}.to_json + "\n" 
    end
  end
  
  def code(username,password,id,secret)
    token = aclient(id,secret)
    pass =  token.password.get_token(username, password)#aclient.auth_code.authorize_url(:redirect_uri => redirect_uri)  
    return pass
  end  
end