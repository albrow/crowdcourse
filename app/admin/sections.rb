ActiveAdmin.register Section do

	menu :parent => "Curricula", :priority => 3

	index do
		column :id
		column :priority
		column :name
		column :course
		column "# Components" do |sec|
			sec.components.size
		end

		default_actions
	end

	show do |comp|
		attributes_table do
			row :id
			row :priority
			row :name
			row :course
			row "# Components" do |sec|
				sec.components.size
			end
			row "Components" do |sec|
				(sec.components.map{|c| link_to c.name, admin_component_path(c) }).join(', ').html_safe
			end
			row :created_at
			row :updated_at
		end
	end
  
end
