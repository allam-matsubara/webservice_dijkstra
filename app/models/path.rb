class Path < ActiveRecord::Base
  # Validations
  validates :point_a, :point_b, :distance, :name, presence: true
end
