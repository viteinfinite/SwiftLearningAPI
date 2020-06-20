public struct IndexableBlogPost {
    public var author: Author?
    public var learningContent: LearningContent

    public init(author: Author?, learningContent: LearningContent) {
        self.author = author
        self.learningContent = learningContent
    }
}
