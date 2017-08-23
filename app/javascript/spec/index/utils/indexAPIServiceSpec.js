import IndexAPIService from '../../../packs/index/utils/indexAPIService'

//for the async function to work
require('babel-core/register')

describe('IndexAPIService', () => {

    const siret = '48245813000010'
    const responseData = {
        'company_name': 'OCTO',
        'facility_location': '59350 Lille'
    }

    describe('fetchCompany', () => {

        var returnPromise

        describe('with a success', function () {

            beforeEach(function () {
                var promise = Promise.resolve({data: responseData})
                spyOn(IndexAPIService, 'send').and.returnValue(promise)

                returnPromise = IndexAPIService.fetchCompany(siret)
            })

            it('calls send with the right arguments', function () {
                var config = {
                    method: 'post',
                    url: `/api/facilities/search_by_siret`,
                    data: {siret: siret}
                }
                expect(IndexAPIService.send.calls.count()).toEqual(1)
                expect(IndexAPIService.send.calls.argsFor(0)).toEqual([config])
            })

            it('returns a promise', function () {
                expect(typeof returnPromise.then).toBe('function')
            })

            it('returns company data', async function () {
                var serviceResponse
                await returnPromise.then((response) => {
                    serviceResponse = response
                })
                expect(serviceResponse).toEqual(responseData)
            })
        })

        describe('with an error', function () {

            let error = new Error('error')
            beforeEach(function () {
                var promise = Promise.reject(error)
                spyOn(IndexAPIService, 'send').and.returnValue(promise)

                returnPromise = IndexAPIService.fetchCompany(siret)
            })

            it('calls send with the right arguments', function () {
                var config = {
                    method: 'post',
                    url: `/api/facilities/search_by_siret`,
                    data: {siret: siret}
                }
                expect(IndexAPIService.send.calls.count()).toEqual(1)
                expect(IndexAPIService.send.calls.argsFor(0)).toEqual([config])
            })

            it('returns a promise', function () {
                expect(typeof returnPromise.then).toBe('function')
            })

            it('returns an error', async function () {

                var serviceResponse
                var serviceError
                await returnPromise
                    .then((response) => {
                        serviceResponse = response
                    })
                    .catch((error) => {
                        serviceError = error
                    })

                expect(serviceResponse).toBeUndefined()
                expect(serviceError).toEqual(error)
            })
        })
    })
})