describe 'Regexp Mixins' do
  it 'should strip special char for beginning of string' do
    expr = /^match/
    expr.strip.should == 'match'
  end

  it 'should strip special char for end of string' do
    expr = /match$/
    expr.strip.should == 'match'
  end
end
