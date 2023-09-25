import {describe, expect, test} from "@jest/globals";
import axios from 'axios';
import {faker} from '@faker-js/faker';

describe('Delete Entry API', () => {

    const url = "https://app-" + (process.env.NAMESPACE || "microtema-dev-westeurope-01") + ".azurewebsites.net/rest/api/products";

    test('should delete entry', async () => {

        // Given
        const data = {
            name: faker.person.firstName(),
            cid: faker.string.uuid(),
            definition: {
                id: faker.person.sex()
            }
        }

        // When
        let answer = await axios.post(url, data)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(201)

        expect(answer.data.id).toBeDefined()
        expect(answer.data).toEqual({...data, ...{id: answer.data.id}})

        // When
        answer = await axios.delete(url + "/" + answer.data.id + "/" + data.definition.id)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(200)
    });
})