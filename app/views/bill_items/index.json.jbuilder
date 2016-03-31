json.array!(@bill_items) do |bill_item|
  json.extract! bill_item, :id, :voice, :message, :internet, :service, :proxy, :bill
  json.url bill_item_url(bill_item, format: :json)
end
