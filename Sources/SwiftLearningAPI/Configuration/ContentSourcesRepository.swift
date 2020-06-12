import Foundation
import Fluent

enum ContentSourceItem {
    static let swiftBySundell = ContentSource(name: "Swift by Sundell", rssUrl: URL(string: "https://swiftbysundell.com/rss")!, websiteUrl: URL(string: "https://www.swiftbysundell.com/"))

    static var all: [ContentSource] {
        [swiftBySundell]
    }
}
