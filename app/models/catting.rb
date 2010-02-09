class Catting < ActiveRecord::Base
  belongs_to :account
  belongs_to :contact
  belongs_to :lead
  belongs_to :opportunity
  belongs_to :campaign
  belongs_to :cat
end
