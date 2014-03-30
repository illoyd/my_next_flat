shared_examples 'a range attribute' do |range_attribute, min_attribute, max_attribute|

  it 'returns a range' do
    expect( subject.send(range_attribute) ).to be_a(Range)
  end

  it 'uses the min value' do
    expect( subject.send(range_attribute).min ).to eq(subject.send(min_attribute))
  end
  
  it 'uses the max value' do
    expect( subject.send(range_attribute).max ).to eq(subject.send(max_attribute))
  end
  
  it 'uses 0 for nil min values' do
    subject.send("#{ min_attribute }=", nil)
    expect( subject.send(range_attribute).min ).to eq(0)
  end
  
  it 'uses Infinity for nil max values' do
    subject.send("#{ max_attribute }=", nil)
    expect( subject.send(range_attribute).max ).to eq(Float::INFINITY)
  end
  
end
