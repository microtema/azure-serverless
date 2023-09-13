import {AzureFunction, Context, HttpRequest} from "@azure/functions"
import {HttpResponse} from "../src/models/models";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<HttpResponse> {
    context.log('HTTP trigger function processed a request.');

    const name = req.query.name;
    const responseMessage = "Query Entity: " + name;

    return {
        status: 200, /* Defaults to 200 */
        body: responseMessage
    };

};

export default httpTrigger;