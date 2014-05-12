class Section < ActiveRecord::Base
  has_many :nodes , :dependent => :destroy
end
