//
//  ContentView.swift
//  Sphere!
//
//  Created by João Gabriel Pozzobon dos Santos on 12/01/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimelineView(.animation) { thing in
            let dots = dotsForDisplace(displace: thing.date.timeIntervalSince1970)
                Canvas { context, size in
                    dots
                        .map { dot -> Dot in
                            var dot = dot
                            dot.position = CGPoint(x: dot.position.x*size.width/2+size.width/2,
                                                   y: dot.position.y*size.height/2+size.height/2)
                            return dot
                        }
                        .forEach {
                            let path = Path(ellipseIn: CGRect(x: $0.position.x-$0.size/2.0,
                                                              y: $0.position.y-$0.size/2.0,
                                                              width: $0.size, height: $0.size))
                            context.fill(path, with: .color(.white.opacity($0.opacity)))
                        }
                }
            }
        .padding()
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    func dotsForDisplace(displace: CGFloat) -> [Dot] {
        var dots = [Dot]()
        let points = 30.0
        for i in 0...2*Int(points) {
            for j in 0...Int(points) {
                let angle1 = (CGFloat(i)/points*CGFloat.pi+displace/2.0).truncatingRemainder(dividingBy: .pi*2)
                let angle2 = CGFloat(j)/points*CGFloat.pi
                
                let x = cos(angle2)
                let y = sin(angle2)*sin(angle1)
                
                var opacity = abs(angle1-CGFloat.pi)/CGFloat.pi
                opacity = opacity*(1-abs(angle2-CGFloat.pi/2.0)/CGFloat.pi*1.5)
                
                let dot = Dot(position: CGPoint(x: x, y: y), size: 5*opacity+1, opacity: opacity+0.25)
                dots.append(dot)
            }
        }
        return dots
    }
}

struct Dot {
    var position: CGPoint
    var size: CGFloat
    var opacity: CGFloat
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
