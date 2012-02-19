require 'helper'

describe Mobitex do

  describe '::new' do
    it 'returns a new Mobitex::Message object' do
      Mobitex.new.must_be_instance_of Mobitex::Message
    end
  end

end