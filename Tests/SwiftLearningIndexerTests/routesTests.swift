import XCTest
import XCTVapor
import Fluent
import XCTFluent
import FluentKit
import XCTQueues
import Queues
import SwiftLearningCommon
@testable import SwiftLearningIndexer

struct RSSJob: Job {
    let promise: EventLoopPromise<[String]>

    func dequeue(_ context: QueueContext, _ data: [ContentSourceId]) -> EventLoopFuture<Void> {
        self.promise.succeed(data.map { $0.string })
        return context.eventLoop.makeSucceededFuture(())
    }

    func error(_ context: QueueContext, _ error: Error, _ data: [ContentSourceId]) -> EventLoopFuture<Void> {
        self.promise.fail(error)
        return context.eventLoop.makeSucceededFuture(())
    }
}

final class routesTests: XCTestCase {
    var app: Application!
    var rssJobMock: RSSJob!

    func configure(_ application: Application) throws {
        app.queues.use(.test)
        let promise = app.eventLoopGroup.next().makePromise(of: [String].self)
        rssJobMock = RSSJob(promise: promise)
        app.queues.add(rssJobMock)
        try routes(app)
    }

    override func setUp() {
        app = Application(.testing)
        try! configure(app)
    }

    override func tearDown() {
        app.shutdown()
    }

    func testGetRoot() {
        try! app.test(.GET, "") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertEqual(res.body.string, "indexer works!")
        }
    }

    func testGetStart_StartRSSJob() throws {
        try! app.test(.GET, "start")
        XCTAssertEqual(app.queues.test.queue.count, 1)
        XCTAssertEqual(app.queues.test.jobs.count, 1)
        try app.queues.queue.worker.run().wait()
        let expectedContentSourceIds = AllContentSourceProviders.contentSourceProviderById.keys.map { $0.string }
        try XCTAssertEqual(rssJobMock.promise.futureResult.wait(), expectedContentSourceIds)
    }

    static var allTests = [
        ("testGetRoot", testGetRoot),
        ("testGetStart", testGetStart_StartRSSJob),
    ]
}
