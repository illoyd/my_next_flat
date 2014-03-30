shared_examples 'an includeable range' do |min_attribute, max_attribute|

  it 'includes other when attributes are equal' do
    other.send("#{ min_attribute }=", subject.send(min_attribute))
    other.send("#{ max_attribute }=", subject.send(max_attribute))
    expect( subject.includes?(other) ).to be_true
  end

  it 'includes other when min is greater' do
    other.send("#{ min_attribute }=", subject.send(min_attribute) + 1)
    other.send("#{ max_attribute }=", subject.send(max_attribute))
    expect( subject.includes?(other) ).to be_true
  end

  it 'includes other when max is smaller' do
    other.send("#{ min_attribute }=", subject.send(min_attribute))
    other.send("#{ max_attribute }=", subject.send(max_attribute) - 1)
    expect( subject.includes?(other) ).to be_true
  end

  it 'does not include other when min is smaller' do
    other.send("#{ min_attribute }=", subject.send(min_attribute) - 1)
    other.send("#{ max_attribute }=", subject.send(max_attribute))
    expect( subject.includes?(other) ).to be_false
  end

  it 'does not include other when max is bigger' do
    other.send("#{ min_attribute }=", subject.send(min_attribute))
    other.send("#{ max_attribute }=", subject.send(max_attribute) + 1)
    expect( subject.includes?(other) ).to be_false
  end

end
