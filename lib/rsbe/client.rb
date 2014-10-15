%w(base partner not_found_error).each do |r|
  require_relative "./client/#{r}"
end

module Rsbe
  module Client
  end
end
