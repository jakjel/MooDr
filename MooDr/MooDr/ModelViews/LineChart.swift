import SwiftUI


struct LineChart: View {
    var dataPoints: [Double]
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let xScale = geometry.size.width / CGFloat(dataPoints.count - 1)
                let yScale = geometry.size.height / CGFloat(dataPoints.max()! - dataPoints.min()!)
                path.move(to: .init(x: 0, y: geometry.size.height - CGFloat(dataPoints[0] - dataPoints.min()!) * yScale))
                for index in dataPoints.indices {
                    path.addLine(to: .init(x: CGFloat(index) * xScale, y: geometry.size.height - CGFloat(dataPoints[index] - dataPoints.min()!) * yScale))
                }
            }
            .stroke(Color.blue, lineWidth: 2)
        }
    }
}
