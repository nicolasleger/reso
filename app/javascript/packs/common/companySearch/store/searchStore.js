import SearchAPIService from '../utils/searchAPIService'
import * as types from './searchMutationTypes'
import * as errors from '../utils/searchErrorTypes'

const state = {
    isRequestInProgress: false,
    formErrorType: '',
    companyData: {},
    siret: '',
    siren: '',
    name: '',
    county: '',
    companies: []
}

const getters = {}

const actions = {
    fetchCompanyBySiret({commit, state, searchAPIServiceDependency}) {
        let searchAPIService = searchAPIServiceDependency
        if (typeof searchAPIService === 'undefined') {
            searchAPIService = SearchAPIService
        }

        commit(types.REQUEST_IN_PROGRESS, true)
        return searchAPIService.fetchCompanyBySiret(state.siret)
            .then((data) => {
                commit(types.COMPANY_DATA, {
                    name: data.company_name,
                    location: data.facility_location,
                    siret: state.siret
                })
            })
            .catch(() => {
                commit(types.FORM_ERROR_TYPE, errors.NOT_FOUND_ERROR)
            })
            .then(() => {
                commit(types.REQUEST_IN_PROGRESS, false)
            })
    },

    fetchCompanyBySiren({commit, state, searchAPIServiceDependency}) {
        let searchAPIService = searchAPIServiceDependency
        if (typeof searchAPIService === 'undefined') {
            searchAPIService = SearchAPIService
        }

        commit(types.REQUEST_IN_PROGRESS, true)
        return searchAPIService.fetchCompanyBySiren(state.siren)
            .then((data) => {
                commit(types.COMPANY_DATA, {
                    name: data.company_name,
                    location: data.facility_location,
                    siret: data.siret
                })
            })
            .catch(() => {
                commit(types.FORM_ERROR_TYPE, errors.NOT_FOUND_ERROR)
            })
            .then(() => {
                commit(types.REQUEST_IN_PROGRESS, false)
            })
    },

    fetchCompaniesByName({commit, state, searchAPIServiceDependency}) {
        let searchAPIService = searchAPIServiceDependency
        if (typeof searchAPIService === 'undefined') {
            searchAPIService = SearchAPIService
        }

        commit(types.REQUEST_IN_PROGRESS, true)
        return searchAPIService.fetchCompaniesByName({name: state.name, county: state.county})
            .then((data) => {
                commit(types.COMPANIES, data.companies)
            })
            .catch(() => {
                commit(types.FORM_ERROR_TYPE, errors.NOT_FOUND_ERROR)
            })
            .then(() => {
                commit(types.REQUEST_IN_PROGRESS, false)
            })
    }
}

const mutations = {
    [types.REQUEST_IN_PROGRESS](state, isRequestInProgress) {
        state.isRequestInProgress = isRequestInProgress
    },

    [types.FORM_ERROR_TYPE](state, formErrorType) {
        state.formErrorType = formErrorType
        state.companyData = {}
    },

    [types.SIRET](state, siret) {
        state.siret = siret
    },

    [types.SIREN](state, siren) {
        state.siren = siren
    },

    [types.NAME](state, name) {
        state.name = name
    },

    [types.COUNTY](state, county) {
        state.county = county
    },

    [types.COMPANIES](state, companies) {
        state.companies = companies
    },

    [types.COMPANY_DATA](state, {name, location, siret}) {
        state.companyData = {name: name, location: location, siret: siret}
        state.formErrorType = ''
    }
}

export default {
    state,
    getters,
    actions,
    mutations
}
