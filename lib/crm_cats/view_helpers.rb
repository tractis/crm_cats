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
        query = controller.send(:current_query) || ""
        hashcat = "$#{cat.id}"
        if query.empty?
          query = hashcat
        elsif !query.include?(hashcat)
          query += " #{hashcat}"
        end
        arr << link_to_function(cat.long_name, "crm.search_categorized('#{query}', '#{model.class.to_s.tableize}')", :title => cat.description)
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
      select_tag 'filter_category', options_for_select(nested_set_options(get_cats_for_model) {|i| "#{'-' * i.level} #{i.name}" }.insert(0, '') ), { :style => "width:180px", :onchange => "crm.search_categorized(crm.get_category_filter(), '#{self.controller_name.to_s}')" }
    end
  
    # Get categories orderer by long_name for the current model
    #----------------------------------------------------------------------------
    def get_cats_for_model
      model = self.controller_name.singularize.camelize
      Cat.find_for_model(model).sort! { |a,b| a.long_name <=> b.long_name }
    end
    
    def get_cats_colletion_select
      #require 'ruby-debug';debugger
      model = self.controller_name.singularize
      collection_select model, :cat_ids, get_cats_for_model, :id, :long_name, { }, { :multiple => true, :size => '10', :style => "width:240px" }
    end
    
  end
end

ActionView::Base.send(:include, CrmCats::ViewHelpers)
