import Foundation
import Fluent

public enum ContentSourceItem {
    public static let swiftBySundell = ContentSource(id: UUID(), name: "Swift by Sundell", rssUrl: URL(string: "https://swiftbysundell.com/rss")!, podcastUrl: nil, playlistUrl: nil, websiteUrl: nil)

    public static var all: [ContentSource] {
        [swiftBySundell]
    }
}
