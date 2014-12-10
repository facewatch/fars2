class Fars2::CollectionSerializer
  def as_json
    items = []
    unless empty_array?
      @item_serializer ||= item_serializer_class.new(nil, options)
      objects.each do |object|
        items << item_serializer.call(object)
      end
    end
    return items unless root
    hash = { root => items }
    hash[:_metadata] = metadata if metadata
    hash
  end

  def to_json
    MultiJson.dump(as_json)
  end

private
  attr_reader :objects, :options, :root, :prefix, :params, :metadata, :item_serializer

  def initialize(objects, opts = {}, &block)
    @objects = objects
    if !opts.has_key?(:root) && !opts[:class_name] && empty_array?
      raise ArgumentError, 'Specify :root or object :class_name for empty array.'
    end
    # Cann't use Hash#fetch here, becouse if root provided default_root method should not be called.
    @root = opts.has_key?(:root) ? opts[:root] : default_root
    if !@root && opts[:metadata]
      raise ArgumentError, 'Can not omit :root if provided :metadata'
    end
    # Serialized model class name.
    @class_name = opts[:class_name]
    if opts[:serializer]
      if opts[:serializer].is_a? Proc
        @item_serializer = opts[:serializer]
      else
        @item_serializer_class = opts[:serializer].constantize
      end
    elsif block_given?
      @item_serializer = block
    end
    @prefix = opts[:prefix]
    @params = opts[:params]
    @metadata = opts[:metadata]
    # Do not need options if serialize items with proc.
    unless @item_serializer
      # Options for model serializer.
      @options = opts.slice(:scope, :fields, :add_metadata, :prefix, :params)
      @options[:root] = opts.fetch(:item_root, default_item_root)
    end
  end

  def empty_array?
    objects.is_a?(Array) && objects.empty?
  end

  def class_name
    @class_name ||= begin
      _class = if defined?(ActiveRecord::Relation) && objects.is_a?(ActiveRecord::Relation)
        objects.klass
      else
        objects.first.class
      end
      _class.respond_to?(:base_class) ? _class.base_class.name : _class.name
    end
  end

  def default_root
    class_name.to_s.underscore.pluralize.to_sym
  end

  def default_item_root
    root.to_s.singularize.to_sym if root
  end

  def item_serializer_class
    @item_serializer_class ||= "#{prefix + '::' if prefix}#{class_name}Serializer".constantize
  end
end
