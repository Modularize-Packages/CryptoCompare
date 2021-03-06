import XCTest
import RxSwift
@testable import CryptoCompare

final class CryptoCompareTests: XCTestCase {
    
    private let bag = DisposeBag()
    
    func testFetchingMarket() throws {
        
        let expectation = XCTestExpectation(description: "Fetching Market info failure")
        
        CryptoCompare.shared
            .fetch(.market(fsyms: ["BTC", "ETH"], tsyms: ["USD"]))
            .subscribe { market in
                print(market)
                expectation.fulfill()
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        wait(for: [expectation], timeout: TimeInterval(50))
    }
    
    func testSubscribeMarket() throws {
        
        let expectation = XCTestExpectation(description: "Subscribe Market info failure")
        let syms: [(String, String)] = [
            (fsym: "BTC", tsym: "USD")
        ]

        CryptoCompare
            .shared
            .subscribe(.market(syms: syms))
            .subscribe { data in
                if let market = try? JSONDecoder().decode(CryptoCompare.Market.self, from: data) {
                    print(market)
                }
//                expectation.fulfill()
            } onError: { error in
                print(error.localizedDescription)
            }
            .disposed(by: bag)
        
        CryptoCompare.shared.connect()
        

//        sleep(5)
//
//        CryptoCompare
//            .shared
//            .unsubscribe(.market(syms: syms))
//            .subscribe()
//            .disposed(by: bag)
        
        wait(for: [expectation], timeout: TimeInterval(10000))
    }
}
