json.array!(@numbers) do |number|
  json.extract! number, :id, :phone_num, :real_num, :apply_at, :company_id
  json.url number_url(number, format: :json)
end
