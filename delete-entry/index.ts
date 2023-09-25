import {AzureFunction, Context, HttpRequest} from "@azure/functions"
import {CosmosClient} from '@azure/cosmos'
import {HttpResponse} from "../src/models/models";


const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<HttpResponse> {
    context.log('HTTP trigger function processed a request.');

    const options = {
        endpoint: process.env.COSMOSDB_ENDPOINT,
        key: process.env.COSMOSDB_KEY,
        userAgentSuffix: process.env.COSMOSDB_USER_AGENT_SUFFIX
    };

    try {

        const client = new CosmosClient(options)
        const {id, partition} = req.params


        await client
            .database(process.env.COSMOSDB_DATABASE_NAME)
            .container(process.env.COSMOSDB_CONTAINER_NAME)
            .item(id, partition)
            .delete()


        return {
            status: 200
        }

    } catch (e) {
        return {
            status: 500,
            body: {message: "Unable to delete entry!", error: e.error}
        }
    }
};

export default httpTrigger;