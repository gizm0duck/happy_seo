module HappySeo
  module Base
    ILLEGAL_SEO_CHARS = /[\[\]\/;':",.?]/
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def happy_seo
        class << self
          define_method(:seo_id_attributes) do
            [ :id, :name ]
          end unless respond_to?(:seo_id_attributes)
          define_method(:meta_keywords_attributes) do
            [ :name, :description, :tags ]
          end unless respond_to?(:meta_keywords_attributes)
          define_method(:meta_description_attributes) do
            [ :description ]
          end unless respond_to?(:meta_description_attributes)
        end
        include HappySeo::Base::InstanceMethods
      end
    end
    
    module InstanceMethods
      def seo_id( attributes=self.class.seo_id_attributes )
        calculate_attributes( attributes ) { |return_values| clean_string( return_values.join(" ") ) }
      end

      def meta_keywords( attributes=self.class.meta_keywords_attributes )
        calculate_attributes( attributes ) { |return_values| return_values.join(", ") }
      end

      def meta_description( attributes=self.class.meta_description_attributes )
        str = calculate_attributes( attributes ) { |return_values| return_values.join(". ") }
        str.split[0..29].join(" ") + (str.split.size > 30 ? "..." : "")
      end
      
      def to_param
        seo_id
      end

      private

        # Take an array of attributes and build up array of values based on them.
        # Yields to a given block so they can be formatted in different ways
        def calculate_attributes( attributes )
          return_values = attributes.collect{ |attr| self.send( attr ) }
          return_values = yield( return_values ) if block_given?
          return return_values
        end

        # Removes illegal characters, converts to downcase, and inserts - between every word
        def clean_string( input )
          return input.downcase.gsub( HappySeo::Base::ILLEGAL_SEO_CHARS, '' ).gsub( ' ', '-' )
        end
    end
  end
end


ActiveRecord::Base.class_eval do
  include HappySeo::Base
end
