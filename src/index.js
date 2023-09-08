module.exports = async (context, req) => {
    const status = 200
    const headers = {
        'content-type': 'text/html; charset=utf-8'
    }
    const body = 'Hello world today: '+ new Date()

    context.res = {
        status,
        headers,
        body,
    };
}