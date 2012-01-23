class ExportGenerator
  class Export
    attr_accessor :data, :options
    def initialize data, options
      @data = data
      @options = options
    end
  end
  def initialize data, filename
    @data = data.flatten
    @filename =filename
  end

  def to_csv
    csv_data = FasterCSV.generate do |rows|
      rows << ["Name", "Last Name", "Email","Type of attendee", "One line abstract", "Phone number", "Mode of reach", "Registered on"]
      @data.each do |registration|
        registration_data = [registration.name, registration.last_name, registration.email, registration.type_of_attendee,
                             registration.one_line_abstract, registration.phone_no, registration.mode_of_reach, registration.created_at]
        rows << registration_data
      end
    end

    return Export.new csv_data, {:type=>'text/csv', :filename=>@filename}
  end
end