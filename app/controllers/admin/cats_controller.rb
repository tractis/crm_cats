class Admin::CatsController < Admin::ApplicationController
  before_filter :set_current_tab
  before_filter :auto_complete, :only => :auto_complete
  before_filter :set_default_type

  # GET /admin/cats
  # GET /admin/cats.xml                                                   HTML
  #----------------------------------------------------------------------------
  def index
    @cats = get_cats
    
    respond_to do |format|
      format.html # index.html.haml
      format.js   # index.js.rjs
      format.xml  { render :xml => @cats }
    end
  end

  # GET /admin/cats/1
  # GET /admin/cats/1.xml
  #----------------------------------------------------------------------------
  def show
    @cat = Cat.find(params[:id])

    respond_to do |format|
      format.html # show.html.haml
      format.xml  { render :xml => @cat }
    end
  end

  # GET /admin/cats/new
  # GET /admin/cats/new.xml                                               AJAX
  #----------------------------------------------------------------------------
  def new
    @cat = Cat.new(:cat_type => session[:cat_type])
    
    respond_to do |format|
      format.js   # new.js.rjs
      format.xml  { render :xml => @cat }
    end
  end

  # GET /admin/cats/add_child
  # GET /admin/cats/add_child.xml                                         AJAX
  #----------------------------------------------------------------------------
  def add_child    
    @cat = Cat.new(:cat_type => session[:cat_type], :parent_id => params[:id])
    @parent = Cat.find(params[:id])
    
    respond_to do |format|
      format.js   # new.js.rjs
      format.xml  { render :xml => @cat }
    end
  end

  # GET /admin/cats/1/edit                                                AJAX
  #----------------------------------------------------------------------------
  def edit
    @cat = Cat.find(params[:id])

    if params[:previous] =~ /(\d+)\z/
      @previous = Cat.find($1)
    end

  rescue ActiveRecord::RecordNotFound
    @previous ||= $1.to_i
    respond_to_not_found(:js) unless @cat
  end

  # POST /admin/cats
  # POST /admin/cats.xml                                                  AJAX
  #----------------------------------------------------------------------------
  def create
    @cat = Cat.new(params[:cat])
    
    respond_to do |format|
      if @cat.save
        if ! @cat.parent_id.nil?
          parent = Cat.find(@cat.parent_id)
          @cat.move_to_child_of(parent)
        end
        @cats = Cat.find(:all)
        format.js   # create.js.rjs
        format.xml  { render :xml => @cat, :status => :created, :location => @cat }
      else
        format.js   # create.js.rjs
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/cats/1
  # PUT /admin/cats/1.xml                                                 AJAX
  #----------------------------------------------------------------------------
  def update
    @cat = Cat.find(params[:id])

    respond_to do |format|
      if @cat.update_attributes(params[:cat])
        format.js   # update.js.rjs
        format.xml  { head :ok }
      else
        format.js   # update.js.rjs
        format.xml  { render :xml => @cat.errors, :status => :unprocessable_entity }
      end
    end

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end

  # GET /admin/cats/1/confirm                                             AJAX
  #----------------------------------------------------------------------------
  def confirm
    @cat = Cat.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:js, :xml)
  end
  
  # GET /admin/cats/1/changetype                                           AJAX
  #----------------------------------------------------------------------------
  def changetype
    session[:cat_type] = params[:id]
    
    respond_to do |format|
          format.html { redirect_to :action => "index" }
    end    
  end

  # DELETE /admin/cats/1
  # DELETE /admin/cats/1.xml                                              AJAX
  #----------------------------------------------------------------------------
  def destroy
    @cat = Cat.find(params[:id])

    respond_to do |format|
      if @cat.destroy
        format.js   # destroy.js.rjs
        format.xml  { head :ok }
      else
        flash[:warning] = t(:msg_cant_delete_cat, @cat.name)
        format.js   # destroy.js.rjs
        format.xml  { render :xml => @cat.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  #----------------------------------------------------------------------------
  def get_cats
    current_type = session[:cat_type] if session[:cat_type]

    Cat.find(:all, :conditions => [ "cat_type = ?", current_type ]).sort! { |a,b| a.long_name <=> b.long_name }

  end
  
  def set_default_type
    session[:cat_type] = 'Account' if session[:cat_type].nil?
  end
  
end