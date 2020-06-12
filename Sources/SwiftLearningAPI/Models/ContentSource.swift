import Foundation
import Vapor
import Fluent

final class ContentSource: Model, Content {
    static let schema = "content_sources"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "rssUrl")
    var rssUrl: URL?

    @Field(key: "podcastUrl")
    var podcastUrl: URL?

    @Field(key: "playlistUrl")
    var playlistUrl: URL?

    @Field(key: "websiteUrl")
    var websiteUrl: URL?

    init() { }

    init(id: UUID? = nil, name: String, rssUrl: URL, websiteUrl: URL?) {
        self.id = id
        self.name = name
        self.rssUrl = rssUrl
        self.websiteUrl = websiteUrl
    }
}
