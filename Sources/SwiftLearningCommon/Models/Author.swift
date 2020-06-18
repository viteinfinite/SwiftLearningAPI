import Foundation
import Vapor
import Fluent

public final class Author: Model {
    public static let schema = "authors"

    public static func schemaBuilder(for database: Database) -> SchemaBuilder {
        database.schema(schema)
            .id()
            .field("name", .string)
    }

    @ID(key: .id)
    public var id: UUID?

    @Field(key: "name")
    public var name: String

    @Siblings(through: LearningContentAuthor.self, from: \.$author, to: \.$learningContent)
    public var learningContent: [LearningContent]

    public init() { }

    public init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
