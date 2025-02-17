class Facility
  attr_reader :name,
              :address,
              :phone,
              :services,
              :registered_vehicles,
              :collected_fees

  def initialize(facility_details)
    @name = facility_details[:name]
    @address = facility_details[:address]
    @phone = facility_details[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service)
    @services << service
  end

  def determine_plate_type(vehicle)
    if vehicle.electric_vehicle?
      :ev
    elsif vehicle.antique?
      :antique
    else
      :regular
    end
  end

  def determine_fees(vehicle)
    if determine_plate_type(vehicle) == :regular
      100
    elsif determine_plate_type(vehicle) == :ev
      200
    else
      25
    end
  end

  def register_vehicle(vehicle)
    return unless @services.include?("Vehicle Registration")

    vehicle.registration_date = Date.new
    vehicle.plate_type = determine_plate_type(vehicle)
    @collected_fees += determine_fees(vehicle)
    @registered_vehicles << vehicle
  end

  def administer_written_test(registrant)
    return false unless @services.include?("Written Test") && registrant.permit? == true && registrant.age >= 16

    registrant.license_data[:written] = true
  end

  def administer_road_test(registrant)
    return false unless @services.include?("Road Test") && registrant.license_data[:written] == true

    registrant.license_data[:license] = true
  end

  def renew_drivers_license(registrant)
    return false unless @services.include?("Renew License") && registrant.license_data[:license] == true

    registrant.license_data[:renewed] = true
  end
end
