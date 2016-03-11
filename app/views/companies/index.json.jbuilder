json.array!(@companies) do |company|
  json.extract! company, :id, :name, :bill_number, :tel_office, :apply_at
  json.url company_url(company, format: :json)
end
