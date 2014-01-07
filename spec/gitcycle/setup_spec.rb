require File.expand_path("../../spec_helper", __FILE__)

describe Gitcycle::Setup do
  
  let(:setup) do
    Gitcycle::Config.config_path = config_fixture_path
    Gitcycle::Config.read
    Gitcycle::Setup.new
  end

  %w(lighthouse token url).each do |property|
    describe "##{property}" do
      
      it "should save to config", :capture do
        if property == 'lighthouse'
          Gitcycle::Api.should_receive(:setup_lighthouse).with(property)
        end

        setup.send property, property
        $stdout.string.should include("Configuration saved.")
        config_fixture[property.to_sym].should == property
      end
    end
  end
end