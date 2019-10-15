# GithubSearch
Implementation of Github Search api.

### GithubSearch API

#### Search all repositories with matching query and filter by organisation:

```swift
GithubSearch().searchRepositories(matching: "android", filterBy: "rakutentech") { (response, error) in
if let response = response {

} else {
print(error ?? "")
}
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

GithubSearch API is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'GithubSearch'
```

## Requirements

* Xcode 9 or later
* iOS 9.0 or later
* macOS 10.12 or later

## Author

Chandran Sudha, sudhachandran1bc@gmail.com

## License

GithubSearch API is available under the MIT license. See the LICENSE file for more info.
