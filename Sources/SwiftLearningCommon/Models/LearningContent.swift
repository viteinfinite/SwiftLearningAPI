import Foundation
import Vapor
import Fluent

public final class LearningContent: Model, Content {
    public static let schema = "learning_contents"

    public enum Kind: String, Codable {
        case blogPost
    }

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "title")
    public var title: String

//    @Siblings(through: LearningContentAuthor.self, from: \.$learningContent, to: \.$author)
//    var authors: [Author]

    @Field(key: "kind")
    public var kind: Kind

    @Field(key: "url")
    public var url: URL

    @Parent(key: "source_id")
    public var source: ContentSource

    public init() { }

    public init(id: UUID? = nil, title: String, /* authors: [Author], */ kind: Kind, url: URL, sourceId: UUID) {
        self.id = id
        self.title = title
//        self.authors = authors
        self.kind = kind
        self.url = url
        self.$source.id = sourceId
    }
}
