class Node < ActiveRecord::Base
  has_many :posts 
  belongs_to :section
end
