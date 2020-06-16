import Foundation
import Fluent

enum ContentSourceItem {
    static let swiftBySundell = ContentSource(id: UUID(), name: "Swift by Sundell", rssUrl: URL(string: "https://swiftbysundell.com/rss")!, podcastUrl: nil, playlistUrl: nil, websiteUrl: nil)

    static var all: [ContentSource] {
        [swiftBySundell]
    }
}
