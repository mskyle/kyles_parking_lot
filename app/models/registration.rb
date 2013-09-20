class Registration < ActiveRecord::Base
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_format_of :email,
    with: /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  validates_numericality_of :spot_number,
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 60

  validates_uniqueness_of :spot_number,
    scope: :parked_on

  validates_presence_of :parked_on


  def park
    self.parked_on = Date.today
    save
  end

  def find_neighbors
    neighbor_spots = self.spot_number + 1, self.spot_number - 1
    neighbors = []
    neighbor_spots.each do |spot| 
      if Registration.where(spot_number: spot, parked_on: self.parked_on)
        neighbors << Registration.where(spot_number: spot, parked_on: self.parked_on)[0]
      end
    end
    neighbors.compact
  end

  def neighbor_message
    neighbor_strings = find_neighbors.map { |x| "#{x.first_name} #{x.last_name} in spot #{x.spot_number}" }
    if neighbor_strings.length > 1
      return "Your neighbors are " + neighbor_strings.join(" and ")
    elsif neighbor_strings.length == 1
      return "Your neighbor is " + neighbor_strings.join
    else
      return "You have no current neighbors."
    end
  end

  def history
    Registration.where(email: email).order("parked_on DESC")
  end

end
