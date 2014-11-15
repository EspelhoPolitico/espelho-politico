require 'rails_helper'

RSpec.describe RankingsController, :type => :controller do

  describe "GET index" do
    it "return @themes correctly" do
      get :index
      expect{
        (response).to render_template("index")}
      expect{
        (assigns(:themes)).not_to be_nil}
    end
  end

  describe "POST index" do
    it "finds theme id by params" do
      Theme.new(:id => 532, :description => "Saúde")
      expect{
        (assigns(:theme_id)).not_to be_nil}
      expect{
        (assigns(:theme_description).to eq(:theme_id))}
    end
  end

  describe "order themes" do
    describe "with database data" do
      it "Assigns themes to appear on index" do
        themes = []
        themes << Theme.new(:id => 532, :description => "Saúde")
        themes << Theme.new(:id => 123, :description => "Educação")
        themes << Theme.new(:id => 521, :description => "Segurança")
      
        theme = controller.order_themes(@themes)
        expect {
          (assigns(:themes)).to match_array(theme)}
      end
    end
  end
end