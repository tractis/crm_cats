module Admin::CatsHelper

  #----------------------------------------------------------------------------
  def link_to_confirm(cat)
    link_to_remote(t(:delete) + "?", :method => :get, :url => confirm_admin_cat_path(cat))
  end

  #----------------------------------------------------------------------------
  def link_to_delete(cat)
    link_to_remote(t(:yes_button), 
      :method => :delete,
      :url => admin_cat_path(cat),
      :before => visual_effect(:highlight, dom_id(cat), :startcolor => "#ffe4e1")
    )
  end
  
  #----------------------------------------------------------------------------
  def link_to_add_child(cat)
    link_to_remote(t(:add_cat_child), :method => :get, :url => add_child_admin_cat_path(cat))
  end
  
end