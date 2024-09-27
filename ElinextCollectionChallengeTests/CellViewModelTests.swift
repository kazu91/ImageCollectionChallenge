//
//  CellViewModelTests.swift
//  ElinextCollectionChallengeTests
//
//  Created by Kazu on 28/9/24.
//

import Foundation
import XCTest

class CellViewModelTests: XCTestCase {
    var viewModel: CellViewModel!

    override func setUp() {
        super.setUp()
        ImageCache.shared.clearCache()
        viewModel = CellViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testDownloadImageReturnsCachedImage() async {
        let expectedImage = UIImage(systemName: "photo")!
        
        ImageCache.shared.setImage(expectedImage, forKey: viewModel.cacheKey)

        viewModel.downloadImage { image in
            XCTAssertEqual(image, expectedImage, "Should return the cached image.")
        }
        
    }
    
    func testDownloadImageWhenNetworkRequestSucceedsShouldReturnDownloadedImage() {
        let testImageData = UIImage(systemName: "photo")!.pngData()!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, testImageData)
        }
        
        viewModel.downloadImage { image in
            // Assert: Verify that we receive the downloaded image
            XCTAssertNotNil(image)
            XCTAssertEqual(image.pngData(), testImageData)
        }
    }
    
    func testDownloadImageWhenNetworkRequestFailsShouldReturnPlaceholderImage() {
        // Arrange: Simulate network failure
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }
        
        
        viewModel.downloadImage { image in
            // Assert: Check if placeholder image is returned
            XCTAssertEqual(image, UIImage(systemName: "photo") ?? UIImage())
        }
    }
}
