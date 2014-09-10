%w(base partner).each do |r|
  require_relative "./client/#{r}"
end

module Rsbe
  module Client
  end
end
