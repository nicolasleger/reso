# frozen_string_literal: true

class TerritoryUsersController < ApplicationController
  def diagnosis
    associations = [visit: [:visitee, :advisor, facility: [:company]],
                    diagnosed_needs: [selected_assistance_experts: [assistance_expert: :expert]]]
    @diagnosis = Diagnosis.includes(associations).find(params[:diagnosis_id])
    check_territory_user_access
    @current_user_diagnosed_needs = @diagnosis.diagnosed_needs.of_territory_user(@territory_user)
                                              .includes(:selected_assistance_experts)
    render 'experts/diagnosis'
  end

  private

  def check_territory_user_access
    @territory_user = TerritoryUser.of_user(current_user).of_diagnosis_location(@diagnosis).first
    not_found unless @territory_user
  end
end
