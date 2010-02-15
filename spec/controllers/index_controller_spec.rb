require 'spec_helper'

describe IndexController do

  describe "#index" do
    it "should render the template" do
      get 'index'
      response.should render_template(:index)
    end
  end
end
