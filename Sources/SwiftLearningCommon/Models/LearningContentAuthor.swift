import Foundation
import Vapor
import Fluent

public final class LearningContentAuthor: Model {
    public static let schema = "learning_content_author"

    public static func schemaBuilder(for database: Database) -> SchemaBuilder {
        database.schema(schema)
            .id()
            .field("learning_content_id", .uuid, .required, .references("learning_contents", "id"))
            .field("author_id", .string, .required, .references("authors", "id"))
    }

    @ID(key: .id)
    public var id: UUID?

    @Parent(key: "learning_content_id")
    public var learningContent: LearningContent

    @Parent(key: "author_id")
    public var author: Author

    public init() { }

    public init(learningContentId: UUID, authorId: AuthorId) {
        self.$learningContent.id = learningContentId
        self.$author.id = authorId
    }
}
