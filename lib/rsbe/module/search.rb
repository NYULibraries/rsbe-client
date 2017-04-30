module Search
  def self.search(hsh = {})
    raise ArgumentError.new("These args must be present: #{hsh_valid_keys}") if hsh.empty?
    @hsh = hsh
    # check if search params are valid
    is_valid?
    @args = hsh[:params]
    # normalize keys if sent in string form
    normalize_keys
    @required_keys = hsh[:required_params]
    @scope = hsh[:scope]
    # check search args sent
    chk_search_args
    # build query url
    @search_url = query_search_url
    query
  end

  def self.query_search_url
    base_url = Rsbe::Client::Base.base_path
    query_hsh = parameterize_params
    search_url = "#{base_url}/#{search_url_fragment}?#{query_hsh}"
  end

  def self.query
    conn = Rsbe::Client::Connection.new
    @response = conn.get @search_url
  end

  def self.search_url_fragment
    "search"
  end

  def self.parameterize_params
    query_hsh = @args.merge({scope: @scope})
    arr = []
    query_hsh.each_pair { |q,v|
      arr << "#{q}=#{v}"
    }
    arr.join("&")
  end
  def self.normalize_keys
    @args.keys.each do |key|
      case key
      when String
        @args[(key.to_sym rescue key) || key] = @args.delete(key)
      end
    end
  end
  def self.chk_search_args
    incoming_keys = @args.keys.sort
    compare_keys(incoming_keys,@required_keys)
  end

  def self.compare_keys(incoming_keys,required_keys)
    compare_keys = incoming_keys - required_keys
    raise ArgumentError.new("Required params: #{required_keys}") unless
    compare_keys.empty?
  end

  def self.is_valid?
    incoming_keys = @hsh.keys.sort
    compare_keys(incoming_keys,hsh_valid_keys)
  end

  def self.hsh_valid_keys
    [:params, :required_params, :scope].sort
  end

  private_class_method :chk_search_args, :compare_keys, :hsh_valid_keys, :is_valid?, :normalize_keys, :query_search_url, :parameterize_params, :search_url_fragment, :query
end
