import Foundation
import Fluent

public enum ContentSourceIdentifier: String, CaseIterable, Codable {
    case swiftBySundell

    public var contentSource: ContentSource {
        switch self {
        case .swiftBySundell: return ContentSource(id: rawValue, name: "Swift by Sundell", rssUrl: URL(string: "https://swiftbysundell.com/rss")!, podcastUrl: nil, playlistUrl: nil, websiteUrl: nil)
        }
    }

    public func enrich(blogPost: IndexableBlogPost) -> IndexableBlogPost {
        switch self {
        case .swiftBySundell:
            var blogPost = blogPost
            blogPost.author = Author(name: "John Sundell")
            return blogPost
        }
    }
}

