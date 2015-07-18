require 'rails_helper'

RSpec.describe Mobilizations::BlocksController, type: :controller do
  describe "GET #index" do
    it "should return blocks by mobilization" do
      mobilization1 = Mobilization.make!
      mobilization2 = Mobilization.make!
      block1 = Block.make! mobilization: mobilization1
      block2 = Block.make! mobilization: mobilization2

      get :index, mobilization_id: mobilization1.id

      expect(response.body).to include(block1.to_json)
      expect(response.body).to_not include(block2.to_json)
    end
  end

  describe "POST #create" do
    it "should create with JSON format and empty params" do
      mobilization = Mobilization.make!
      expect(mobilization.blocks.count).to eq(0)
      post :create, mobilization_id: mobilization.id, format: :json
      expect(mobilization.blocks.count).to eq(1)
      expect(response.body).to include(mobilization.blocks.first.to_json)
    end

    it "should create with JSON format and position param" do
      mobilization = Mobilization.make!
      expect(mobilization.blocks.count).to eq(0)
      post :create, mobilization_id: mobilization.id, format: :json, block: { position: 12345 }
      expect(mobilization.blocks.count).to eq(1)
      block = mobilization.blocks.first
      expect(response.body).to include(block.to_json)
      expect(block.position).to eq(12345)
    end

    it "should create nested widgets" do
      mobilization = Mobilization.make!
      expect(mobilization.blocks.count).to eq(0)
      post :create, mobilization_id: mobilization.id, format: :json, block: { widgets_attributes: [{kind: 'content', size: 4}, {kind: 'weather', size: 8}] }
      expect(mobilization.blocks.count).to eq(1)
      block = mobilization.blocks.first
      expect(response.body).to include(block.to_json)
      expect(block.widgets.count).to eq(2)
      widget1 = block.widgets[0]
      widget2 = block.widgets[1]
      expect(widget1.kind).to eq('content')
      expect(widget1.size).to eq(4)
      expect(widget2.kind).to eq('weather')
      expect(widget2.size).to eq(8)
    end
  end
end
