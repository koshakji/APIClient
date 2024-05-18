# APIClient

APIClient is a Swift package for interacting with RESTful APIs, relying on URLRequest under the hood, but providing a nicer API.

**Important Note:** This package is still not API-stable, and won't be until version `1.0.0` is released

## Example usage
You can start by initializing an `APIClient`:
```swift
import APIClient

let client = APIClient()
```

Then a request:
```swift
let users = Group(host: "jsonplaceholder.typicode.com", path: "/users")
let listUsers: Request<Nothing, [User], Nothing> = users.request(path: "/")
```
`Nothing` is the request's body, `[User]` is the successful response, `Nothing` is the error response. 

And finally you can make that request in three different ways:
1. Using async/await:
```swift
do {
    let response = try await client.make(request: listUsers)
    let users = response.data
    print("Async: \(users.count)")
} catch {
    print(error)
}
```
2. Using Combine:
```swift
let cancellable = client.publisher(request: listUsers)
    .map(\.data)
    .sink(
        receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        },
        receiveValue: { users in
            print("Combine: \(users.count)")
        }
    )
```
3. Using a completion handler:
```swift
client.make(request: listUsers) { (result: Result<Response<[User]>, Error>) in
    switch result.map(\.data) {
    case .success(let users):
        print("Completion: \(users.count)")
    case .failure(let error):
        print(error)
    }
}
```
