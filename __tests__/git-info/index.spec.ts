import {describe, expect, test} from "@jest/globals";
import axios from 'axios';

describe('Get Git Info API', () => {

    test('should get info', async () => {

        // Given
        const url = "https://app-" + (process.env.NAMESPACE || "microtema-dev-westeurope-01") + ".azurewebsites.net/rest/api/products/git/info";

        // When
        const answer = await axios.get(url)

        // Then
        expect(answer).toBeDefined()
        expect(answer.status).toBe(200)

        expect(answer.data).toBeDefined()
        expect(answer.data).toEqual({})
    });
})