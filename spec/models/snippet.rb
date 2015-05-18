describe 'Snippet' do

  before do
    class << self
      include CDQ
    end
    cdq.setup
  end

  after do
    cdq.reset!
  end

  it 'should be a Snippet entity' do
    Snippet.entity_description.name.should == 'Snippet'
  end
end
