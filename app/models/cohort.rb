class Cohort < ActiveRecord::Base
  attr_accessible :c_id, :cohort_name, :location

  set_primary_key :c_id

  has_many :users
end