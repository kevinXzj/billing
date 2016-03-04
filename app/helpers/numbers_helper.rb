module NumbersHelper
	def number_model_name
		Number.model_name.human
	end
	def number_attribute_name(attribute)
		Number.human_attribute_name(attribute)
	end
end
