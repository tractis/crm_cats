class ViewHooks < FatFreeCRM::Callback::Base
  #= collection_select get_category_model, get_category_model_ids, all_categories, :id, :long_name, { }, { :multiple => true, :size => '10' }
  #= collection_select :account, :cat_ids, Cat.find(:conditions => [ "cat_type = ?", "Account" ]).sort! { |a,b| a.long_name <=> b.long_name }, :id, :long_name, { }, { :multiple => true, :size => '10' }
  CATS_FIELD = <<EOS
%tr
  %td{ :valign => :top, :colspan => span }
    .label.req t(:cat_created_on)
    = get_cats_colletion_select
EOS

  CATS_FOR_INDEX = <<EOS
%dt
  .cats= cats_for_index(model)
EOS

  CATS_FOR_SHOW = <<EOS
.cats(style="margin:4px 0px 4px 0px")= cats_for_show(model)
EOS

  CATS_FOR_LANDING = <<EOS
.label.req t(:cat_filter_by)
.cats= cats_for_landing  
EOS

  CATS_STYLES = <<EOS
.cats, .list li dt .cats
  a:link, a:visited
    :background lightcoral
    :color white
    :font-weight normal
    :padding 0px 6px 1px 6px
    :-moz-border-radius 8px
    :-webkit-border-radius 8px
  a:hover
    :background coral
    :color yellow   
EOS

  CATS_JAVASCRIPT = <<EOS
crm.search_categorized = function(query, controller) {
  if ($('query')) {
    $('query').value = query;
  }
  crm.search(query, controller);
}

crm.get_category_filter = function() {
  query = document.getElementById("filter_category").value;
  if(query.length == 0)
  {
    return ""
  } else {
    return "$" + query
  }
}
EOS

  #----------------------------------------------------------------------------
  def inline_styles(view, context = {})
    Sass::Engine.new(CATS_STYLES).render
  end

  #----------------------------------------------------------------------------
  def javascript_epilogue(view, context = {})
    CATS_JAVASCRIPT
  end

  #----------------------------------------------------------------------------
  [ :account, :campaign, :contact, :lead, :opportunity ].each do |model|

    define_method :"#{model}_top_section_bottom" do |view, context|
      Haml::Engine.new(CATS_FIELD).render(view, :f => context[:f], :span => (model != :campaign ? 3 : 5))
    end

    define_method :"#{model}_bottom" do |view, context|
      unless context[model].cattings.empty?
        Haml::Engine.new(CATS_FOR_INDEX).render(view, :model => context[model])
      end
    end

    define_method :"show_#{model}_sidebar_bottom" do |view, context|
      unless context[model].cattings.empty?
        Haml::Engine.new(CATS_FOR_SHOW).render(view, :model => context[model])
      end
    end
    
    define_method :"index_#{model}_sidebar_bottom" do |view, context|
      unless Cat.find_for_model(model.to_s.camelize).empty?
        Haml::Engine.new(CATS_FOR_LANDING).render(view, :model => context[model])
      end
    end

  end

end
