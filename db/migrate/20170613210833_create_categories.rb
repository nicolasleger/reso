# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :label

      t.timestamps
    end
  end
end