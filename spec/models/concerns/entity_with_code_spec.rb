require 'rails_helper'

class CodeDummyClass < ApplicationRecord
  include EntityWithCode

  self.table_name = 'code_dummy_class_table'
end

describe EntityWithCode do
  def create_table
    ActiveRecord::Base.connection.create_table :code_dummy_class_table do |t|
      t.string :code
    end
  end

  def drop_table
    ActiveRecord::Base.connection.drop_table :code_dummy_class_table
  end

  before do
    create_table
    CodeDummyClass.reset_column_information
  end

  after { drop_table }

  context 'when creating an entity with code attribute' do
    let(:dummy_model) { CodeDummyClass.new(code: code) }

    before do
      dummy_model.save
    end

    context 'when the code attribute is not present' do
      let(:code) { ['', nil].sample }

      it 'sets the code equal to the concatenation of the class name and ID' do
        expect(dummy_model.code).to eq "code_dummy_class_#{dummy_model.id}"
      end
    end

    context 'when the code attribute is present' do
      let(:code) { 'code_dummy_class_10' }

      it 'sets the passed code' do
        expect(dummy_model.code).to eq code
      end

      context 'when it is not unique' do
        let(:another_dummy_model) { CodeDummyClass.new(code: dummy_model.code) }

        it 'raises an error' do
          expect { another_dummy_model.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  context 'when updating an entity with code attribute' do
    let!(:dummy_model) { CodeDummyClass.create(code: 'code') }

    before do
      CodeDummyClass.update(dummy_model.id, code: code)
    end

    context 'when the code attribute is not present' do
      let(:code) { ['', nil].sample }

      it 'sets the code equal to the concatenation of the class name and ID' do
        expect(dummy_model.reload.code).to eq "code_dummy_class_#{dummy_model.id}"
      end
    end

    context 'when the code attribute is present' do
      let(:code) { 'dummy_class_10' }

      it 'sets the passed code' do
        expect(dummy_model.reload.code).to eq code
      end

      context 'when it is not unique' do
        let(:another_dummy_model) { CodeDummyClass.new(code: code) }

        it 'raises an error' do
          expect { another_dummy_model.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end

  context 'when duplicating an entity with code attribute' do
    let!(:dummy_model) { CodeDummyClass.create(code: 'code') }

    it 'does not copy the code attribute' do
      expect(dummy_model.dup.code).to be_nil
    end
  end
end
