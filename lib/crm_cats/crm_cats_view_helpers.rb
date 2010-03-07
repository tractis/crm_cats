module CrmCats
  module ViewHelpers

    #----------------------------------------------------------------------------
    def get_cats_for_model
      model = self.controller_name.singularize.camelize
      Cat.find_for_model(model).sort! { |a,b| a.long_name <=> b.long_name }
    end
  
    # Generate cat links for use on asset index pages.
    #----------------------------------------------------------------------------
    def cats_for_index(model)    
      model.cats.inject([]) do |arr, cat|
        # Ajax category filter if viewed from same controller (not from other asset, ex. viewing contacts from account view)
        if model.class.to_s.downcase.pluralize == controller.controller_name.to_s
          arr << link_to_function(cat.long_name, "crm.search_categorized('$#{cat.id}', '#{model.class.to_s.tableize}')", :title => cat.description)
        else
          arr << link_to(cat.long_name, { :controller => model.class.to_s.downcase.pluralize, :query => "$#{cat.id}" }, { :title => cat.description })
        end
      end.join(" ")
    end

    # Generate cat links for the asset landing page (shown on a sidebar).
    #----------------------------------------------------------------------------
    def cats_for_show(model)
      model.cats.inject([]) do |arr, cat|
        arr << link_to(cat.long_name, url_for(:action => "categorized", :id => cat), :title => cat.description)
      end.join(" ")
    end
  
    # Generate cat select for filter on the landing page of each asset (shown on a sidebar).
    #----------------------------------------------------------------------------
    def cats_for_landing
      select_tag 'filter_category', options_for_select(get_cats_for_model.map { |cat| [cat.long_name, cat.id] }.insert(0, ''), get_cats_search_id.to_i), { :style => "width:180px", :onchange => "crm.search_categorized(crm.get_category_filter(), '#{self.controller_name.to_s}')" }
    end
  
    # Get categories orderer by long_name for the current model
    #----------------------------------------------------------------------------
    def get_cats_for_model
      model = self.controller_name.singularize.camelize
      Cat.find_for_model(model).sort! { |a,b| a.long_name <=> b.long_name }
    end
    
    # Generate the collection select for edit
    #----------------------------------------------------------------------------    
    def get_cats_colletion_select
      model = self.controller_name.singularize
      collection_select model, :cat_ids, get_cats_for_model, :id, :long_name, { }, { :multiple => true, :size => '10', :style => "width:240px" }
    end
    
    # Returns the cat_id from the query string
    #---------------------------------------------------------------------------- 
    def get_cats_search_id
      unless @current_query.nil?
        @current_query.scan(/[\w$]+/).each do |token|
          if token.starts_with?("$")
            return token.gsub("$","").to_i
          end
        end
      end
      
      return 0      
    end
    
    # Quick-fix for view_hooks translations not working (needs review of fcc code)
    #----------------------------------------------------------------------------
    def get_cats_translation(string)
      t(string.to_sym)
    end
    
  end
end

ActionView::Base.send(:include, CrmCats::ViewHelpers)
