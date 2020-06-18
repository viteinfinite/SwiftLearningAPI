import Foundation
import Vapor
import Fluent

public final class ContentSource: Model, Content {
    public static let schema = "content_sources"

    public static func schemaBuilder(for database: Database) -> SchemaBuilder {
        database.schema(schema)
            .field("id", .string, .identifier(auto: false))
            .field("name", .string)
            .field("rss_url", .json)
            .field("podcast_url", .json)
            .field("playlist_url", .json)
            .field("website_url", .json)
    }

    @ID(custom: "id", generatedBy: .user)
    public var id: String?

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

    public init(id: String, name: String, rssUrl: URL?, podcastUrl: URL?, playlistUrl: URL?, websiteUrl: URL?) {
        self.id = id
        self.name = name
        self.rssUrl = rssUrl
        self.podcastUrl = podcastUrl
        self.playlistUrl = playlistUrl
        self.websiteUrl = websiteUrl
    }
}
