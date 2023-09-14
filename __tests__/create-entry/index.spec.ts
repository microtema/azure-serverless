import {describe, expect, test, beforeEach} from "@jest/globals";
import {Context, HttpRequest} from "@azure/functions";
import {v4 as uuidv4} from 'uuid';
import {faker} from '@faker-js/faker';
import sut from "../../create-entry"

describe('Create Entry API', () => {

    let context: Context;
    let request: HttpRequest;
    let body = {} as any

    beforeEach(() => {
        // Really crude and unsafe implementations that will be replaced soon
        context = {
            log: () => {
            }
        } as unknown as Context;
        request = {body} as unknown as HttpRequest;
    });

    test('should create new entry', async () => {

        // Given
        body = {name: faker.person.firstName(), definition: {id: faker.person.sex()}}

        // When
        const answer = await sut(context, request)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(201)
        expect(answer.body.id).toBeDefined()
    });
})