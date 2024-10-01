
import SwiftUI

struct ContentView: View {
    @State private var iterations: Int = 0
    
    var body: some View {
        VStack {
            Text("Koch Snowflake")
                .font(.largeTitle)
                .padding()
            
            KochSnowflakeView(iterations: iterations)
                .stroke(Color.blue, lineWidth: 1)
                .frame(width: 300, height: 300)
            
            Text("Iterations: \(iterations)")
            Slider(value: $iterations.animation(), in: 0...5, step: 1)
                .padding()
        }
    }
}

struct KochSnowflakeView: Shape {
    var iterations: Int
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Define the initial equilateral triangle
        let size = min(rect.size.width, rect.size.height) * 0.8
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let p1 = CGPoint(x: center.x, y: center.y - size / 2)
        let p2 = CGPoint(x: center.x - size * sin(.pi / 3), y: center.y + size / 2)
        let p3 = CGPoint(x: center.x + size * sin(.pi / 3), y: center.y + size / 2)
        
        // Recursively draw each side of the triangle
        drawKochLine(from: p1, to: p2, iterations: iterations, in: &path)
        drawKochLine(from: p2, to: p3, iterations: iterations, in: &path)
        drawKochLine(from: p3, to: p1, iterations: iterations, in: &path)
        
        return path
    }
    
    // Recursive function to draw the Koch line
    func drawKochLine(from start: CGPoint, to end: CGPoint, iterations: Int, in path: inout Path) {
        if iterations == 0 {
            path.move(to: start)
            path.addLine(to: end)
        } else {
            let dx = (end.x - start.x) / 3
            let dy = (end.y - start.y) / 3
            
            let p1 = start
            let p2 = CGPoint(x: start.x + dx, y: start.y + dy)
            
            let midX = (start.x + end.x) / 2
            let midY = (start.y + end.y) / 2
            let distance = sqrt(dx * dx + dy * dy)
            let height = distance * sqrt(3) / 6
            
            let p3 = CGPoint(x: midX + height * (dy / distance), y: midY - height * (dx / distance))
            let p4 = CGPoint(x: start.x + 2 * dx, y: start.y + 2 * dy)
            let p5 = end
            
            // Recursively draw each section of the Koch line
            drawKochLine(from: p1, to: p2, iterations: iterations - 1, in: &path)
            drawKochLine(from: p2, to: p3, iterations: iterations - 1, in: &path)
            drawKochLine(from: p3, to: p4, iterations: iterations - 1, in: &path)
            drawKochLine(from: p4, to: p5, iterations: iterations - 1, in: &path)
        }
    }
}

@main
struct KochSnowflakeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
