import {AzureFunction, Context, HttpRequest} from "@azure/functions"
import {HttpResponse} from "../src/models/models";
import {CosmosClient} from "@azure/cosmos";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<HttpResponse> {
    context.log('HTTP trigger function processed a request.');

    const options = {
        endpoint: process.env.COSMOSDB_ENDPOINT,
        key: process.env.COSMOSDB_KEY,
        userAgentSuffix: process.env.COSMOSDB_USER_AGENT_SUFFIX
    }

    try {

        const client = new CosmosClient(options)
        const {name} = req.query

        const querySpec = {
            query: `SELECT *
                    FROM ${process.env.COSMOSDB_CONTAINER_NAME} t
                    WHERE t.name = @name`,
            parameters: [{name: "@name", value: name}]
        };

        const {resources} = await client
            .database(process.env.COSMOSDB_DATABASE_NAME)
            .container(process.env.COSMOSDB_CONTAINER_NAME)
            .items.query(querySpec).fetchAll()

        return {
            status: 200,
            body: resources
        }

    } catch (e) {
        return {
            status: 500,
            body: {message: "Unable to query entries!", error: e.error}
        }
    }

};

export default httpTrigger;