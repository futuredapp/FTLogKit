@testable import FTLogKit
import XCTest

final class MyLoggerTests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    private var logger: FTLogger!

    override func setUpWithError() throws {
        logger = try FTLogger(fileCapacity: 20)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        logger = nil
        try super.tearDownWithError()
    }

    override func tearDown() async throws {
        try setUpWithError()
        try await logger.logFileHandler?.removeFile()
        try tearDownWithError()
        try await super.tearDown()
    }

    func testCountLinesOnBlankFile() async throws {
        try await logger.logFileHandler?.removeFile()
        let numOfLines = try await logger.logFileHandler?.countLines() ?? -1
        XCTAssertEqual(numOfLines, 0)
    }

    func testMeasureWrites() async throws {
        try await logger.logFileHandler?.removeFile()
        let textMessage = Array(repeating: "X", count: 240).joined()
        measure {
            logger.info(textMessage)
        }
    }

    func testExample() async throws {
        try await logger.logFileHandler?.removeFile()
        let threeRows = "this is a test message\nwith exactly\nthree rows"
        for _ in 0..<4 {
            logger.info(threeRows)
        }
        try? await Task.sleep(nanoseconds: 20_000_000)
        let numOfLines = try await logger.logFileHandler?.countLines() ?? -1
        XCTAssertEqual(numOfLines, 12)
    }

    func testTruncation() async throws {
        try await logger.logFileHandler?.removeFile()

        logger.info("start")
        let testMessages = Array(0..<14)
            .map { "testMessage \($0)" }
        for message in testMessages {
            logger.info(message)
        }
        try? await Task.sleep(nanoseconds: 20_000_000)
        var numOfLines = try await logger.logFileHandler?.countLines() ?? -1
        XCTAssertEqual(numOfLines, 15)
        var optionalContent = try await logger.logFileHandler?.getContents()
        var content = try XCTUnwrap(optionalContent)
        XCTAssert(content.contains("start"))

        logger.info("middle")
        for message in testMessages {
            logger.info(message)
        }
        try? await Task.sleep(nanoseconds: 20_000_000)
        numOfLines = try await logger.logFileHandler?.countLines() ?? -1
        XCTAssertEqual(numOfLines, 30)
        optionalContent = try await logger.logFileHandler?.getContents()
        content = try XCTUnwrap(optionalContent)
        XCTAssert(content.contains("start"))
        XCTAssert(content.contains("middle"))

        logger.info("center")
        for message in testMessages {
            logger.info(message)
        }
        logger.info("end")
        try? await Task.sleep(nanoseconds: 20_000_000)
        numOfLines = try await logger.logFileHandler?.countLines() ?? -1
        XCTAssertEqual(numOfLines, 26)
        optionalContent = try await logger.logFileHandler?.getContents()
        content = try XCTUnwrap(optionalContent)
        XCTAssert(!content.contains("start"))
        XCTAssert(!content.contains("middle"))
        XCTAssert(content.contains("center"))
        XCTAssert(content.contains("end"))
    }
}
