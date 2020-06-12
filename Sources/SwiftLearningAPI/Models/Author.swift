import Foundation
import Vapor
import Fluent

final class Author: Model {
    static let schema = "authors"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Siblings(through: LearningContentAuthor.self, from: \.$author, to: \.$learningContent)
    var learningContent: [LearningContent]

    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
