class Cat < ActiveRecord::Base
  
  has_many :accounts,      :through => :cattings
  has_many :contacts,      :through => :cattings
  has_many :leads,         :through => :cattings
  has_many :opportunities, :through => :cattings
  has_many :campaigns,     :through => :cattings
  has_many :cattings
  
  acts_as_nested_set
  acts_as_paranoid

  named_scope :find_for_model, lambda { |model|
    { :conditions => { :cat_type => model } }
  }
  
  def self.root_nodes
    find(:all, :conditions => 'parent_id IS NULL')
  end

  def self.find_children(start_id = nil)
    start_id.to_i == 0 ? root_nodes : find(start_id).children
  end

  def self.get_all_childrens(start_id = nil)
    return root_nodes if start_id.to_i == 0
    childs = []
    find(start_id).child_ids.each do |child|
      childs << child
      find(child).child_ids.each do |child_of_child|
        childs << child_of_child
      end
    end
    childs
  end
  
  def leaf
    unknown? || children_count == 0
  end

  def to_json_with_leaf(options = {})
    self.to_json_without_leaf(options.merge(:methods => :leaf))
  end
  
  alias_method_chain :to_json, :leaf

  def ancestors_name
    if parent
      parent.ancestors_name + parent.name + '::'
    else
      ""
    end
  end
  
  def long_name
    ancestors_name + name
  end  
  
end