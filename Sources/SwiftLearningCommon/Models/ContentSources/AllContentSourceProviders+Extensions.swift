import Foundation

public extension AllContentSourceProviders {
    static var contentSourceProviderById: [String : ContentSourceProvider] {
        var result = [String : ContentSourceProvider]()
        for contentSourceProvider in allContentSourceProviders {
            guard let id = contentSourceProvider.source.id else {
                fatalError("ContentSource \(contentSourceProvider) has no id")
            }
            guard result[id] == nil else {
                fatalError("ContentSource with id \(id) already exists")
            }
            result[id] = contentSourceProvider
        }
        return result
    }
}
