def get_crm_cats_criteria_filters
  [
   { :model => Account, :filters => { :"cats.id" => { :text => "category", :source => get_crm_cat_criteria_options("Account"), :condition => get_crm_cat_criteria_condition } } },
   { :model => Contact, :filters => { :"cats.id" => { :text => "category", :source => get_crm_cat_criteria_options("Contact"), :condition => get_crm_cat_criteria_condition } } },
   { :model => Lead, :filters => { :"cats.id" => { :text => "category", :source => get_crm_cat_criteria_options("Lead"), :condition => get_crm_cat_criteria_condition } } },
   { :model => Opportunity, :filters => { :"cats.id" => { :text => "category", :source => get_crm_cat_criteria_options("Opportunity"), :condition => get_crm_cat_criteria_condition } } },
   { :model => Campaign, :filters => { :"cats.id" => { :text => "category", :source => get_crm_cat_criteria_options("Campaign"), :condition => get_crm_cat_criteria_condition } } },
  ]
end

def get_crm_cat_criteria_options(model)
  lambda { |options| Cat.find_for_model(model).map { |cat| [cat.long_name, cat.id] } }
end

def get_crm_cat_criteria_condition
  lambda { |value, model| 
    cats_querys = ["cats.id = #{value}"]
    
    Cat.find(value.first).ancestors.map {|cat| cat.id }.each do |anc_cat|
      cats_querys << "cats.id = #{anc_cat}"
    end

    "(#{cats_querys.join(" or ")}) and cat_type = '#{model.to_s}'"
  }
end