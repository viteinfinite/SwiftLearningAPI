import Foundation
import Vapor
import Fluent

final class LearningContent: Model, Content {
    static let schema = "learning_contents"

    enum Kind: String, Codable {
        case blogPost
    }

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Siblings(through: LearningContentAuthor.self, from: \.$learningContent, to: \.$author)
    var authors: [Author]

    @Field(key: "kind")
    var kind: Kind

    @Field(key: "url")
    var url: URL

    @Parent(key: "source_id")
    var source: ContentSource

    init() { }

    init(id: UUID? = nil, title: String, /* authors: [Author], */ kind: Kind, url: URL, sourceId: UUID) {
        self.id = id
        self.title = title
        self.authors = authors
        self.kind = kind
        self.url = url
        self.$source.id = sourceId
    }
}
