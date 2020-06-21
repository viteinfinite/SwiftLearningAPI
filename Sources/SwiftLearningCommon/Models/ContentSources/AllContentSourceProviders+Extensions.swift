import Foundation

public extension AllContentSourceProviders {
    static var contentSourceProviderById: [ContentSourceId : ContentSourceProvider] {
        var result = [ContentSourceId : ContentSourceProvider]()
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
