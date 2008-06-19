module HappySeo
  module Base
    ILLEGAL_SEO_CHARS = /[\[\]\/;':",.?]/
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def happy_seo
        class << self
          define_method(:default_seo_id_attributes) do
            [ :id, :name ] 
          end unless respond_to?(:default_seo_id_attributes)  
          define_method(:default_meta_keywords_attributes) do
            [ :name, :description, :tags ] 
          end unless respond_to?(:default_meta_keywords_attributes)
          define_method(:default_meta_description_attributes) do 
            [ :name, :description, :tags ] 
          end unless respond_to?(:default_meta_description_attributes)
        end
        include HappySeo::Base::InstanceMethods
      end
    end
    
    module InstanceMethods
      def seo_id( attributes=self.class.default_seo_id_attributes )
        return_values = calculate_attributes( attributes ) { |return_values| clean_string( return_values.join(" ") ) }
      end

      def meta_keywords( attributes=self.class.default_meta_keywords_attributes )
        return_values = calculate_attributes( attributes ) { |return_values| return_values.join(", ") }
      end

      def meta_description( attributes=self.class.default_meta_description_attributes )
        return_values = calculate_attributes( attributes ) { |return_values| return_values.join(". ") }
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
