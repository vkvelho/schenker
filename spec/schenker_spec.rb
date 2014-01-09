require 'spec_helper.rb'

describe Schenker do
	context "using valid and precise zipcode" do
		subject { described_class }

		it "finds the delivery point id by zipcode" do
			delivery_point_ids = subject.get_delivery_point_ids_by_postcode("81350")
			delivery_point_ids.should be_a_kind_of Array
			delivery_point_ids.first.should == "7037"
			delivery_point_ids.length.should == 1
		end

		it "finds the delivery point by zipcode" do
			delivery_points = subject.get_delivery_points_by_postcode("81350")
			delivery_points.should be_a_kind_of Array
			delivery_points.first.should have_key(:name)
			delivery_points.first[:name].should == "R-KIOSKI ILOMANTSI"
		end

		it "finds more than one delivery point for bigger city" do
			delivery_points = subject.get_delivery_points_by_postcode("00100")
			delivery_points.length.should > 1
		end

		it "doesn't get the delivery points of 9999" do
			delivery_points = subject.get_delivery_points_by_postcode("00100")
			delivery_points.last[:cpoint].should_not == '9999'
		end
	end

	context "using unexisted but otherwise valid zipcode" do
		subject { described_class }

		it "raises an error if zipcode can't be found" do
			expect {
				delivery_point_ids = subject.get_delivery_point_ids_by_postcode("12345")
			}.to raise_error(
				Schenker::InvalidZipcode, /Couldn't find this zipcode/
			)
		end
	end

	context "using invalid zipcode" do
		subject { described_class }

		it "raises an InvalidZipcode error if zipcode wasn't valid" do
			expect {
				subject.get_delivery_points_by_postcode("en muista")
			}.to raise_error(
				Schenker::InvalidZipcode, /digits only/
			)

			expect {
				subject.get_delivery_points_by_postcode("8135")
			}.to raise_error(
				Schenker::InvalidZipcode, /shorter/
			)

			expect {
				subject.get_delivery_points_by_postcode("813500")
			}.to raise_error(
				Schenker::InvalidZipcode, /longer/
			)
		end

		it "strips out all kinds of leading/trailing whitespaces" do
			delivery_point_ids = []
			expect {
				delivery_point_ids = subject.get_delivery_points_by_postcode(" 81350\n\r\t ")
			}.not_to raise_error
			
			delivery_point_ids.length.should_not == 0
		end
	end
end