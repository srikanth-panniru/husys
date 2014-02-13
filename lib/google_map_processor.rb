class GoogleMapProcessor
  def self.build_map_data(centers)
    Gmaps4rails.build_markers(centers) do |center, marker|
      marker.lat center.latitude
      marker.lng center.longitude
      marker.infowindow "#{center.id}: #{center.full_address_html}"
    end
  end
end