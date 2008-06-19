require File.dirname(__FILE__) + '/../spec_helper'

class Event < ActiveRecord::Base
  
end

describe HappySeo do
  before(:each) do
    event = mock_model(Event, {:id => 1, 
      :name         => 'Ohio State vs Wisconsin', 
      :city_name    => 'Columbus', 
      :tags         => 'fun, football, horsehoe', 
      :description  => 'Ohio State looks to extend their winning streak'})
    @happy_seo = HappySeo.new(event)
  end
  
  it "should generate an optimized seo_id in the form of id-name by default" do
    @happy_seo.seo_id.should eql('1-ohio-state-vs-wisconsin')
  end
  
  it "should generate an optimized seo_id in the form of id-city_name-name when custom attributes are applied" do
    @happy_seo.seo_id( [:id, :city_name, :name] ).should eql('1-columbus-ohio-state-vs-wisconsin')
  end
  
  it "should generate keywords string based on name, description, tags by default" do
    @happy_seo.meta_keywords.should eql('Ohio State vs Wisconsin, Ohio State looks to extend their winning streak, fun, football, horsehoe')
  end
  
  it "should generate keywords string based on name, city_name, tags when custom attributes are applied" do
    @happy_seo.meta_keywords( [:name, :city_name, :tags] ).should eql('Ohio State vs Wisconsin, Columbus, fun, football, horsehoe')
  end
  
  it "should generate description string based on name, description, tags by default" do
    @happy_seo.meta_description.should eql('Ohio State vs Wisconsin. Ohio State looks to extend their winning streak. fun, football, horsehoe')
  end
  
  it "should generate description string based on name, description, city_name by default" do
    @happy_seo.meta_description( [:name, :description, :city_name] ).should eql('Ohio State vs Wisconsin. Ohio State looks to extend their winning streak. Columbus')
  end
  
  it "should be able to update the default seo_id attributes" do
    HappySeo.default_seo_id_attributes = [ :name ]
    @happy_seo.seo_id.should eql('ohio-state-vs-wisconsin')
  end
  
  it "should be able to update the default meta_keyword attributes" do
    HappySeo.default_meta_keywords_attributes = [ :name ]
    @happy_seo.meta_keywords.should eql('Ohio State vs Wisconsin')
  end
  
  it "should be able to update the default meta_description attributes" do
    HappySeo.default_meta_description_attributes = [ :name ]
    @happy_seo.meta_description.should eql('Ohio State vs Wisconsin')
  end
end

describe "clean_string" do
  before(:each) do
    event = mock_model(Event, {:id => 1, :name => 'Ohio State vs Wisconsin'})
    @happy_seo = HappySeo.new(event)
  end
  
  it "should downcase the input" do
    @happy_seo.send(:clean_string, 'hAPpy').should eql('happy')
  end
  
  it "should remove illegal characters" do
    @happy_seo.send(:clean_string, "h:[a\"p'p;y").should eql('happy')
  end
  
  it "should replace spaces with dashes" do
    @happy_seo.send(:clean_string, "happy seo").should eql('happy-seo')
  end
end
