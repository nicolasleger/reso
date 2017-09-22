# frozen_string_literal: true

json.extract! diagnosis, :id, :content, :step

json.visit do
  json.facility do
    json.company do
      json.name_short diagnosis.visit.facility.company.name_short
    end
  end
end
