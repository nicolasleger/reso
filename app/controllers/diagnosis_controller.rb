# frozen_string_literal: true

class DiagnosisController < ApplicationController
  layout 'with_visit_subnavbar'

  def new
    @visit = Visit.of_advisor(current_user).includes(:company).find params[:visit_id]
    @diagnosis = Diagnosis.new visit: @visit
  end

  def create
    pp params
    pp diagnosis_params
    diagnosis = Diagnosis.new visit_id: visit_id_params
    pp diagnosis
    # diagnosis = Diagnosis.new @visit
  end

  def show

  end

  def index; end

  def question
    @visit = Visit.of_advisor(current_user).includes(:visitee, :company).find params[:visit_id]
    @question = Question.includes(:assistances, assistances: %i[company user]).find params[:id]
  end

  private

  def diagnosis_params
    params.require(:questions)
  end

  def visit_id_params
    params.require(:visit_id)
  end
end
