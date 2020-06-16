import Foundation
import Vapor
import Fluent

final class ContentSource: Model, Content {
    static let schema = "content_sources"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "rss_url")
    var rssUrl: URL?

    @Field(key: "podcast_url")
    var podcastUrl: URL?

    @Field(key: "playlist_url")
    var playlistUrl: URL?

    @Field(key: "website_url")
    var websiteUrl: URL?

    @Children(for: \.$source)
    var contents: [LearningContent]

    init() { }

    init(id: UUID? = nil, name: String, rssUrl: URL?, podcastUrl: URL?, playlistUrl: URL?, websiteUrl: URL?) {
        self.id = id
        self.name = name
        self.rssUrl = rssUrl
        self.podcastUrl = podcastUrl
        self.websiteUrl = websiteUrl
    }
}
