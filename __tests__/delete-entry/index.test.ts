import {beforeEach, describe, expect, test} from "@jest/globals";
import {Context, HttpRequest, HttpRequestParams} from "@azure/functions";
import {faker} from '@faker-js/faker';
import sut from "../../delete-entry"

jest.mock('@azure/cosmos', () => {
    return {
        CosmosClient: jest.fn(() => ({
            database: jest.fn(() => ({
                container: jest.fn(() => ({
                    item: jest.fn(() => ({
                        delete: jest.fn(() => Promise.resolve())
                    }))
                }))
            }))
        }))
    }
})

describe('Delete Entry API', () => {

    let context: Context;
    let request: HttpRequest;
    let params = {} as HttpRequestParams

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
        request = {params} as unknown as HttpRequest
    });

    test('should delete entry', async () => {

        // Given
        request.params = {
            id: faker.string.uuid(),
            partition: faker.person.sex()
        }

        // When
        const answer = await sut(context, request)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(200)
    });
})