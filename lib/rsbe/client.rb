%w(base
partner
collection
provider
se
connection not_found_error
method_not_implemented_error
wrong_origin_error
unrecognized_resource_error).each do |r|
  require_relative "./client/#{r}"
end

module Rsbe
  module Client
    def self.find(url)
      assert_same_origin(url)
      find_and_instantiate(url)
    end

    def self.assert_same_origin(url)
      conn = Rsbe::Client::Connection.new
      unless conn.same_origin?(url)
        raise Rsbe::Client::WrongOriginError.new("incorrect origin: #{url}")
      end
    end
    private_class_method :assert_same_origin

    def self.find_and_instantiate(url)
      retval = nil
      [ 
        Rsbe::Client::Partner, 
        Rsbe::Client::Provider,
        Rsbe::Client::Collection, 
        Rsbe::Client::Se
      ].each do |klass|
        # UUID Regexp from http://stackoverflow.com/a/14166194
        m = /#{klass.base_path}\/(?<uuid>[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12})\z/i.match(url)
        next if m.nil?
        retval = klass.find(m['uuid'])
        break
      end
      raise Rsbe::Client::UnrecognizedResourceError.new("no matching resource found for #{url}") if retval.nil?
      retval
    end
    private_class_method :find_and_instantiate
  end
end
