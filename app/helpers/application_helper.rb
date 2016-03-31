module ApplicationHelper

	def t_model_name(model)
		model.model_name.human
	end
	def t_attr_name(model,model_attr)
		model.human_attribute_name model_attr
	end
end
