import Foundation
import Vapor
import Fluent

public typealias AuthorId = Identifier<Author>

public final class Author: Model, Hashable {
    public static let schema = "authors"

    public static func schemaBuilder(for database: Database) -> SchemaBuilder {
        database.schema(schema)
            .field("id", .string, .identifier(auto: false))
            .field("name", .string)
    }

    @ID(custom: "id", generatedBy: .user)
    public var id: AuthorId?

    @Field(key: "name")
    public var name: String

    @Siblings(through: LearningContentAuthor.self, from: \.$author, to: \.$learningContent)
    public var learningContent: [LearningContent]

    public init() { }

    public init(name: String) {
        self.id = AuthorId(name.lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .joined(separator: "-")
        )
        self.name = name
    }

    public static func == (lhs: Author, rhs: Author) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
