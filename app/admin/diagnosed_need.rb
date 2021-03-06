# frozen_string_literal: true

ActiveAdmin.register DiagnosedNeed do
  menu parent: :diagnoses, priority: 1
  actions :index, :show
  includes :diagnosis, :question

  filter :diagnosis, collection: -> { Diagnosis.order(created_at: :desc).pluck(:id) }
  filter :question, collection: -> { Question.order(:label) }
  filter :question_label
  filter :content
  filter :created_at
  filter :updated_at
end
