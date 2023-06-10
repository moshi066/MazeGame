//
//  MainWindow.swift
//  MazeGame
//
//  Created by Moshiur Rahman on 6/9/23.
//

import SwiftUI

struct MainWindow: View {
    @State private var maze: Maze? = getSavedMaze()
    @State var isPresentingGameWindow: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.green.opacity(0.1))
                    .ignoresSafeArea()
                VStack {
                    Button("start a new game") {
                        maze = Maze(size: 5)
                        isPresentingGameWindow = true
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(.green)
                    .cornerRadius(10)
                    Button("resume game") {
                        maze = getSavedMaze()
                        isPresentingGameWindow = true
                    }
                    .font(.system(size: 20, weight: .bold))
                    .cornerRadius(5)
                    .foregroundColor(.green)
                    .frame(width: 200, height: 50)
                    .border(.green, width: 2)
                    .cornerRadius(5)
                    
                    
                    Button("exit") {
                        saveMaze(maze: maze)
                        exit(0)
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    
                    
                    NavigationLink(destination: MazeChamberView()
                        .environmentObject(maze!), isActive: $isPresentingGameWindow) {
                            EmptyView()
                        }
                        .hidden()
                }
            }
        }
    }
}

struct MainWindow_Previews: PreviewProvider {
    static var previews: some View {
        MainWindow()
    }
}
