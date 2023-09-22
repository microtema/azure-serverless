import {AzureFunction, Context, HttpRequest} from "@azure/functions"
import {CosmosClient} from '@azure/cosmos'
import {v4 as uuidv4} from 'uuid';
import {HttpResponse} from "../src/models/models";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<HttpResponse> {
    context.log('HTTP trigger function processed a request.');

    const itemBody = {
        ...req.body, ...{
            id: uuidv4()
        }
    }

    const options = {
        endpoint: process.env.COSMOSDB_ENDPOINT,
        key: process.env.COSMOSDB_KEY,
        userAgentSuffix: process.env.COSMOSDB_USER_AGENT_SUFFIX
    };

    try {

        const client = new CosmosClient(options)

        const {item} = await client
            .database(process.env.COSMOSDB_DATABASE_NAME)
            .container(process.env.COSMOSDB_CONTAINER_NAME)
            .items.create(itemBody)

        return {
            status: 201,
            body: itemBody
        }

    } catch (e) {
        return {
            status: 500,
            body: {message: "Unable to create entry!", error: e.error}
        }
    }

};

export default httpTrigger;