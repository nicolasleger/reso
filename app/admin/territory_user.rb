# frozen_string_literal: true

ActiveAdmin.register TerritoryUser do
  menu parent: :territories, priority: 1
  permit_params :territory_id, :user_id
  includes :territory, :user

  form do |f|
    inputs do
      f.input :territory, collection: Territory.ordered_by_name
      f.input :user, collection: User.ordered_by_names
    end
    actions
  end

  filter :territory, collection: -> { Territory.ordered_by_name }
  filter :user, collection: -> { User.ordered_by_names }
  filter :created_at
  filter :updated_at
end
