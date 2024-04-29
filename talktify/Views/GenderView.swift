//
//  ContentView.swift
//  NanoTest
//
//  Created by Felix Laurent on 28/04/24.
//

import SwiftUI

struct GenderView: View {
    @State var isClickedMan = false
    @State var isClickedWoman = false
    @State var isSubmitClicked = false
    
    var body: some View {
        ZStack {
            backgroundColor()
            
            VStack {
                Spacer()
                
                HStack{
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.isClickedMan.toggle()
                            isClickedWoman = false
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(isClickedMan ? Color.white : Color.blue)
                                .frame(width: isClickedMan ? 150 : 130, height: isClickedMan ? 150 : 130)
                                .opacity(isClickedWoman ? 0 : 1.0)
                            Text("👨️")
                                .font(.system(size: isClickedMan ? 100 : 75))
                                .opacity(isClickedWoman ? 0.5 : 1.0)
                        }
                    }
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            self.isClickedWoman.toggle()
                            isClickedMan = false
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(isClickedWoman ? Color.white : Color.pink)
                                .frame(width: isClickedWoman ? 150 : 130, height: isClickedWoman ? 150 : 130)
                                .opacity(isClickedMan ? 0 : 1.0)
                            Text("👩")
                                .font(.system(size: isClickedWoman ? 100 : 75))
                                .opacity(isClickedMan ? 0.5 : 1.0)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    isSubmitClicked.toggle()
                }) {
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 40).bold())
                        .frame(width: 275, height: 70)
                        .foregroundColor(buttonForegroundColor())
                        .background(buttonColor())
                        .cornerRadius(45)
                }.padding(.bottom)
            }
        }
    }
    
    func backgroundColor() -> some View {
        if isClickedMan {
            Color.blue.edgesIgnoringSafeArea(.all)
        } else if isClickedWoman {
            Color.pink.edgesIgnoringSafeArea(.all)
        } else {
            Color.white.edgesIgnoringSafeArea(.all)
        }
    }
    
    func buttonColor() -> Color{
        if isClickedMan || isClickedWoman{
            return Color.white
        } else {
            return Color.gray
        }
    }
    
    func buttonForegroundColor() -> Color{
        if isClickedMan {
            return Color.blue
        } else if isClickedWoman {
            return Color.pink
        } else {
            return Color.white
        }
    }
    
}

#Preview {
    GenderView()
}
