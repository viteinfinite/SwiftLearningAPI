import Foundation
import Fluent

public struct ContentSourceProvider {
    public let source: ContentSource
    public let enrich: (IndexableBlogPost) -> IndexableBlogPost
}
