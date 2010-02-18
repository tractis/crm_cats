module CrmCats
  module ControllerActions

    # Controller instance method that responds to /controlled/categorized/cat request.
    # It stores given cat as current query and redirect to index to display all
    # records categorized with the cat.
    #----------------------------------------------------------------------------
    def categorized
      self.send(:current_query=, "$" << params[:id]) unless params[:id].blank?
      redirect_to :action => "index"
    end

  end
end

ApplicationController.send(:include, CrmCats::ControllerActions)
