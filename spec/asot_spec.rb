require 'spec_helper'

describe Asot do
  it 'has a version number' do
    expect(Asot::VERSION).not_to be nil
  end

  describe 'self.connect' do
    subject { Asot::Rest::Connector }
    before { allow(subject).to receive(:new).with(anything) }

    it 'call Asot::Rest::Connector' do
      Asot.connect({})
      expect(subject).to have_received(:new).with(anything).once
    end
  end
end
