import {AzureFunction, Context, HttpRequest} from "@azure/functions"
import {HttpResponse} from "../src/models/models";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<HttpResponse> {
    context.log('HTTP trigger function processed a request.');

    return {
        status: 200, /* Defaults to 200 */
        body: req.body
    };

};

export default httpTrigger;