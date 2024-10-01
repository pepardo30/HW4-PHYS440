
import XCTest

// Test class for Overlap Integral Monte Carlo Simulation
final class OverlapIntegralTests: XCTestCase {
    
    // Test the numerical overlap integral for a simple case with known result (R = 0)
    func testNumericalOverlapIntegralAtZero() {
        let result = monteCarloOverlapIntegral(R: 0.0, guesses: 10000, boundingBox: 10.0)
        let expectedResult = analyticalOverlapIntegral(R: 0.0)
        
        XCTAssertEqual(result, expectedResult, accuracy: 0.01, "The numerical result should match the analytical result for R = 0.")
    }
    
    // Test the numerical overlap integral at different values of R
    func testNumericalOverlapIntegralAtDifferentR() {
        let RValues = [0.5, 1.0, 2.0, 3.0, 5.0]
        
        for R in RValues {
            let numericalResult = monteCarloOverlapIntegral(R: R, guesses: 10000, boundingBox: 10.0)
            let analyticalResult = analyticalOverlapIntegral(R: R)
            
            XCTAssertEqual(numericalResult, analyticalResult, accuracy: 0.05, "Numerical and analytical results should be close for R = \(R).")
        }
    }
    
    // Test the effect of changing the bounding box size on the numerical result
    func testBoundingBoxEffect() {
        let R = 2.0
        let boundingBoxSizes = [10.0, 20.0, 50.0]
        
        for boxSize in boundingBoxSizes {
            let numericalResult = monteCarloOverlapIntegral(R: R, guesses: 10000, boundingBox: boxSize)
            let analyticalResult = analyticalOverlapIntegral(R: R)
            
            XCTAssertEqual(numericalResult, analyticalResult, accuracy: 0.05, "Numerical result should still be close to the analytical one for bounding box size \(boxSize).")
        }
    }
    
    // Test the effect of increasing the number of Monte Carlo samples
    func testNumberOfGuessesEffect() {
        let R = 2.0
        let guessesList = [1000, 10000, 100000]
        
        for guesses in guessesList {
            let numericalResult = monteCarloOverlapIntegral(R: R, guesses: guesses, boundingBox: 10.0)
            let analyticalResult = analyticalOverlapIntegral(R: R)
            
            XCTAssertEqual(numericalResult, analyticalResult, accuracy: 0.05, "With \(guesses) guesses, the numerical result should be accurate.")
        }
    }
}

// Run the tests
OverlapIntegralTests.defaultTestSuite.run()
