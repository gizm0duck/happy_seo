require File.dirname(__FILE__) + '/../spec_helper'

class Event < ActiveRecord::Base
  happy_seo
end

describe HappySeo do
  before(:each) do
    ActiveRecord::Schema.define do
      create_table :events, :force => true do |t|
        t.column :name,         :string
        t.column :city_name,    :string
        t.column :tags,         :string
        t.column :description,  :string
      end
    end
    
    @event = Event.create({:name => 'Ohio State vs Wisconsin', 
      :city_name    => 'Columbus', 
      :tags         => 'fun, football, horsehoe', 
      :description  => 'Ohio State looks to extend their winning streak'})    
  end
  
  after(:each) do
    Event.delete_all
  end
  
  it "should generate an optimized seo_id in the form of id-name by default" do
    @event.seo_id.should eql('1-ohio-state-vs-wisconsin')
  end
  
  it "should generate an optimized seo_id in the form of id-city_name-name when custom attributes are applied" do
    @event.seo_id( [:id, :city_name, :name] ).should eql('1-columbus-ohio-state-vs-wisconsin')
  end
  
  it "should generate keywords string based on name, description, tags by default" do
    @event.meta_keywords.should eql('Ohio State vs Wisconsin, Ohio State looks to extend their winning streak, fun, football, horsehoe')
  end
  
  it "should generate keywords string based on name, city_name, tags when custom attributes are applied" do
    @event.meta_keywords( [:name, :city_name, :tags] ).should eql('Ohio State vs Wisconsin, Columbus, fun, football, horsehoe')
  end
  
  it "should generate description string based on name, description, tags by default" do
    @event.meta_description.should eql('Ohio State vs Wisconsin. Ohio State looks to extend their winning streak. fun, football, horsehoe')
  end
  
  it "should generate description string based on name, description, city_name by default" do
    @event.meta_description( [:name, :description, :city_name] ).should eql('Ohio State vs Wisconsin. Ohio State looks to extend their winning streak. Columbus')
  end
  
  it "should be able to update the default seo_id attributes" do
    class << Event
      def default_seo_id_attributes
        [ :name ] 
      end
    end
    @event.seo_id.should eql('ohio-state-vs-wisconsin')
  end
  
  it "should be able to update the default meta_keyword attributes" do
    class << Event
      def default_meta_keywords_attributes
        [ :name ] 
      end
    end
    @event.meta_keywords.should eql('Ohio State vs Wisconsin')
  end
  
  it "should be able to update the default meta_description attributes" do
    class << Event
      def default_meta_description_attributes
        [ :name ] 
      end
    end
    @event.meta_description.should eql('Ohio State vs Wisconsin')
  end
end

describe "clean_string" do
  before(:each) do
    ActiveRecord::Schema.define do
      create_table :events, :force => true do |t|
        t.column :name,         :string
        t.column :city_name,    :string
        t.column :tags,         :string
        t.column :description,  :string
      end
    end
    
    @event = Event.create({:name => 'Ohio State vs Wisconsin', 
      :city_name    => 'Columbus', 
      :tags         => 'fun, football, horsehoe', 
      :description  => 'Ohio State looks to extend their winning streak'})
  end
  
  after(:each) do
    Event.delete_all
  end
  
  it "should downcase the input" do
    @event.send(:clean_string, 'hAPpy').should eql('happy')
  end
  
  it "should remove illegal characters" do
    @event.send(:clean_string, "h:[a\"p'p;y").should eql('happy')
  end
  
  it "should replace spaces with dashes" do
    @event.send(:clean_string, "happy seo").should eql('happy-seo')
  end
end
