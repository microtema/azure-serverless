import {describe, expect, test} from "@jest/globals";
import axios from 'axios';
import {faker} from '@faker-js/faker';

describe('Create Entry API', () => {

    test('should create new entry', async () => {

        // Given
        const url = "https://" + process.env.NAMESPACE + ".azurewebsites.net/rest/api/products";
        console.log("url", url)
        const data = {
            name: faker.person.firstName(),
            cid: faker.string.uuid(),
            definition: {
                id: faker.person.sex()
            }
        }

        // When
        const answer = await axios.post(url, data)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(201)

        expect(answer.data.id).toBeDefined()
        expect(answer.data).toEqual({...data, ...{id: answer.data.id}})
    });
})