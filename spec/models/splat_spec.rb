require 'spec_helper'

describe 'Splat Operator' do

  def by_itself(*args)
    args.count
  end
  
  def in_array(*args)
    Array(args).count
  end
  
  def in_wrap(*args)
    Array.wrap(args).count
  end
  
  def passes_in_array_to_array(*args)
    in_array(Array(args))
  end
  
  def passes_by_wrap_to_wrap(*args)
    in_wrap(Array.wrap(args))
  end
  
  def passes_by_splat_to_itself(*args)
    by_itself(*args)
  end
  
  context 'by itself' do
    it { expect( by_itself('x') ).to eq(1) }
    it { expect( by_itself('x', 'y') ).to eq(2) }
    it { expect( by_itself('x', 'y', 'z') ).to eq(3) }
  end

  context 'in array' do
    it { expect( in_array('x') ).to eq(1) }
    it { expect( in_array('x', 'y') ).to eq(2) }
    it { expect( in_array('x', 'y', 'z') ).to eq(3) }
  end

  context 'in wrap' do
    it { expect( in_wrap('x') ).to eq(1) }
    it { expect( in_wrap('x', 'y') ).to eq(2) }
    it { expect( in_wrap('x', 'y', 'z') ).to eq(3) }
  end

  context 'by splat to itself' do
    it { expect( passes_by_splat_to_itself('x') ).to eq(1) }
    it { expect( passes_by_splat_to_itself('x', 'y') ).to eq(2) }
    it { expect( passes_by_splat_to_itself('x', 'y', 'z') ).to eq(3) }
    
    context 'with array' do
      it { expect( passes_by_splat_to_itself(['x']) ).to eq(1) }
      pending 'hmmm' do
        it { expect( passes_by_splat_to_itself(['x', 'y']) ).to eq(2) }
        it { expect( passes_by_splat_to_itself(['x', 'y', 'z']) ).to eq(3) }
      end
    end
    
    context 'with hash' do
      it { expect( passes_by_splat_to_itself(x: 'x') ).to eq(1) }
      it { expect( passes_by_splat_to_itself(x: 'x', y: 'y') ).to eq(1) }
      it { expect( passes_by_splat_to_itself(x: 'x', y: 'y', z: 'z') ).to eq(1) }
    end
  end

end
