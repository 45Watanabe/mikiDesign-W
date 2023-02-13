//
//  TitleView.swift
//  mikiDesign W
//
//  Created by 渡辺幹 on 2022/08/15.
//

import SwiftUI


struct TitleView: View {
    @StateObject var manager = AnimationManager()
    @ObservedObject var dispManager: DispManager = .dispManager
    var body: some View {
        ZStack {
            Image("darkBlue")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            ForEach(manager.randomShapes){ status in
                Rectangle()
                    .foregroundColor(status.color)
                    .frame(width: status.size.width,
                           height: status.size.height)
                    .position(status.position)
                    .rotationEffect(Angle(degrees: status.rotation))
            }
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(Color.white.opacity(0.1))
                .onTapGesture {
                    manager.roop = false
                    dispManager.display = "Home"
                }
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: phone.w/1.5, height: phone.w/1.5)
                    .opacity(manager.titleOpacity)
                
                Text("Design Piero")
                    .font(.custom("Academy Engraved LET", size: 30))
                    .foregroundColor(Color.white)
                    .shadow(color: Color.white, radius: 1, x: 2, y: 3)
                
                
            }
        }
    }
}

class AnimationManager: ObservableObject {
    @Published var randomShapes: [useTitleShape] = []
    @Published var titleOpacity = 0.0
    var roop = true
    
    init() {
        fadein()
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.addRndomShape()
        }
    }
    
    func fadein() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if self.titleOpacity < 1.0 {
                self.titleOpacity += 0.05
                self.fadein()
            }
        }
    }
    
    func addRndomShape() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if self.roop {
                self.createRandomShape()
                self.addRndomShape()
            }
        }
    }
    
    let colorList: [Color] = [.red, .green, .blue, .pink, .gray, .white, .cyan,
                              .mint, .orange, .purple, .yellow, .black]
    func createRandomShape() {
        if randomShapes.count > 100 {
            randomShapes.removeFirst()
        }
        let randomShape: useTitleShape = useTitleShape(
            color: colorList.randomElement()!,
            size: CGSize(width: phone.w/CGFloat(Int.random(in: 1...10)),
                         height: phone.w/CGFloat(Int.random(in: 1...10))),
            position: CGPoint(x: CGFloat.random(in: 0...phone.w),
                              y: CGFloat.random(in: 0...phone.h)),
            rotation: Double.random(in: 0...180))
        
        randomShapes.append(randomShape)
    }
}

struct useTitleShape: Identifiable {
    var id = UUID().uuidString
    var color: Color
    var size: CGSize
    var position: CGPoint
    var rotation: Double
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
