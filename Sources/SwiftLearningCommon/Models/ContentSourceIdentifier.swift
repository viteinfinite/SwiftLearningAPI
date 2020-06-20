import Foundation
import Fluent

public enum ContentSourceIdentifier: String, CaseIterable {
    case swiftBySundell

    public var contentSource: ContentSource {
        switch self {
        case .swiftBySundell: return ContentSource(id: rawValue, name: "Swift by Sundell", rssUrl: URL(string: "https://swiftbysundell.com/rss")!, podcastUrl: nil, playlistUrl: nil, websiteUrl: nil)
        }
    }
}

