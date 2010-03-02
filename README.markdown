Categorization plugin for Fat Free CRM
============

Adds categorization support to all major Fat Free CRM models. Implements an admin module to manage the nested cats and are shown in models that have as least one category.
 
The Cats plugin depends on [awesome_nested_set] plugin.

Installation
============

The plugin can be installed by running:

    script/plugin install git://github.com/collectiveidea/awesome_nested_set.git
    script/plugin install git://github.com/tractis/crm_cats.git

Then run the following command:

    rake db:migrate:plugin NAME=crm_cats

Then restart your web server.

Copyright (c) 2010 by Tractis (https://www.tractis.com), released under the MIT License