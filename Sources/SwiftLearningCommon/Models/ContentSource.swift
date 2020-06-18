import Foundation
import Vapor
import Fluent

public final class ContentSource: Model, Content {
    public static let schema = "content_sources"

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "name")
    public var name: String

    @Field(key: "rss_url")
    public var rssUrl: URL?

    @Field(key: "podcast_url")
    public var podcastUrl: URL?

    @Field(key: "playlist_url")
    public var playlistUrl: URL?

    @Field(key: "website_url")
    public var websiteUrl: URL?

    @Children(for: \.$source)
    public var contents: [LearningContent]

    public init() { }

    public init(id: UUID? = nil, name: String, rssUrl: URL?, podcastUrl: URL?, playlistUrl: URL?, websiteUrl: URL?) {
        self.id = id
        self.name = name
        self.rssUrl = rssUrl
        self.podcastUrl = podcastUrl
        self.websiteUrl = websiteUrl
    }
}
