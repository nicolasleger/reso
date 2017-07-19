import ContactAPIService from './contactAPIService'
import * as types from './mutationTypes'

const state = {
    contact: undefined,
    visitId: undefined,
    isContactRequestUnderWay: false
};

const getters = {
};

const actions = {
    createContact ({ commit, state, contactAPIServiceDependency }, contactData) {
        var contactAPIService = contactAPIServiceDependency;
        if(typeof contactAPIService == 'undefined') {
            contactAPIService = ContactAPIService;
        }

        commit(types.CONTACT_REQUEST_UNDERWAY, {isContactRequestUnderWay: true});
        return contactAPIService.createContactOnVisit(state.visitId, contactData)
            .then( (contact) => {
                commit(types.CONTACT, {contact: contact});
                commit(types.CONTACT_REQUEST_UNDERWAY, {isContactRequestUnderWay: false});
            });
    },

    getContact ({ commit, state, contactAPIServiceDependency }) {
        var contactAPIService = contactAPIServiceDependency;
        if(typeof contactAPIService == 'undefined') {
            contactAPIService = ContactAPIService;
        }

        commit(types.CONTACT_REQUEST_UNDERWAY, {isContactRequestUnderWay: true});
        return contactAPIService.getContacts(state.visitId)
            .then( (contacts) => {
                commit(types.CONTACT, {contact: contacts[0]});
                commit(types.CONTACT_REQUEST_UNDERWAY, {isContactRequestUnderWay: false});
            });
    }
};

const mutations = {
    [types.CONTACT_REQUEST_UNDERWAY] (state, { isContactRequestUnderWay }) {
        state.isContactRequestUnderWay = isContactRequestUnderWay;
    },

    [types.CONTACT] (state, { contact }) {
        state.contact = contact;
    },

    [types.VISIT_ID] (state, { visitId }) {
        state.visitId = visitId;
    }
};

export default {
    state,
    getters,
    actions,
    mutations
};