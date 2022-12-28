# APIClient

APIClient is a Swift package for interacting with RESTful APIs, relying on URLRequest under the hood, but providing a nicer API.

## Example usage
You can start by initializing an `APIClient`:
```swift
import APIClient

let client = APIClient()
```

Then a request:
```swift
let group = Group(host: "jsonplaceholder.typicode.com", path: "/")
let request: Request<Nothing, [User]> = group.endpoint(path: "users")
```
`Nothing` is the request's body, and `[User]` is the response

And finally you can make that request in three different ways:
1. Using async/await:
```swift
let result: Result<[User], Error> = await client.make(request: request)
    
switch result {
case .success(let users):
    print("Async: \(users.count)")
case .failure(let error):
    print(error)
}
```
2. Using Combine:
```swift
let cancellable = client.publisher(request: request).sink(
    receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            print(error)
        case .finished:
            break
        }
    },
    receiveValue: { (users: [User]) in
        print("Combine: \(users.count)")
    }
)
```
3. Using a completion handler:
```swift
client.make(request: request) { (result: Result<Response<[User]>, Error>) in
    switch result.map(\.data) {
    case .success(let users):
        print("Completion: \(users.count)")
    case .failure(let error):
        print(error)
    }
}
```
