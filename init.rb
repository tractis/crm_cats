require "fat_free_crm"

FatFreeCRM::Plugin.register(:crm_cats, initializer) do
          name "Fat Free CRM Cats"
       authors "Tractis - Jose Luis Gordo Romero, based on crm_tags code from Michael Dvorkin"
       version "0.1"
   description "Adds categorization support to Fat Free CRM"
  dependencies :"awesome_nested_set", :haml, :simple_column_search, :will_paginate
           tab :admin do |tabs|
             tabs.insert(1, { :text => "cats", :url => { :controller => "cats" } })
           end  
end

require "crm_cats"
