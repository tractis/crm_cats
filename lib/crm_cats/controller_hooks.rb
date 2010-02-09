class ControllerHooks < FatFreeCRM::Callback::Base

  # :get_accounts and :get_contacts hooks that don't have filters.
  #----------------------------------------------------------------------------
  [ Account, Contact ].each do |klass|
    define_method :"get_#{klass.to_s.tableize}" do |controller, context|
      params, search_string = controller.params, controller.send(:current_query)
      query, cats = parse_query_and_cats(search_string)

      if query.blank?                                                   # No search query...
        if cats.blank?                                                  # No search query, no cats.
          klass.my(context[:records])
        else                                                            # No search query, with cats.
          klass.my(context[:records]).categorized_with(cats, :on => klass.to_s.downcase.singularize)
        end
      else                                                              # With search query...
        if cats.blank?                                                  # With search query, no cats.
          klass.my(context[:records]).search(query)
        else                                                            # With search query, with cats.
          klass.my(context[:records]).search(query).categorized_with(cats, :on => klass.to_s.downcase.singularize)
        end
      end.paginate(context[:pages])
    end # define_method
  end # each

  # :get_campaigns, :get_leads, and :get_opportunities hooks that have filters.
  #----------------------------------------------------------------------------
  [ Campaign, Lead, Opportunity ].each do |klass|
    define_method :"get_#{klass.to_s.tableize}" do |controller, context|
      session, params, search_string = controller.session, controller.params, controller.send(:current_query)
      query, cats = parse_query_and_cats(search_string)
      filter = :"filter_by_#{klass.to_s.downcase.singularize}_status"

      if session[filter]                                                # With filters...
        filtered = session[filter].split(",")
        if cats.blank?                                                  # With filters, no cats...
          if query.blank?                                               # With filters, no cats, no search query.
            klass.my(context[:records]).only(filtered)
          else                                                          # With filters, no cats, with search query.
            klass.my(context[:records]).only(filtered).search(query)
          end
        else                                                            # With filters, with cats...
          if query.blank?                                               # With filters, with cats, no search query.
            klass.my(context[:records]).only(filtered)..categorized_with(cats, :on => klass.to_s.downcase.singularize)
          else                                                          # With filters, with cats, with search query.
            klass.my(context[:records]).only(filtered).search(query).categorized_with(cats, :on => klass.to_s.downcase.singularize)
          end
        end
      else                                                              # No filters...
        if cats.blank?                                                  # No filters, no cats...
          if query.blank?                                               # No filters, no cats, no search query.
            klass.my(context[:records])
          else                                                          # No filters, no cats, with search query.
            klass.my(context[:records]).search(query)
          end
        else                                                            # No filters, with cats...  
          if query.blank?                                               # No filters, with cats, no search query.
            klass.my(context[:records]).categorized_with(cats, :on => klass.to_s.downcase.singularize)
          else                                                          # No filters, with cats, with search query.
            klass.my(context[:records]).search(query).categorized_with(cats, :on => klass.to_s.downcase.singularize)
          end
        end
      end.paginate(context[:pages])   
    end # define_method
  end # each

  # Auto complete hook that gets called from application_controller.rb.
  #----------------------------------------------------------------------------
  def auto_complete(controller, context = {})
    query, cats = parse_query_and_cats(context[:query])
    klass = controller.controller_name.classify.constantize
    if cats.empty?
      klass.my(:user => context[:user], :limit => 10).search(query)
    else
      klass.my(:user => context[:user], :limit => 10).search(query).categorized_with(cats, :on => klass.to_s.downcase.singularize)
    end
  end

  private
  # Somewhat simplistic parser that extracts query and hash-prefixed tags from
  # the search string and returns them as two element array, for example:
  #
  # "$real Billy Bones $id" => [ "Billy Bones", "real, pirate" ]
  #----------------------------------------------------------------------------
  def parse_query_and_cats(search_string)
    query, cats = [], []
    
    search_string.scan(/[\w$]+/).each do |token|
      if token.starts_with?("$")
        cats << token[1 .. -1]
      else
        query << token
      end
    end
    [ query.join(" "), cats.join(", ") ]
  end

end
