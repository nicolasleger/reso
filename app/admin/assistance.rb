# frozen_string_literal: true

ActiveAdmin.register Assistance do
  menu parent: :experts, priority: 2
  includes :question, :experts

  permit_params do
    permitted = [
      :id,
      :question_id,
      :title,
      :description,
      :_destroy,
      assistances_experts_attributes: %i[id expert_id _create _update _destroy]
    ]
    permitted << :other if params[:action] == 'create'
    permitted
  end

  index do
    selectable_column
    id_column
    column :question
    column :title
    column :experts, (proc { |assistance| assistance.experts.size })
    actions
  end

  show do
    attributes_table do
      row :question
      row :title
      row :description
    end

    panel I18n.t('active_admin.assistances.experts') do
      table_for assistance.experts.includes(:territories) do
        column :full_name, (proc { |expert| link_to(expert.full_name, admin_expert_path(expert)) })
        column :role
        column(:territories) do |expert|
          safe_join(expert.territories.map do |territory|
            link_to territory.name, admin_territory_path(territory)
          end, ', '.html_safe)
        end
      end
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :question
      f.input :title
      f.input :description
    end

    f.inputs I18n.t('active_admin.assistances.experts') do
      f.has_many :assistances_experts,
                 heading: false,
                 new_record: I18n.t('active_admin.assistances.add_expert'),
                 allow_destroy: true do |assistance_expert|
        assistance_expert.input :expert, label: I18n.t('active_admin.assistances.expert')
      end
    end

    f.actions
  end

  filter :title
  filter :question
  filter :experts
  filter :created_at
  filter :updated_at
end
