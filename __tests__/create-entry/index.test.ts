import {beforeEach, describe, expect, test} from "@jest/globals";
import {Context, HttpRequest} from "@azure/functions";
import {faker} from '@faker-js/faker';
import sut from "../../create-entry"
import {v4 as uuidv4} from "uuid";

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

describe('Create Entry API', () => {

    let context: Context;
    let request: HttpRequest;
    let body = {} as any

    beforeEach(() => {

        jest.resetModules() // Most important - it clears the cache

        // Really crude and unsafe implementations that will be replaced soon
        context = {
            log: jest.fn()
        } as unknown as Context;
        request = {body} as unknown as HttpRequest
    });

    test('should create new entry', async () => {

        // Given
        request.body = {
            name: faker.person.firstName(),
            cid: faker.string.uuid(),
            definition: {id: faker.person.sex()}
        }

        // When
        const answer = await sut(context, request)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(201)
        expect(answer.body.id).toBeDefined()
    });

    test('should override id on new entry', async () => {

        // Given
        request.body = {
            name: faker.person.firstName(),
            cid: faker.string.uuid(),
            definition: {id: faker.person.sex()},
            id: uuidv4()
        }

        // When
        const answer = await sut(context, request)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(201)
        expect(answer.body.id).toBeDefined()
        expect(answer.body.id).not.toBe(body.id)
    });
})