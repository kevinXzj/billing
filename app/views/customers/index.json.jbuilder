json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :linkman, :phone, :address, :remark
  json.url customer_url(customer, format: :json)
end
