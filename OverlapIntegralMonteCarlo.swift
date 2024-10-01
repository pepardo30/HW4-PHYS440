
import Foundation
import Accelerate

// Constants for the orbital calculation
let pi = Double.pi
let boundingBoxSize = 10.0  // Bounding box for Monte Carlo integration
let numberOfGuesses = 100000  // Number of random samples for Monte Carlo

// 1s orbital wavefunction
func psi(_ r: Double) -> Double {
    return exp(-r) / sqrt(pi)
}

// Distance between two points
func distance(_ x1: Double, _ y1: Double, _ z1: Double, _ x2: Double, _ y2: Double, _ z2: Double) -> Double {
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2) + pow(z2 - z1, 2))
}

// Numerical calculation of the overlap integral using Monte Carlo method
func monteCarloOverlapIntegral(R: Double, guesses: Int, boundingBox: Double) -> Double {
    var sum = 0.0
    let halfBox = boundingBox / 2.0
    
    for _ in 0..<guesses {
        // Random coordinates within the bounding box for two points
        let x1 = Double.random(in: -halfBox...halfBox)
        let y1 = Double.random(in: -halfBox...halfBox)
        let z1 = Double.random(in: -halfBox...halfBox)
        
        let x2 = x1 + R
        let y2 = y1
        let z2 = z1
        
        // Calculate the radial distances from each nucleus
        let r1 = distance(0, 0, 0, x1, y1, z1)
        let r2 = distance(R, 0, 0, x2, y2, z2)
        
        // Calculate the product of wavefunctions at these points
        let psi1 = psi(r1)
        let psi2 = psi(r2)
        
        sum += psi1 * psi2
    }
    
    // Multiply by the volume of the bounding box to get the integral
    let volume = pow(boundingBox, 3)
    return (sum / Double(guesses)) * volume
}

// Analytical overlap integral for comparison
func analyticalOverlapIntegral(R: Double) -> Double {
    return (1 + R + (R * R) / 3) * exp(-R)
}

// Function to run the calculation and compare the results
func compareNumericalAndAnalytical() {
    let spacings = [0.5, 1.0, 2.0, 3.0, 5.0]  // Different values of R to explore
    let boundingBoxSizes = [10.0, 20.0, 50.0]
    
    for R in spacings {
        print("Interatomic Spacing R = \(R)")
        
        for boxSize in boundingBoxSizes {
            let numerical = monteCarloOverlapIntegral(R: R, guesses: numberOfGuesses, boundingBox: boxSize)
            let analytical = analyticalOverlapIntegral(R: R)
            print("Bounding Box: \(boxSize) -> Numerical: \(numerical), Analytical: \(analytical)")
        }
        
        print("----")
    }
}

// Run the comparison
compareNumericalAndAnalytical()
