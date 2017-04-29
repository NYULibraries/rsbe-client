module Search
  def self.search(hsh = {})
    raise ArgumentError.new("These args must be present: #{hsh_valid_keys}") if hsh.empty?
    @hsh = hsh
    is_valid?
    @args = hsh[:params]
    @required_keys = hsh[:required_params]
    @scope = hsh[:scope]
    chk_search_args
    [@hsh,@args, @required_keys]
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

  private_class_method :chk_search_args, :compare_keys, :hsh_valid_keys, :is_valid?
end
