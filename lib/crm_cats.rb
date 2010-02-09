require "crm_cats/models"               # Inject "acts_as_taggable" to core models.
require "crm_cats/controller_actions"   # Inject :tagged controller instance method.
require "crm_cats/view_helpers"         # Inject tag formatting helpers.
require "crm_cats/controller_hooks"     # Define controller hooks to be able to search assets by tag.
require "crm_cats/view_hooks"           # Define view hooks that provide tag support in views.

ActionView::Base.send(:include, Admin::CatsHelper)
