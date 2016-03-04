module CompaniesHelper
	def company_model_name
		Company.model_name.human
	end
	def company_attribute_name(attribute)
		Company.human_attribute_name attribute
	end
end
