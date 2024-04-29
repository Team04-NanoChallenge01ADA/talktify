//
//  CallButtonComponent.swift
//  talktify
//
//  Created by Dason Tiovino on 29/04/24.
//

import Foundation
import SwiftUI

struct CallButtonComponent: View {
    var action: () -> Void
    
    var isActive: Bool
    
    var activeIcon: String
    var inActiveIcon: String
    
    var activeBackground: Color
    var inactiveBackground: Color
    
    var body: some View {
        Button(action: action){
            ZStack{
                Circle().frame(
                    width: 100,
                    height: 100
                ).foregroundStyle(isActive ? activeBackground : inactiveBackground)
                
                Image(systemName: isActive ? activeIcon : inActiveIcon)
                    .foregroundStyle(isActive ? .red : .white)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
        }
    }
}
