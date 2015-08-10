%w(base partner collection connection not_found_error
method_not_implemented_error provider).each do |r|
  require_relative "./client/#{r}"
end

module Rsbe
  module Client
  end
end
