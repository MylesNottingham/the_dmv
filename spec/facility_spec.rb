require "spec_helper"

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new(
      {
        name: "Albany DMV Office",
        address: "2242 Santiam Hwy SE Albany OR 97321",
        phone: "541-967-2014"
      }
    )
    @facility_2 = Facility.new(
      {
        name: "Ashland DMV Office",
        address: "600 Tolman Creek Rd Ashland OR 97520",
        phone: "541-776-6092"
      }
    )
    @cruz = Vehicle.new({ vin: "123456789abcdefgh", year: 2012, make: "Chevrolet", model: "Cruz", engine: :ice })
    @bolt = Vehicle.new({ vin: "987654321abcdefgh", year: 2019, make: "Chevrolet", model: "Bolt", engine: :ev })
    @camaro = Vehicle.new({ vin: "1a2b3c4d5e6f", year: 1969, make: "Chevrolet", model: "Camaro", engine: :ice })
  end

  describe "#initialize" do
    it "can initialize" do
      expect(@facility_1).to be_an_instance_of(Facility)
      expect(@facility_1.name).to eq("Albany DMV Office")
      expect(@facility_1.address).to eq("2242 Santiam Hwy SE Albany OR 97321")
      expect(@facility_1.phone).to eq("541-967-2014")
      expect(@facility_1.services).to eq([])
    end
  end

  describe "#add_service" do
    it "can add available services" do
      expect(@facility_1.services).to eq([])
      @facility_1.add_service("New Drivers License")
      @facility_1.add_service("Renew Drivers License")
      @facility_1.add_service("Vehicle Registration")
      expect(@facility_1.services).to eq(["New Drivers License", "Renew Drivers License", "Vehicle Registration"])
    end
  end

  describe "#determine_fees" do
    it "can determine registration fees" do
      expect(@facility_1.determine_fees(@cruz)).to eq(100)
      expect(@facility_1.determine_fees(@bolt)).to eq(200)
      expect(@facility_1.determine_fees(@camaro)).to eq(25)
    end
  end

  describe "#register_vehicle" do
    it "can register vehicles" do
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_1.collected_fees).to eq(0)

      expect(@cruz.registration_date).to eq(nil)

      expect(@facility_1.add_service("Vehicle Registration")).to eq(["Vehicle Registration"])

      expect(@facility_1.register_vehicle(@cruz)).to eq([@cruz])
      expect(@cruz.registration_date).to eq(Date.new)
      expect(@cruz.plate_type).to eq(:regular)

      expect(@facility_1.registered_vehicles).to eq([@cruz])
      expect(@facility_1.collected_fees).to eq(100)

      expect(@facility_1.register_vehicle(@camaro)).to eq([@cruz, @camaro])
      expect(@camaro.registration_date).to eq(Date.new)
      expect(@camaro.plate_type).to eq(:antique)

      expect(@facility_1.register_vehicle(@bolt)).to eq([@cruz, @camaro, @bolt])
      expect(@bolt.registration_date).to eq(Date.new)
      expect(@bolt.plate_type).to eq(:ev)

      expect(@facility_1.registered_vehicles).to eq([@cruz, @camaro, @bolt])
      expect(@facility_1.collected_fees).to eq(325)
    end

    it "will not register vehicles if the service is not offered" do
      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.services).to eq([])

      expect(@facility_2.register_vehicle(@bolt)).to eq(nil)

      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.collected_fees).to eq(0)
    end
  end
end
