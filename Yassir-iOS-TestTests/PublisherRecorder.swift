import Combine
import XCTest

final class PublisherRecorder<Value, Failure: Error>: Subscriber {
    private var subscription: (any Subscription)?
    private let expectation = XCTestExpectation(description: "All values received")
    private let waiter = XCTWaiter()
    
    private var shouldStopRecording: Bool { numberOfValues == values.count }
    
    private var values: [Value] = [] {
        didSet {
            if shouldStopRecording {
                expectation.fulfill()
            }
        }
    }
    
    private let numberOfValues: Int
    
    init(numberOfValues: Int) {
        self.numberOfValues = numberOfValues
    }
    
    public func record(
        timeout: TimeInterval = 5,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> [Value] {
        defer { subscription?.cancel() }
        let result = waiter.wait(for: [expectation], timeout: timeout)
        if result != .completed {
            XCTFail(
                "Timeout, expected \(numberOfValues) record(s) but got \(values.count) instead",
                file: file,
                line: line
            )
        }
        
        return values
    }
    
    func receive(_ input: Value) -> Subscribers.Demand {
        values.append(input)
        return .unlimited
    }
    
    func receive(subscription: any Subscription) {
        self.subscription = subscription
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        // No-op
    }
}

extension Publisher {
    func recorder(count: Int) -> PublisherRecorder<Output, Failure> {
        let recorder = PublisherRecorder<Output, Failure>(numberOfValues: count)
        subscribe(recorder)
        return recorder
    }
}
