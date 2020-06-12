import Foundation
import Vapor
import Fluent

final class LearningContentAuthor: Model {
    static let schema = "learning_content_author"
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "learning_content")
    var learningContent: LearningContent

    @Parent(key: "author")
    var author: Author

    init() { }

    init(learningContentId: UUID, authorId: UUID) {
        self.$learningContent.id = learningContentId
        self.$author.id = authorId
    }
}
