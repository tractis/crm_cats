module CrmCats
  module ViewHelpers

    # Generate cat links for use on asset index pages.
    #----------------------------------------------------------------------------
    def cats_for_index(model)
      model.cat_list.inject([]) do |arr, tag|
        query = controller.send(:current_query) || ""
        hashcat = "@#{cat}"
        if query.empty?
          query = hashcat
        elsif !query.include?(hashcat)
          query += " #{hashcat}"
        end
        arr << link_to_function(cat, "crm.search_categorized('#{query}', '#{model.class.to_s.tableize}')", :title => cat)
      end.join(" ")
    end

    # Generate cat links for the asset landing page (shown on a sidebar).
    #----------------------------------------------------------------------------
    def cats_for_show(model)
      model.cat_list.inject([]) do |arr, tag|
        arr << link_to(tag, url_for(:action => "categorized", :id => cat), :title => cat)
      end.join(" ")
    end

  end
end

ActionView::Base.send(:include, CrmCats::ViewHelpers)
