class ViewHooks < FatFreeCRM::Callback::Base
  #= collection_select get_category_model, get_category_model_ids, all_categories, :id, :long_name, { }, { :multiple => true, :size => '10' }
  CATS_FIELD = <<EOS
%tr
  %td{ :valign => :top, :colspan => span }
    .label.req Cats: <small>(comma separated, letters and digits only)</small>
EOS

  CATS_FOR_INDEX = <<EOS
%dt
  .cats= cats_for_index(model)
EOS

  CATS_FOR_SHOW = <<EOS
.tags(style="margin:4px 0px 4px 0px")= cats_for_show(model)
EOS

  CATS_STYLES = <<EOS
.cats, .list li dt .cats
  a:link, a:visited
    :background lightsteelblue
    :color white
    :font-weight normal
    :padding 0px 6px 1px 6px
    :-moz-border-radius 8px
    :-webkit-border-radius 8px
  a:hover
    :background steelblue
    :color yellow
EOS

  CATS_JAVASCRIPT = <<EOS
crm.search_categorized = function(query, controller) {
  if ($('query')) {
    $('query').value = query;
  }
  crm.search(query, controller);
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
      unless context[model].cat_list.empty?
        Haml::Engine.new(CATS_FOR_INDEX).render(view, :model => context[model])
      end
    end

    define_method :"show_#{model}_sidebar_bottom" do |view, context|
      unless context[model].cat_list.empty?
        Haml::Engine.new(CATS_FOR_SHOW).render(view, :model => context[model])
      end
    end

  end

end
