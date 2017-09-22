# frozen_string_literal: true

json.in_progress @diagnoses[:in_progress].each do |diagnosis|
  json.partial! 'api/diagnoses/diagnosis_in_progress', diagnosis: diagnosis
end

json.completed @diagnoses[:completed].each do |diagnosis|
  json.partial! 'api/diagnoses/diagnosis_completed', diagnosis: diagnosis
end