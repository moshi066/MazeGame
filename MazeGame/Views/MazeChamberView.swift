//
//  MazeChamberView.swift
//  MazeGame
//
//  Created by Moshiur Rahman on 6/09/23.
//

import SwiftUI

struct MazeChamberView: View {
    @EnvironmentObject var maze: Maze
    @Environment(\.dismiss) private var dismiss
    let buttonSize: CGFloat = 80
    let circleSize: CGFloat = 300
    let fontColorOfTheActiveButton: Color = Color(red: 18/255, green: 99/255, blue: 37/255)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.green.opacity(0.1))
                .ignoresSafeArea()
            NavigationStack {
                VStack {
                    HStack {
                        Button {
                            saveMaze(maze: maze)
                            dismiss()
                        } label: {
                            Image(systemName: "arrowshape.turn.up.backward")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                        Spacer()
                        Button {
                            maze.restart()
                        } label: {
                            Image(systemName: "goforward")
                                .scaleEffect(x: -1, y: -1)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.green)
                        }
                    }
                    
                    Divider()
                    
                    Text("you're at: [ \(maze.currentRow) \(maze.currentColumn) ]")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.green, lineWidth: 2)
                        )
                    Spacer()
                    Circle()
                        .fill(.bar)
                        .frame(width: circleSize, height: circleSize)
                        .overlay(
                            VStack {
                                Button(action: {
                                    maze.moveUp()
                                }) {
                                    Image(systemName: "arrow.up")
                                        .font(.system(size: 30, weight: .bold))
                                        .frame(width: buttonSize, height: buttonSize)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [(maze.isMovingUpPermitted ? Color.green : .gray).opacity(0.5), (maze.isMovingUpPermitted ? Color.green : .gray).opacity(0.2)]),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .foregroundColor(maze.isMovingUpPermitted ? fontColorOfTheActiveButton : .gray)
                                        .clipShape(Circle())
                                        .shadow(color: (maze.isMovingUpPermitted ? Color.green : .gray)
                                            .opacity(0.5), radius: 10, x: 0, y: 5)
                                }
                                .disabled(!maze.isMovingUpPermitted)
                                
                                Spacer()
                                
                                HStack {
                                    Button(action: {
                                        maze.moveLeft()
                                    }) {
                                        Image(systemName: "arrow.left")
                                            .font(.system(size: 30, weight: .bold))
                                            .frame(width: buttonSize, height: buttonSize)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [(maze.isMovingLeftPermitted ? Color.green : .gray).opacity(0.5), (maze.isMovingLeftPermitted ? Color.green : .gray).opacity(0.2)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .foregroundColor(maze.isMovingLeftPermitted ? fontColorOfTheActiveButton : .gray)
                                            .clipShape(Circle())
                                            .shadow(color: (maze.isMovingLeftPermitted ? Color.green : .gray).opacity(0.5), radius: 10, x: -5, y: 0)
                                    }
                                    .disabled(!maze.isMovingLeftPermitted)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        maze.moveRight()
                                    }) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 30, weight: .bold))
                                            .frame(width: buttonSize, height: buttonSize)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [(maze.isMovingRightPermitted ? Color.green : .gray).opacity(0.2), (maze.isMovingRightPermitted ? Color.green : .gray).opacity(0.5)]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .foregroundColor(maze.isMovingRightPermitted ? fontColorOfTheActiveButton : .gray)
                                            .clipShape(Circle())
                                            .shadow(color: (maze.isMovingRightPermitted ? Color.green : .gray).opacity(0.5), radius: 10, x: 5, y: 0)
                                    }
                                    .disabled(!maze.isMovingRightPermitted)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    maze.moveDown()
                                }) {
                                    Image(systemName: "arrow.down")
                                        .font(.system(size: 30, weight: .bold))
                                        .frame(width: buttonSize, height: buttonSize)
                                        .background(
                                            LinearGradient(
                                                gradient: Gradient(colors: [(maze.isMovingDownPermitted ? Color.green : .gray).opacity(0.5), (maze.isMovingDownPermitted ? Color.green : .gray).opacity(0.2)]),
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                        )
                                        .foregroundColor(maze.isMovingDownPermitted ? fontColorOfTheActiveButton : .gray)
                                        .clipShape(Circle())
                                        .shadow(color: (maze.isMovingDownPermitted ? Color.green : .gray).opacity(0.5), radius: 10, x: 0, y: -5)
                                }
                                .disabled(!maze.isMovingDownPermitted)
                                
                            }
                        )
                    Spacer()
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Instructions:")
                            .bold()
                            .underline()
                        Text("1. Tap on the one-way doors (left, right, up, or down) to navigate through the maze.")
                        Text("2. Only enabled doors can be used to move to the next chamber.")
                        Text("3. Find the exit chamber to win the game.")
                    }
                    .foregroundColor(.gray)
                    
                }.padding()
            }.navigationBarHidden(true)
            
            if maze.isInWinningChamber {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                
                WinningScreenView(isPresented: $maze.isInWinningChamber)
                    .environmentObject(maze)
                    .padding()
                    .frame(width: 300, height: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .zIndex(2)
            }
            
            if maze.isDeadEnd {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(1)
                
                DeadEndScreenView(isPresented: $maze.isDeadEnd)
                    .environmentObject(maze)
                    .padding()
                    .frame(width: 300, height: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .zIndex(2)
            }
        }
    }
}

struct MazeChamberView_Previews: PreviewProvider {
    static var previews: some View {
        MazeChamberView()
            .environmentObject(Maze(size: 5))
    }
}

