import Foundation
import Vapor
import Fluent

public final class LearningContentAuthor: Model {
    public static let schema = "learning_content_author"
    @ID(key: .id)
    public var id: UUID?

    @Parent(key: "learning_content")
    public var learningContent: LearningContent

    @Parent(key: "author")
    public var author: Author

    public init() { }

    public init(learningContentId: UUID, authorId: UUID) {
        self.$learningContent.id = learningContentId
        self.$author.id = authorId
    }
}
