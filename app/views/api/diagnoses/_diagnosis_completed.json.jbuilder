# frozen_string_literal: true

json.extract! diagnosis, :id, :content, :step,
              :diagnosed_needs_count, :selected_assistances_experts_count

json.visit do
  json.facility do
    json.company do
      json.name_short diagnosis.visit.facility.company.name_short
    end
  end
  json.visitee do
    json.full_name diagnosis.visit.visitee.full_name
  end
end
