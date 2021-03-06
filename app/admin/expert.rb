# frozen_string_literal: true

ActiveAdmin.register Expert do
  menu priority: 6
  includes :institution, :assistances, :territories

  permit_params [
    :first_name,
    :last_name,
    :role,
    :institution_id,
    :email,
    :phone_number,
    expert_territories_attributes: %i[id territory_id _create _update _destroy],
    assistances_experts_attributes: %i[id assistance_id _create _update _destroy]
  ]

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :role
    column :institution
    column t('active_admin.experts.assistances_count'), (proc { |expert| expert.assistances.length })
    column(:territories) do |expert|
      safe_join(expert.territories.map do |territory|
        link_to territory.name, admin_territory_path(territory)
      end, ', '.html_safe)
    end
    actions
  end

  show do
    attributes_table do
      row :first_name
      row :last_name
      row :role
      row :institution
      row :email
      row :phone_number
      row :access_token
      row(:territories) do |expert|
        safe_join(expert.territories.map do |territory|
          link_to territory.name, admin_territory_path(territory)
        end, ', '.html_safe)
      end
    end

    panel I18n.t('active_admin.experts.assistances') do
      table_for expert.assistances do
        column :title, (proc { |assistance| link_to(assistance.title, admin_assistance_path(assistance)) })
        column :question
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :role
      f.input :institution, collection: Institution.ordered_by_name
      f.input :email
      f.input :phone_number
    end

    f.inputs I18n.t('active_admin.experts.territories') do
      f.has_many :expert_territories,
                 heading: false,
                 new_record: I18n.t('active_admin.experts.add_territory'),
                 allow_destroy: true do |expert_territory|
        expert_territory.input :territory, label: I18n.t('active_admin.experts.territory')
      end
    end

    f.inputs I18n.t('active_admin.experts.assistances') do
      f.has_many :assistances_experts,
                 heading: false,
                 new_record: I18n.t('active_admin.experts.add_assistance'),
                 allow_destroy: true do |assistance_expert|
        assistance_expert.input :assistance, label: I18n.t('active_admin.experts.assistance')
      end
    end

    f.actions
  end

  filter :institution, collection: -> { Institution.ordered_by_name }
  filter :assistances, collection: -> { Assistance.order(:title).map { |a| ["#{a.title} (#{a.id})", a.id] } }
  filter :first_name
  filter :last_name
  filter :email
  filter :phone_number
  filter :role
  filter :created_at
  filter :updated_at
  filter :territories, collection: -> { Territory.order(:name) }
end
