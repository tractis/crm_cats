def get_crm_cats_criteria_filters
  [{ :model => Account, :filters => { :"cats.id" => { :text => I18n.t(:category), :source => lambda { |options| Cat.all.map { |cat| [cat.long_name, cat.id] } } } } } ]
end