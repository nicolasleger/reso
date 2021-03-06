import axios from 'axios'
import ErrorService from '../../common/errorService'

export default {

  getDiagnosisContent (diagnosisId) {
    var config = {
      method: 'get',
      url: `/api/diagnoses/${diagnosisId}`
    }

    return this.send(config)
      .then((response) => {
        return response.data.content
      })
  },

  updateDiagnosisContent (diagnosisId, content) {
    var config = {
      method: 'patch',
      url: `/api/diagnoses/${diagnosisId}`,
      data: {
        diagnosis: {
          content: content
        }
      }
    }

    return this.send(config).then(() => {
      return true
    })
  },

  getDiagnosedNeeds (diagnosisId) {
    var config = {
      method: 'get',
      url: `/api/diagnoses/${diagnosisId}/diagnosed_needs`
    }

    return this.send(config).then((response) => {
      return response.data
    })
  },

  updateDiagnosedNeeds (diagnosisId, diagnosedNeedBulkRequestBody) {
    /* eslint-disable camelcase */
    var config = {
      method: 'post',
      url: `/api/diagnoses/${diagnosisId}/diagnosed_needs/bulk`,
      data: {
        bulk_params: diagnosedNeedBulkRequestBody
      }
    }
    /* eslint-enable camelcase */
    return this.send(config).then(() => {
      return true
    })
  },

  send (config) {
    return axios(config).catch((error) => {
      throw ErrorService.configureAPIErrorMessage(error, config)
    })
  }
}
