class WallMessage < ActiveRecord::Base
  belongs_to :user 
  belongs_to :message, :polymorphic => true
end
