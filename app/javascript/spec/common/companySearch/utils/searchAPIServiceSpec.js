import SearchAPIService from '../../../../packs/common/companySearch/utils/searchAPIService'

//for the async function to work
require('babel-core/register')

describe('SearchAPIService', () => {

    describe('fetchCompanyBySiret', () => {

        const siret = '48245813000010'
        const responseData = {
            'company_name': 'OCTO',
            'facility_location': '59350 Lille'
        }

        var returnPromise

        describe('with a success', function () {

            beforeEach(function () {
                var promise = Promise.resolve({data: responseData})
                spyOn(SearchAPIService, 'send').and.returnValue(promise)

                returnPromise = SearchAPIService.fetchCompanyBySiret(siret)
            })

            it('calls send with the right arguments', function () {
                var config = {
                    method: 'post',
                    url: `/api/facilities/search_by_siret`,
                    data: {siret: siret}
                }
                expect(SearchAPIService.send.calls.count()).toEqual(1)
                expect(SearchAPIService.send.calls.argsFor(0)).toEqual([config])
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
                spyOn(SearchAPIService, 'send').and.returnValue(promise)

                returnPromise = SearchAPIService.fetchCompanyBySiret(siret)
            })

            it('calls send with the right arguments', function () {
                var config = {
                    method: 'post',
                    url: `/api/facilities/search_by_siret`,
                    data: {siret: siret}
                }
                expect(SearchAPIService.send.calls.count()).toEqual(1)
                expect(SearchAPIService.send.calls.argsFor(0)).toEqual([config])
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

    describe('fetchCompanyBySiren', () => {

        const siren = '482458130'
        const responseData = {
            'company_name': 'OCTO',
            'facility_location': '59350 Lille'
        }

        var returnPromise

        describe('with a success', function () {

            beforeEach(function () {
                var promise = Promise.resolve({data: responseData})
                spyOn(SearchAPIService, 'send').and.returnValue(promise)

                returnPromise = SearchAPIService.fetchCompanyBySiren(siren)
            })

            it('calls send with the right arguments', function () {
                var config = {
                    method: 'post',
                    url: `/api/facilities/search_by_siren`,
                    data: {siren: siren}
                }
                expect(SearchAPIService.send.calls.count()).toEqual(1)
                expect(SearchAPIService.send.calls.argsFor(0)).toEqual([config])
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
                spyOn(SearchAPIService, 'send').and.returnValue(promise)

                returnPromise = SearchAPIService.fetchCompanyBySiren(siren)
            })

            it('calls send with the right arguments', function () {
                var config = {
                    method: 'post',
                    url: `/api/facilities/search_by_siren`,
                    data: {siren: siren}
                }
                expect(SearchAPIService.send.calls.count()).toEqual(1)
                expect(SearchAPIService.send.calls.argsFor(0)).toEqual([config])
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

    describe('fetchCompaniesByName', () => {

        let returnPromise
        const name = 'Boulangerie Maubeuge'
        const county = '59'

        const responseData = {
            'companies': [{
                'siren': '123456789',
                'name': 'Octo',
                'location': 'Meubauge'
            }]
        }

        describe('with a success', function () {

            beforeEach(function () {
                const promise = Promise.resolve({data: responseData})
                spyOn(SearchAPIService, 'send').and.returnValue(promise)

                returnPromise = SearchAPIService.fetchCompaniesByName({name: name, county: county})
            })

            it('calls send with the right arguments', function () {
                const config = {
                    method: 'post',
                    url: `/api/companies/search_by_name`,
                    data: {company: {name: name, county: county}}
                }
                expect(SearchAPIService.send.calls.count()).toEqual(1)
                expect(SearchAPIService.send.calls.argsFor(0)).toEqual([config])
            })

            it('returns a promise', function () {
                expect(typeof returnPromise.then).toBe('function')
            })

            it('returns company data', async function () {
                let serviceResponse
                await returnPromise.then((response) => {
                    serviceResponse = response
                })
                expect(serviceResponse).toEqual(responseData)
            })
        })

        describe('with an error', function () {

            let error = new Error('error')
            beforeEach(function () {
                const promise = Promise.reject(error)
                spyOn(SearchAPIService, 'send').and.returnValue(promise)

                returnPromise = SearchAPIService.fetchCompaniesByName({name: name, county: county})
            })

            it('calls send with the right arguments', function () {
                const config = {
                    method: 'post',
                    url: `/api/companies/search_by_name`,
                    data: {company: {name: name, county: county}}
                }
                expect(SearchAPIService.send.calls.count()).toEqual(1)
                expect(SearchAPIService.send.calls.argsFor(0)).toEqual([config])
            })

            it('returns a promise', function () {
                expect(typeof returnPromise.then).toBe('function')
            })

            it('returns an error', async function () {

                let serviceResponse
                let serviceError
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