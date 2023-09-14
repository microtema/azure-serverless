import {AzureFunction, Context, HttpRequest} from "@azure/functions"
import {CosmosClient} from '@azure/cosmos'
import {v4 as uuidv4} from 'uuid';
import {HttpResponse} from "../src/models/models";

const config = {
    endpoint: 'https://account-microtema-dev-westeurope-01.documents.azure.com:443/',
    key: 'pQkgzYWJwheM56IKzpwh2diItm1gcYIOFPIZraZGEgV5RdwbpXk3eGBjhkxaYQU9LiPnfb6wJ7QvACDbk7uGOg==',
    database: 'db-microtema-dev-westeurope-01',
    container: 'container-microtema-dev-westeurope-01',
}

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<HttpResponse> {
    context.log('HTTP trigger function processed a request.');

    const itemBody = {
        ...req.body, ...{
            id: uuidv4()
        }
    }

    const options = {
        endpoint: config.endpoint,
        key: config.key,
        userAgentSuffix: 'microtema'
    };

    const client = new CosmosClient(options)

    const {item} = await client
        .database(config.database)
        .container(config.container)
        .items.create(itemBody)

    return {
        status: 201,
        body: item
    };

};

export default httpTrigger;