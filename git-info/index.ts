import {AzureFunction, Context, HttpRequest} from "@azure/functions"
import {HttpResponse} from "../src/models/models";

const httpTrigger: AzureFunction = async function (context: Context, req: HttpRequest): Promise<HttpResponse> {
    context.log('HTTP trigger function processed a request.');

    return {
        status: 200,
        body: {"commitId": process.env.COMMIT_ID, "branch": process.env.VERSION}
    }

};

export default httpTrigger;