# Install hook code here
puts <<-EOS
Categorization plugin for Fat Free CRM
 
Adds categorization support to all major Fat Free CRM models.
 
The Tags plugin depends on [awesome_nested_set] plugin which must be installed as follows:

  $ cd [crm_path_on_your_system] 
  $ ruby script/plugin install git://github.com/collectiveidea/awesome_nested_set.git
  $ cd vendor/plugins; git clone git://github.com/tractis/crm_cats.git
  $ ruby script/generate crm_cats_migration
  $ rake db:migrate
 
Copyright (c) 2010 by Tractis (https://www.tractis.com), released under the MIT License

EOS
