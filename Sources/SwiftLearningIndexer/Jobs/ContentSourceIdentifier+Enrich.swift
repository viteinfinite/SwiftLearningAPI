import Foundation
import SwiftLearningCommon

extension ContentSourceIdentifier {
    func enrich(blogPost: InsertableBlogPost) -> InsertableBlogPost {
        switch self {
        case .swiftBySundell:
            var blogPost = blogPost
            blogPost.author = Author(name: "John Sundell")
            return blogPost
        }
    }
}
