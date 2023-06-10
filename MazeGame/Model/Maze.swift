//
//  Maze.swift
//  MazeGame
//
//  Created by Moshiur Rahman on 6/09/23.
//

import SwiftUI

struct CellCoordinates: Hashable {
    let row: Int
    let column: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}

class Maze: ObservableObject, Codable {
    private var size: Int
    private var matrix: [[Int]] = []
    @Published var currentRow: Int = 0 {
        didSet {
            isMovingUpPermitted = ((matrix[currentRow][currentColumn] & (1 << 2)) != 0) && currentRow > 0
            isMovingDownPermitted = ((matrix[currentRow][currentColumn] & (1 << 3)) != 0) && currentRow < size - 1
            isMovingLeftPermitted = ((matrix[currentRow][currentColumn] & (1 << 0)) != 0) && currentColumn > 0
            isMovingRightPermitted = ((matrix[currentRow][currentColumn] & (1 << 1)) != 0) && currentColumn < size - 1
            isInWinningChamber = matrix[currentRow][currentColumn] == 0
            isDeadEnd = !verify(x: currentRow, y: currentColumn)
        }
    }
    @Published var currentColumn: Int = 0 {
        didSet {
            isMovingUpPermitted = ((matrix[currentRow][currentColumn] & (1 << 2)) != 0) && currentRow > 0
            isMovingDownPermitted = ((matrix[currentRow][currentColumn] & (1 << 3)) != 0) && currentRow < size - 1
            isMovingLeftPermitted = ((matrix[currentRow][currentColumn] & (1 << 0)) != 0) && currentColumn > 0
            isMovingRightPermitted = ((matrix[currentRow][currentColumn] & (1 << 1)) != 0) && currentColumn < size - 1
            isInWinningChamber = matrix[currentRow][currentColumn] == 0
            isDeadEnd = !verify(x: currentRow, y: currentColumn)
        }
    }
    @Published var isDeadEnd: Bool = false
    @Published var isInWinningChamber: Bool = false
    @Published var isMovingUpPermitted: Bool = false
    @Published var isMovingDownPermitted: Bool = false
    @Published var isMovingLeftPermitted: Bool = false
    @Published var isMovingRightPermitted: Bool = false
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        size = try container.decode(Int.self, forKey: .size)
        matrix = try container.decode([[Int]].self, forKey: .matrix)
        currentRow = try container.decode(Int.self, forKey: .currentRow)
        currentColumn = try container.decode(Int.self, forKey: .currentColumn)
    }
    
    init(size: Int) {
        self.size = size
        generateMatrix(size: size)
        while(!verify(x: currentRow, y: currentColumn)) {
            generateMatrix(size: size)
        }
    }
    
    func restart() {
        generateMatrix(size: size)
        while(!verify(x: currentRow, y: currentColumn)) {
            generateMatrix(size: size)
        }
    }
    
    func generateMatrix(size: Int) {
        var matrix: [[Int]] = []
        
        let zeroRow = Int.random(in: 0..<size)
        let zeroColumn = Int.random(in: 0..<size)
        
        for row in 0..<size {
            var matrixRow: [Int] = []
            
            for column in 0..<size {
                if row == zeroRow && column == zeroColumn {
                    matrixRow.append(0) // Place 0 in the randomly chosen cell
                } else {
                    matrixRow.append(Int.random(in: 4..<16)) // Place the shuffled numbers in other cells
                }
            }
            
            matrix.append(matrixRow)
        }
        
        // Add a cell with a value greater than size*size - 1
        let greaterThanMaxValue = Int.random(in: 16..<32)
        var randomRow = Int.random(in: 0..<size)
        var randomColumn = Int.random(in: 0..<size)
        
        while randomRow == zeroRow && randomColumn == zeroColumn {
            randomRow = Int.random(in: 0..<size)
            randomColumn = Int.random(in: 0..<size)
        }
        
        matrix[randomRow][randomColumn] = greaterThanMaxValue
        
        self.matrix = matrix
        currentRow = randomRow
        currentColumn = randomColumn
    }
    
    func verify(x: Int, y: Int) -> Bool {
        let targetRow = matrix.indices.first(where: { matrix[$0].contains(0) })
        let targetColumn = matrix[targetRow!].indices.first(where: { matrix[targetRow!][$0] == 0 })
        
        var queue: [(row: Int, column: Int)] = [] // BFS queue
        var visited: Set<CellCoordinates> = [] // Visited cells
        
        // Add the starting cell to the queue
        queue.append((x, y))
        
        while !queue.isEmpty {
            let (row, column) = queue.removeFirst()
            
            // Check if we have reached the target cell
            if row == targetRow && column == targetColumn {
                return true
            }
            
            // Mark the current cell as visited
            visited.insert(CellCoordinates(row: row, column: column))
            let doors = matrix[row][column]
            
            if doors & 1 == 1 && column > 0 { // Check left door
                let nextColumn = column - 1
                if !visited.contains(CellCoordinates(row: row, column: nextColumn)) {
                    queue.append((row, nextColumn))
                }
            }
            if doors & 2 == 2 && column < matrix.count - 1 { // Check right door
                let nextColumn = column + 1
                if !visited.contains(CellCoordinates(row: row, column: nextColumn)) {
                    queue.append((row, nextColumn))
                }
            }
            if doors & 4 == 4 && row > 0 { // Check upper door
                let nextRow = row - 1
                if !visited.contains(CellCoordinates(row: nextRow, column: column)) {
                    queue.append((nextRow, column))
                }
            }
            if doors & 8 == 8 && row < matrix.count - 1 { // Check lower door
                let nextRow = row + 1
                if !visited.contains(CellCoordinates(row: nextRow, column: column)) {
                    queue.append((nextRow, column))
                }
            }
        }
        
        
        // If we reach this point, it means the target cell is not reachable
        print("Target cell is not reachable.")
        return false
    }
    func moveLeft() {
        currentColumn = currentColumn - 1
    }
    func moveRight() {
        currentColumn = currentColumn + 1
    }
    func moveUp() {
        currentRow = currentRow - 1
    }
    func moveDown() {
        currentRow = currentRow + 1
    }
}

extension Maze {
    enum CodingKeys: String, CodingKey {
        case size
        case matrix
        case currentRow
        case currentColumn
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(size, forKey: .size)
        try container.encode(matrix, forKey: .matrix)
        try container.encode(currentRow, forKey: .currentRow)
        try container.encode(currentColumn, forKey: .currentColumn)
    }
}
