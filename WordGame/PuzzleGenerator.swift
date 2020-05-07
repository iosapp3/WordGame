//
//  PuzzleGenerator.swift
//  WordGame
//
//  Created by Vincent Fan on 2/5/2020.
//  Copyright © 2020 Vincent Fan. All rights reserved.
//

import Foundation

class PuzzleGenerator {
    
    private var words: [String]
    private var rows: Int
    private var cols: Int
    private var grid: [[String]]
    private var tips: [(Int,Int)]
    let directions = ["posHorizontal", "negHorizontal", "posVertical", "negVertical", "posUpDiagonal", "negUpDiagonal", "posDownDiagonal", "negDownDiagonal"]
    
    init(words: [String], rows: Int, cols: Int) {
        self.words = words
        self.rows = rows
        self.cols = cols
        self.grid = Array(repeating: Array(repeating: "-", count: self.cols), count: self.rows)
        self.tips = []
    }
    
    public func getGrid() -> [[String]] {
        generate()
        fill()
        return self.grid
    }
    
    public func getTips() -> [(Int,Int)] {
        return self.tips
    }
    
    private func getDirection() -> (Int, Int) {
        let direction = directions[Int.random(in: 0 ... 7)]
        switch direction {
        case "posHorizontal":
            return (1,0)
        case "negHorizontal":
            return (-1,0)
        case "posVertical":
            return (0,1)
        case "negVertical":
            return (0,-1)
        case "posUpDiagonal":
            return (1,1)
        case "negUpDiagonal":
            return (-1,-1)
        case "posDownDiagonal":
            return (1,-1)
        case "negDownDiagonal":
            return (-1,1)
        default:
            return (0,0)
        }
    }
    
    func getWord(startx: Int, starty: Int, endx: Int, endy: Int) -> String {
        var word = ""
        if startx == endx && starty != endy {
            let dy = (starty<endy) ? 1 : -1
            for i in 0...abs(starty-endy) {
                word.append(grid[starty + i*dy][startx])
            }
        } else if starty == endy && startx != endx {
            let dx = (startx<endx) ? 1 : -1
            for i in 0...abs(startx-endx) {
                word.append(grid[starty][startx + i*dx])
            }
        } else if abs(starty-endy) == abs(startx-endx) {
            var (dx, dy) = (0,0)
            if startx < endx && starty < endy {
                (dx, dy) = (1,1)
            } else if startx > endx && starty > endy {
                (dx, dy) = (-1,-1)
            } else if startx < endx && starty > endy {
                (dx, dy) = (1,-1)
            } else if startx > endx && starty < endy {
                (dx, dy) = (-1,1)
            }
            for i in 0...abs(starty-endy) {
                word.append(grid[starty + i * dy][startx + i * dx])
            }
        }
        return word
    }
    
    private func fill() {
        let chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for i in 0 ... self.rows-1 {
            for j in 0 ... self.cols-1 {
                if self.grid[i][j] == "-" {
                    self.grid[i][j] = String(chars.randomElement()!)
                }
            }
        }
    }
    
    private func generate() {
        for word in self.words{
            let len = word.count
            let characters = Array(word)
            var placed = false
            while !placed {
                let (dx, dy) = getDirection()

                let x0 = Int.random(in: 0 ... self.cols-1)
                let y0 = Int.random(in: 0 ... self.rows-1)
                
                var x1 = x0 + len * dx
                var y1 = y0 + len * dy
                
                if x1 < 0 || x1 >= self.cols {continue}
                if y1 < 0 || y1 >= self.rows {continue}
                
                var canFit = true
                for i in 0 ... len-1 {
                    let char = String(characters[i])
                    x1 = x0 + i * dx
                    y1 = y0 + i * dy
                    if self.grid[y1][x1] != "-" && self.grid[y1][x1] != char {
                        canFit = false
                        break
                    }
                }
                
                if !canFit {
                    continue
                } else {
                    for i in 0 ... len-1 {
                        x1 = x0 + i * dx
                        y1 = y0 + i * dy
                        self.grid[y1][x1] = String(characters[i])
                        if i == 0 {
                            self.tips.append((y1,x1))
                        }
                    }
                    placed = true
                }
            }
        }
    }
}
