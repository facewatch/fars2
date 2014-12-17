require "multi_json"
require "active_support"
require "fars2/version"
require "fars2/object_serializer"
require "fars2/collection_serializer"

module Fars2
  module ObjectSerializable
    def serialize(opts = {})
      prefix = opts[:prefix] + '::' if opts[:prefix]
      serializer_class = (opts[:serializer] || "#{prefix}#{self.class.name}Serializer").constantize
      serializer_class.new(self, opts).to_json
    end
  end

  module CollectionSerializable
    def serialize(opts = {}, &block)
      Fars2::CollectionSerializer.new(self, opts, &block).to_json
    end
  end
end

begin
  require 'active_record'

  class ActiveRecord::Base
    include Fars2::ObjectSerializable
  end

  class ActiveRecord::Relation
    include Fars2::CollectionSerializable
  end
rescue LoadError
end

begin
  require 'active_resource'

  class ActiveResource::Base
    include Fars2::ObjectSerializable
  end
rescue LoadError
end

class Array
  include Fars2::CollectionSerializable
end

class Hash
  include Fars2::CollectionSerializable
end

begin
  require 'sinatra/base'

  module Sinatra
    module SerializersHelper
      def serialize(object, options = {})
        object.serialize({ fields: params[:fields], scope: lambda { current_ability } }.merge(options))
      end
    end

    helpers SerializersHelper
  end
rescue LoadError
end
