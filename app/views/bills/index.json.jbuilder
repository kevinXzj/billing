json.array!(@bills) do |bill|
  json.extract! bill, :id, :company, :year, :month, :remark
  json.url bill_url(bill, format: :json)
end
