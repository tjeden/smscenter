# -*- encoding: utf-8 -*-

require 'helper'

describe Mobitex::Delivery do

  describe '.errors' do
    describe 'before delivery' do
      it 'returns empty hash' do
        Mobitex::Delivery.new.errors.must_equal({})
      end
    end
  end

end