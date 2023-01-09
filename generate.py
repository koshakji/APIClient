def get_value(v):
    if v.startswith("Optional"):
        return "nil"
    else:
        return ".init()"

def get_when(body, headers, query):
    result = ""
    if body is None and headers is None and query is None:
        return "."
    else:
        result += " "
    if body is not None:
        result += "when body is `{}`".format(body)
    if headers is not None:
        if body is None:
            result += "when"
        else:
            result += ","
        result += " headers is `{}`".format(headers)
    if query is not None:
        if body is None and headers is None:
            result += "when"
        else:
            result += ","
        result += " queries is `{}`".format(query)
    result += "."
    return result
    
def get_make(body, headers, query):
    name = ""
    name += "/// Make an async API request{}".format(get_when(body, headers, query))
    name += """
        /// - Parameters:
        ///   - request: The request definition (includes URL, URL parameters and method).
    """
    
    if body is None:
        name += "///   - body: The request body, must match the body type of the request.\n"
    if headers is None:
        name += "///   - headers: The request HTTP headers, must match the headers type of the request.\n"
    if query is None:
        name += "///   - queries: The request URL queries, must match the queries type of the request.\n"
    
    name += "/// - Returns: A successful response (including HTTP headers, status and decoded response) or a failure with an error.\n"
    
    name += "func make<Request: RequestProtocol"
    if headers is not None and headers.startswith("Optional"):
        name += ", H"
    if query is not None and query.startswith("Optional"):
        name += ", Q"
    name += ">(request: Request"
    if body is None:
        name += ", body: Request.Body"
    if headers is None:
        name += ", headers: Request.Headers"
    if query is None:
        name += ", queries: Request.Queries"
    name += ") async -> Result<Response<Request.Response>, Error>"
    if any([body is not None, headers is not None, query is not None]):
        name += " where "
        if body is not None:
            name += " Request.Body == {}".format(body)
        if headers is not None:
            if body is not None:
                name += ","
            name += " Request.Headers == {}".format(headers)
        if query is not None:
            if body is not None or headers is not None:
                name += ","
            name += " Request.Queries == {}".format(query)
    name += " {\n"
    name += "return await make(request: request"

    name += ", body: {}".format("body" if body is None else get_value(body))
    name += ", headers: {}".format("headers" if headers is None else get_value(headers))
    name += ", queries: {}".format("queries" if query is None else get_value(query))
    
    name += ")\n }\n"
    return name
    
def get_publisher(body, headers, query):
    name = ""
    name += "///  Make a Combine-based API request{}".format(get_when(body, headers, query))
    name += """
        /// - Parameters:
        ///   - request: The request definition (includes URL, URL parameters and method).
    """
    
    if body is None:
        name += "///   - body: The request body, must match the body type of the request.\n"
    if headers is None:
        name += "///   - headers: The request HTTP headers, must match the headers type of the request.\n"
    if query is None:
        name += "///   - queries: The request URL queries, must match the queries type of the request.\n"
    
    name += "/// - Returns: A publisher that publishes a successful response (including HTTP headers, status and decoded response), or terminates if the task fails with an error.\n"
    name += "func publisher<Request: RequestProtocol"
    if headers is not None and headers.startswith("Optional"):
        name += ", H"
    if query is not None and query.startswith("Optional"):
        name += ", Q"
    name += ">(request: Request"
    if body is None:
        name += ", body: Request.Body"
    if headers is None:
        name += ", headers: Request.Headers"
    if query is None:
        name += ", queries: Request.Queries"
    name += ") -> AnyPublisher<Response<Request.Response>, Error>"
    if any([body is not None, headers is not None, query is not None]):
        name += " where "
        if body is not None:
            name += " Request.Body == {}".format(body)
        if headers is not None:
            if body is not None:
                name += ","
            name += " Request.Headers == {}".format(headers)
        if query is not None:
            if body is not None or headers is not None:
                name += ","
            name += " Request.Queries == {}".format(query)
    name += " {\n"
    name += "return publisher(request: request"

    name += ", body: {}".format("body" if body is None else get_value(body))
    name += ", headers: {}".format("headers" if headers is None else get_value(headers))
    name += ", queries: {}".format("queries" if query is None else get_value(query))
    
    name += ")\n }\n"
    return name


def get_completion(body, headers, query):
        name = ""
        name += "/// Make an completion-handled API request{}".format(get_when(body, headers, query))
        name += """
            /// - Parameters:
            ///   - request: The request definition (includes URL, URL parameters and method).
        """
    
        if body is None:
            name += "///   - body: The request body, must match the body type of the request.\n"
        if headers is None:
            name += "///   - headers: The request HTTP headers, must match the headers type of the request.\n"
        if query is None:
            name += "///   - queries: The request URL queries, must match the queries type of the request.\n"
        name += "///   - completion: The request completion handler..\n"
        name += "func make<Request: RequestProtocol"
        if headers is not None and headers.startswith("Optional"):
            name += ", H"
        if query is not None and query.startswith("Optional"):
            name += ", Q"
        name += ">(request: Request"
        if body is None:
            name += ", body: Request.Body"
        if headers is None:
            name += ", headers: Request.Headers"
        if query is None:
            name += ", queries: Request.Queries"
        name += ", completion: @escaping Completion<Request>)"
        if any([body is not None, headers is not None, query is not None]):
            name += " where "
            if body is not None:
                name += " Request.Body == {}".format(body)
            if headers is not None:
                if body is not None:
                    name += ","
                name += " Request.Headers == {}".format(headers)
            if query is not None:
                if body is not None or headers is not None:
                    name += ","
                name += " Request.Queries == {}".format(query)
        name += " {\n"
        name += "return make(request: request"

        name += ", body: {}".format("body" if body is None else get_value(body))
        name += ", headers: {}".format("headers" if headers is None else get_value(headers))
        name += ", queries: {}".format("queries" if query is None else get_value(query))
    
        name += ", completion: completion"
    
        name += ")\n }\n"
        return name
    
b = [None, "Nothing"]
q = [None, "Nothing", "Dictionary<String, String>", "Optional<Q>"]
h = [None, "Nothing", "Dictionary<String, String>", "Optional<H>"]

options = []

for body in b:
    for query in q:
        for header in h:
            options.append((body, header, query))

methods = [get_make(*items) for items in options]
for method in methods:
    print(method)