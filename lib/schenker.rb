require "schenker/version"

class Schenker
	attr_accessor :postcode, :delivery_point_ids, :delivery_points

	def self.get_delivery_point_ids_by_postcode(postcode)
		postcode.strip!
		validate!(postcode)

		file = File.read(File.dirname(__FILE__) + "/data/postnumbers20110401.txt")
		matches = file.split("\n").select { |l| l.match(/^#{postcode}(?!9999)\d{4}/) }
		delivery_point_ids = matches.map { |match| match[5..8] }

		if delivery_point_ids.empty?
			raise InvalidZipcode, "Couldn't find this zipcode. Please double check it's correct."
		else
			delivery_point_ids
		end
	end

	def self.get_delivery_points_by_postcode(postcode)
		postcode.strip!
		validate!(postcode)

		matches = get_raw_delivery_point_lines(get_delivery_point_ids_by_postcode(postcode))

		delivery_points = []

		matches.each do |l|
				pos = 0

				# Record length	200
				# Field		Pos		Description
				# Term		3		'001'
				term = l.slice(pos, 3)
				pos += 3

				# C.point	4		Collection point number			
				cpoint = l.slice(pos, 4)
				pos += 4

				# Name		30		Collection point name			
				name = l.slice(pos, 30).rstrip
				pos += 30

				# Address 1	30		Collection point address
				address1 = l.slice(pos, 30).rstrip
				pos += 30

				# Address 2 30		N/A
				pos += 30

				# P.number	5		Post number
				postcode = l.slice(pos, 5)
				pos += 5

				# City		20		City			
				city = l.slice(pos, 20).rstrip
				pos += 20

				# Phone		15		Collection point phone number
				phone = l.slice(pos, 15).rstrip
				pos += 15

				# Open		30		Opening hours
				open = l.slice(pos, 30).rstrip
				# pos += 30

				# Contacts	30		N/A
				# pos += 30

				# Filler	1		Blank
				# pos += 1

				# Co.code	2		’FI’
				# pos += 2

				delivery_points << {
					name: name,
					cpoint: cpoint,
					address1: address1,
					postcode: postcode,
					city: city,
					phone: phone,
					open: open
				}						
		end

		delivery_points

	end

	def self.get_raw_delivery_point_lines(delivery_point_ids)
		file = File.read(File.dirname(__FILE__) + "/data/cpfile20110401.txt")
		file.split("\r\n").select { |l| delivery_point_ids.include?(l[3..6]) }
	end

	
		def self.validate!(postcode)
			raise InvalidZipcode, "Post codes are should be digits only" unless postcode.match(/^\d*$/)
			raise InvalidZipcode, "Post codes has length of 5. Your is shorter." if postcode.length < 5
			raise InvalidZipcode, "Post codes has length of 5. Your is longer." if postcode.length > 5
		end

		class InvalidZipcode < StandardError; end
end
