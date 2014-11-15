require 'rails_helper'

RSpec.describe ProfileHelper, :type => :helper do

  describe "GET index" do
    it "return @propositions correctly" do
      propositions = Proposition.all
      expect{
        (assigns(:propositions)).not_to be_nil}
    end
  end
end