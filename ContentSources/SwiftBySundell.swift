ContentSourceProvider(
    source: ContentSource(
        id: "swift-by-sundell",
        name: "Swift by Sundell",
        rssUrl: URL(string: "https://swiftbysundell.com/rss")!,
        podcastUrl: nil,
        playlistUrl: nil,
        websiteUrl: nil
    ),
    enrich: { blogPost -> IndexableBlogPost in
        var blogPost = blogPost
        blogPost.author = Author(name: "John Sundell")
        return blogPost
    }
)
