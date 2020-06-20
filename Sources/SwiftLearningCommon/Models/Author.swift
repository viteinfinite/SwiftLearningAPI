import Foundation
import Vapor
import Fluent

public final class Author: Model {
    public static let schema = "authors"

    public static func schemaBuilder(for database: Database) -> SchemaBuilder {
        database.schema(schema)
            .field("id", .string, .identifier(auto: false)).ignoreExisting()
            .field("name", .string)
    }

    @ID(custom: "id", generatedBy: .user)
    public var id: String?

    @Field(key: "name")
    public var name: String

    @Siblings(through: LearningContentAuthor.self, from: \.$author, to: \.$learningContent)
    public var learningContent: [LearningContent]

    public init() { }

    public init(name: String) {
        self.id = name
            .lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .joined(separator: "-")
        self.name = name
    }
}
