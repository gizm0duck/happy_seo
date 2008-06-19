# Developer: Shane Wolf
# Michel Geary License: Free Beer and Free Speach
# This is a simple class to take attributes of a model and create SEO components out of them
# Curently supported: 
#   seo_id: for using in a to_param call
#   meta_keywords: use to build up the meta keywords tag for search engine optimization on pages where you don't want to explicitly set it
#   meta_description: use to build up the meta description tag for search engine optimization on pages where you don't want to explicitly set it
# TODO: add site maps.  This will create simple sitemaps of specified models and write them to a file for search engine optimization
class HappySeo
    ILLEGAL_CHARS = /[\[\]\/;':",.?]/
  @@default_seo_id_attributes             = [ :id, :name ]
  @@default_meta_keywords_attributes      = [ :name, :description, :tags ]
  @@default_meta_description_attributes   = [ :name, :description, :tags ]

  cattr_accessor :default_seo_id_attributes, :default_meta_keywords_attributes, :default_meta_description_attributes

  def initialize( obj )
    @obj = obj
  end

  def seo_id( attributes=@@default_seo_id_attributes )
    return_values = calculate_attributes( attributes ) { |return_values| clean_string( return_values.join(" ") ) }
  end

  def meta_keywords( attributes=@@default_meta_keywords_attributes )
    return_values = calculate_attributes( attributes ) { |return_values| return_values.join(", ") }
  end

  def meta_description( attributes=@@default_meta_description_attributes )
    return_values = calculate_attributes( attributes ) { |return_values| return_values.join(". ") }
  end

  private

    # Take an array of attributes and build up array of values based on them.
    # Yields to a given block so they can be formatted in different ways
    def calculate_attributes( attributes )
      return_values = attributes.collect{ |attr| @obj.send( attr ) }
      return_values = yield( return_values ) if block_given?
      return return_values
    end

    # Removes illegal characters, converts to downcase, and inserts - between every word
    def clean_string( input )
      return input.downcase.gsub( ILLEGAL_CHARS, '' ).gsub( ' ', '-' )
    end
end