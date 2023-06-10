//
//  Helper.swift
//  MazeGame
//
//  Created by Moshiur Rahman on 6/10/23.
//

import Foundation

func getSavedMaze() -> Maze? {
    guard let data = UserDefaults.standard.data(forKey: "SavedMaze") else {
        print("No saved maze found")
        return nil
    }
    
    do {
        let decoder = JSONDecoder()
        let loadedMaze = try decoder.decode(Maze.self, from: data)
        print("Maze loaded successfully")
        return loadedMaze
    } catch {
        print("Failed to load maze: \(error.localizedDescription)")
    }
    return nil
}

func saveMaze(maze: Maze?) {
    if(maze == nil) {
        return
    }
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(maze)
        UserDefaults.standard.set(data, forKey: "SavedMaze")
        print("Maze saved successfully")
    } catch {
        print("Failed to save maze: \(error.localizedDescription)")
    }
}


