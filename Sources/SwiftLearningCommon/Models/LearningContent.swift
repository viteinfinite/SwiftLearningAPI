import Foundation
import Vapor
import Fluent

public final class LearningContent: Model, Content {
    public static let schema = "learning_contents"

    public static func schemaBuilder(for database: Database, kind: DatabaseSchema.DataType) -> SchemaBuilder {
        database.schema(schema)
            .id()
            .field("title", .string)
            .field("kind", kind, .required)
            .field("url", .json).unique(on: "url")
            .field("source_id", .string, .references("content_sources", "id"))
    }

    public enum Kind: String, Codable {
        case blogPost
        case podcastEpisode
        case video

        public static func schemaBuilder(for database: Database) -> EnumBuilder {
            database.enum("learning_content_kind")
                .case("blogPost")
                .case("podcastEpisode")
                .case("video")
        }
    }

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "title")
    public var title: String

    @Siblings(through: LearningContentAuthor.self, from: \.$learningContent, to: \.$author)
    public var authors: [Author]

    @Enum(key: "kind")
    public var kind: Kind

    @Field(key: "url")
    public var url: URL

    @Parent(key: "source_id")
    public var source: ContentSource

    public init() { }

    public init(id: UUID? = nil, title: String, kind: Kind, url: URL, sourceId: ContentSourceId) {
        self.id = id
        self.title = title
        self.kind = kind
        self.url = url
        self.$source.id = sourceId
    }
}
