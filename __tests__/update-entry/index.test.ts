import {beforeEach, describe, expect, test} from "@jest/globals";
import {Context, HttpRequest} from "@azure/functions";
import {faker} from '@faker-js/faker';
import sut from "../../update-entry"

jest.mock('@azure/cosmos', () => {
    return {
        CosmosClient: jest.fn(() => ({
            database: jest.fn(() => ({
                container: jest.fn(() => ({
                    items: {
                        create: jest.fn((item) => Promise.resolve({item}))
                    }
                }))
            }))
        }))
    }
})

describe('Update Entry API', () => {

    let context: Context;
    let request: HttpRequest;
    let body = {} as any

    process.env = {
        COSMOSDB_ENDPOINT: 'https://test.documents.azure.com:443',
        COSMOSDB_KEY: 'key',
        COSMOSDB_DATABASE_NAME: 'database',
        COSMOSDB_CONTAINER_NAME: 'container',
        COSMOSDB_USER_AGENT_SUFFIX: 'test'
    }

    beforeEach(() => {

        jest.resetModules() // Most important - it clears the cache

        // Really crude and unsafe implementations that will be replaced soon
        context = {
            log: jest.fn()
        } as unknown as Context;
        request = {body} as unknown as HttpRequest
    });

    test('should update entry', async () => {

        // Given
        request.body = {
            name: faker.person.firstName(),
            cid: faker.string.uuid(),
            definition: {id: faker.person.sex()}
        }

        request.params = {
            id: faker.string.uuid()
        }

        // When
        const answer = await sut(context, request)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(201)
        expect(answer.body.id).toBeDefined()
    });
})