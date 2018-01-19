require 'rails_helper'

RSpec.shared_examples 'sortable' do
  let(:model) { described_class }

  before do
    50.times { Fabricate(:guest) }
  end

  # This tests that all records are ordered and visible when LIMIT is used
  # for pagination.
  # https://stackoverflow.com/questions/13580826/postgresql-repeating-rows-from-limit-offset

  context 'returns an ordered array no matter if LIMIT is used' do
    it 'works for #default_order' do
      test_pg_limit_order_by_clause(:default_order)
    end

    it 'works for #order_by_invited_at' do
      test_pg_limit_order_by_clause(:order_by_invited_at)
    end

    it 'works for #order_by_relationship' do
      test_pg_limit_order_by_clause(:order_by_relationship)
    end

    it 'works for #order_by_invited' do
      test_pg_limit_order_by_clause(:order_by_invited)
    end

    it 'works for #order_by -> first_name' do
      test_pg_limit_order_by_clause_for('first_name')
    end

    it 'works for #order_by -> last_name' do
      test_pg_limit_order_by_clause_for('last_name')
    end

    it 'works for #order_by -> father_surname' do
      test_pg_limit_order_by_clause_for('father_surname')
    end

    it 'works for #order_by -> mother_surname' do
      test_pg_limit_order_by_clause_for('mother_surname')
    end

    it 'works for #order_by -> email' do
      test_pg_limit_order_by_clause_for('email')
    end

    it 'works for #order_by -> phone' do
      test_pg_limit_order_by_clause_for('phone')
    end

    it 'works for #order_by -> created_at' do
      test_pg_limit_order_by_clause_for('created_at')
    end
  end

  def test_pg_limit_order_by_clause_for(attribute)
    expected = model.order_by(attribute, 'desc').map(&:id)

    (10..50).step(10).each do |n|
      actual = model.order_by(attribute, 'desc').limit(n).map(&:id)
      expect(expected.first(n)).to eq(actual)
    end
  end

  def test_pg_limit_order_by_clause(method)
    # Test array of ids as returned by method vs when calling 'limit'.
    if model.method(method).arity == 1
      expected = model.send(method.to_sym, 'desc').map(&:id)

      (10..50).step(10).each do |n|
        actual = model.send(method.to_sym, 'desc').limit(n).map(&:id)
        expect(expected.first(n)).to eq(actual)
      end

    elsif model.method(method).arity == 0
      expected = model.send(method.to_sym,).map(&:id)

      (10..50).step(10).each do |n|
        actual = model.send(method.to_sym).limit(n).map(&:id)
        expect(expected.first(n)).to eq(actual)
      end
    end
  end
end
