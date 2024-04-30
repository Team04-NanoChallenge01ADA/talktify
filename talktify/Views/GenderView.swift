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
        NavigationStack {
            ZStack {
                backgroundColor()
                
                VStack {
                    Spacer()
                    
                    HStack(spacing: 20){
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                self.isClickedMan.toggle()
                                isClickedWoman = false
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(isClickedMan ? .white : .blue200)
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
                                    .fill(isClickedWoman ? .white : .pink200)
                                    .frame(width: isClickedWoman ? 150 : 130, height: isClickedWoman ? 150 : 130)
                                    .opacity(isClickedMan ? 0 : 1.0)
                                Text("👩")
                                    .font(.system(size: isClickedWoman ? 100 : 75))
                                    .opacity(isClickedMan ? 0.5 : 1.0)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    ZStack{
                        NavigationLink(destination: PersonalityView()){
                            EmptyView()
                        }.navigationDestination(isPresented: $isSubmitClicked) {
                            PersonalityView().toolbarRole(.editor)
                        }
                        

                        Button(action: {
                            isSubmitClicked.toggle()
                            
                            AIModel.sharedInstance().gender = isClickedMan
                            ? AIGenderEnum.male
                            : AIGenderEnum.female
                        }) {
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 40).bold())
                                .frame(width: 275, height: 70)
                                .foregroundColor(buttonForegroundColor())
                                .background(buttonColor())
                                .cornerRadius(45)
                        }.padding(.bottom).disabled(!(isClickedMan || isClickedWoman))
                    }
                    
                }
            }
        }.toolbar(.hidden)
    }
    
    func backgroundColor() -> some View {
        if isClickedMan {
            Color.blue400.edgesIgnoringSafeArea(.all)
        } else if isClickedWoman {
            Color.pink400.edgesIgnoringSafeArea(.all)
        } else {
            Color.white.edgesIgnoringSafeArea(.all)
        }
    }
    
    func buttonColor() -> Color{
        if isClickedMan || isClickedWoman{
            return Color.white
        } else {
            return Color.grayQuarternary
        }
    }
    
    func buttonForegroundColor() -> Color{
        if isClickedMan {
            return Color.blue400
        } else if isClickedWoman {
            return Color.pink400
        } else {
            return Color.white
        }
    }
    
}

#Preview {
    GenderView()
}
