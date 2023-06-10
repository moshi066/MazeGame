//
//  DeadEndScreenView.swift
//  MazeGame
//
//  Created by Moshiur Rahman on 6/10/23.
//

import SwiftUI

struct DeadEndScreenView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var maze: Maze
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack (spacing: 10) {
            Text("Woah!")
                .font(.title)
                .bold()
                .foregroundColor(.red)
            Text("You are at a dead end!")
                .font(.body)
                .padding(.bottom, 20)
            
            VStack {
                Button("restart game") {
                    maze.restart()
                    closeModal()
                }
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(.green)
                .cornerRadius(10)
                
                Button("continue game") {
                    closeModal()
                }
                .font(.system(size: 20, weight: .bold))
                .cornerRadius(5)
                .foregroundColor(.red)
                .frame(width: 200, height: 50)
                .border(.green, width: 2)
                .cornerRadius(5)
                
                Button("back to main menu") {
                    dismiss()
                }
                .font(.system(size: 20, weight: .bold))
                .cornerRadius(5)
                .foregroundColor(.green)
                .frame(width: 200, height: 50)
                .border(.green, width: 2)
                .cornerRadius(5)
            }
        }
        .padding()
        .background(Color.white)
        .scaleEffect(isPresented ? 1 : 0.5)
        .opacity(isPresented ? 1 : 0)
    }
    
    func closeModal() {
        withAnimation {
            isPresented = false
        }
    }
}

struct DeadEndScreenView_Previews: PreviewProvider {
    static var previews: some View {
        DeadEndScreenView(isPresented: .constant(true))
    }
}
