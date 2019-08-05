module RequestCollectionExamples
  RSpec.shared_examples "request collection" do
    before(:all) do
      @ignored_examples = [] if @ignored_examples.nil?
      @response = @resource.create(**@create_hash)
      @new_resource_id = @response.first["#{@resource_name}_id".to_sym]
    end

    describe '#create' do
      it "creates a resource" do
        skip if @ignored_examples.include? :create
        expect(@new_resource_id).to be_truthy
      end
    end

    describe '#list' do
      it "gets a list of resources" do
        skip if @ignored_examples.include? :list
        @response = @resource.list()
        expect(@response.length).to be > 0
      end
      it "test url params"
    end

    describe '#list_extended' do
      it "gets a list of resources" do
        skip if @ignored_examples.include? :list_extended
        @response = @resource.list_extended()
        expect(@response.length).to be > 0
      end
      it "test url params"
    end

    describe '#retrieve' do
      it "correctly retrieves a resource" do
        skip if @ignored_examples.include? :retrieve
        @response = @resource.retrieve(@new_resource_id)
        expect(@response["#{@resource_name}_id".to_sym]).to eql(@new_resource_id)
      end
    end

    describe '#retrieve_extended' do
      it "correctly retrieves extended resource" do
        skip if @ignored_examples.include? :retrieve_extended
        @response = @resource.retrieve_extended(@new_resource_id)
        expect(@response["#{@resource_name}_id".to_sym]).to eql(@new_resource_id)
      end
    end

    describe '#create_bulk' do
      it 'succesfully creates over 100 resources'
    end

    describe '#update' do
      it "updates a resource" do
        skip if @ignored_examples.include? :update
        @response = @resource.update(
          "#{@resource_name}_id".to_sym => @new_resource_id,
          **@update_hash
        )
        expect(@response.length).to eql(1)
        expect(@response.first[:code]).to eql("SUCCESS")
      end
    end

    describe '#update_bulk' do
      it 'succesfully updates several resources' do
        skip if @ignored_examples.include? :update_bulk
        resources = @resource.list()
        payload = resources.map do |r|
          {
            "#{@resource_name}_id".to_sym => r["#{@resource_name}_id".to_sym],
            **@update_hash
          }
        end
        @response = @resource.update_bulk(payload)
        expect(@response.length).to eql(resources.length)
      end
    end

    describe '#delete' do
      it "deletes a resource" do
        skip if @ignored_examples.include? :delete
        @response = @resource.delete(@new_resource_id)
        expect(@response[:code]).to eql("SUCCESS")
      end
    end

    after(:each) do |example|
      puts @response if example.exception
    end
  end
end
