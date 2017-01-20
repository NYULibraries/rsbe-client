%w(base
partner
collection
provider
se
connection not_found_error
method_not_implemented_error
wrong_origin_error).each do |r|
  require_relative "./client/#{r}"
end

module Rsbe
  module Client
    def self.find(url)
      assert_same_origin(url)
    end

    def self.assert_same_origin(url)
      conn = Rsbe::Client::Connection.new
      unless conn.same_origin?(url)
        raise Rsbe::Client::WrongOriginError.new("incorrect origin: #{url}")
      end
    end
    private_class_method :assert_same_origin
  end
end
