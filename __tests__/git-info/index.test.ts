import {beforeEach, describe, expect, test} from "@jest/globals";
import {Context, HttpRequest} from "@azure/functions";
import {faker} from '@faker-js/faker';
import sut from "../../git-info"

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

describe('Git info API', () => {

    let context: Context;
    let request: HttpRequest;
    let body = {} as any

    process.env = {
        COMMIT_ID: faker.string.uuid(),
        VERSION: faker.string.uuid()
    }

    beforeEach(() => {

        jest.resetModules() // Most important - it clears the cache

        // Really crude and unsafe implementations that will be replaced soon
        context = {
            log: jest.fn()
        } as unknown as Context;
        request = {body} as unknown as HttpRequest
    });

    test('should get git info', async () => {

        // Given

        // When
        const answer = await sut(context, request)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(200)
        expect(answer.body).toEqual({"commitId": process.env.COMMIT_ID, "branch": process.env.VERSION})
    });
})