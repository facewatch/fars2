class Fars2::ObjectSerializer
  class << self
    def attributes(*attrs)
      @attributes = attrs.map(&:to_sym)
    end

    def all_attributes
      @attributes
    end

    def root
      @root ||= self.name.sub(/Serializer$/, '').gsub(/^.*::/, '').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    end
    attr_writer :root

    def serializer_methods
      @serializer_methods ||= self.instance_methods & all_attributes
    end

    def primary_key
      @primary_key ||= :id
    end
    attr_writer :primary_key
  end

  def with_object(object)
    @object = object
    self
  end

  def as_json
    # NOTE: filtering by available attributes can be different for each object.
    all_attrs = available_attributes
    item = {}
    (all_attrs & requested_object_methods).each do |m|
      item[m] = @object.public_send(m)
    end
    (all_attrs & requested_serializer_methods).each do |m|
      item[m] = self.public_send(m)
    end
    return item unless @root
    hash = { @root => item }
    hash[:_metadata] = meta if @add_metadata
    hash
  end

  def to_json
    MultiJson.dump(as_json)
  end

  def call(obj)
    with_object(obj).as_json
  end

private
  attr_reader :object, :params, :fields

  def initialize(object, opts = {})
    @object = object
    @scope = opts[:scope]
    @fields = opts[:fields] ? (Array(opts[:fields]).map(&:to_sym) | [self.class.primary_key]) : self.class.all_attributes
    @add_metadata = opts.fetch(:add_metadata, self.respond_to?(:meta))
    @root = opts.fetch(:root, self.class.root)
    @params = opts[:params]
  end

  def scope
    if @scope.is_a? Proc
      @scope = @scope.call
    else
      @scope
    end
  end

  def requested_object_methods
    @requested_object_methods ||= @fields - requested_serializer_methods
  end

  def requested_serializer_methods
    @requested_serializer_methods ||= self.class.serializer_methods & @fields
  end

  def available_attributes
    self.class.all_attributes
  end
end
