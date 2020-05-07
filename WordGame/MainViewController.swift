//
//  ViewController.swift
//  WordGame
//
//  Created by Vincent Fan on 2/5/2020.
//  Copyright © 2020 Vincent Fan. All rights reserved.
//

import UIKit
import SAConfettiView

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var wordGridCollectionView: UICollectionView!
    @IBOutlet weak var selectionLineView: SelectionLineView!
    @IBOutlet weak var wordsCollectionView: WordCollectionView!
    @IBOutlet weak var tipsButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    private let words = ["OBJECTIVEC","VARIABLE","SWIFT","KOTLIN","JAVA","MOBILE","AGILE","KANBAN","REACT"]
    private let rows = 12
    private let cols = 12
    private var correct = 0
    lazy var confetti = SAConfettiView(frame: self.view.bounds)
    lazy var grid = PuzzleGenerator(words: words, rows: rows, cols: cols)
    private var wordGrid: [[String]] = []
    private var selectedCells: [IndexPath] = []
    private var tips: [(Int, Int)] = []
    private var cellSize: CGSize {
        return CGSize(width: wordGridCollectionView.bounds.width/CGFloat(cols), height: wordGridCollectionView.bounds.height/CGFloat(rows))
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadGame()
        setupWordGridCollectionView()
        setupButtons()
    }
    
    func loadGame() {
        wordGrid = grid.getGrid()
        tips = grid.getTips()
        setupWordsCollectionView()
    }
    
    func setupWordGridCollectionView() {
        wordGridCollectionView.canCancelContentTouches = false
        wordGridCollectionView.allowsMultipleSelection = true
        wordGridCollectionView.blockStyle()
        
        let slide = UIPanGestureRecognizer(target: self, action: #selector(sliding(panGesture:)))
        wordGridCollectionView.addGestureRecognizer(slide)
    }
    
    func setupWordsCollectionView() {
        wordsCollectionView.words = words
        wordsCollectionView.allowsMultipleSelection = true
        wordsCollectionView.blockStyle()
    }
    
    func setupButtons() {
        tipsButton.layer.cornerRadius = 10
        clearButton.layer.cornerRadius = 10
        resetButton.layer.cornerRadius = 10
    }
    
    func resetGame() {
        correct = 0
        selectionLineView.clearAllLines()
        selectionLineView.finishSelectionLine()
        wordsCollectionView.reloadData()
        wordGridCollectionView.reloadData()
    }
    
    func newGame() {
        grid = PuzzleGenerator(words: words, rows: rows, cols: cols)
        resetGame()
        tipsButton.isEnabled = true
        loadGame()
    }
    
    func startConfettiView() {
        confetti.startConfetti()
        self.view.addSubview(confetti)
        let alert = UIAlertController(title: "Congratulations", message: "You have completed the game using \(words.count - tips.count)/\(words.count) hints. You can restart the game!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { action in
            self.confetti.removeFromSuperview()
            self.newGame()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func indexPathToXY(indexPath: IndexPath) -> (Int, Int) {
        return (indexPath.row % rows, indexPath.row/cols)
    }
    
    func checkWord(x0: Int, y0: Int, x1: Int, y1: Int) -> String {
        var word = ""
        if x0 == x1 && y0 != y1 {
            let dy = (y0<y1) ? 1 : -1
            for i in 0...abs(y0-y1) {
                word.append(wordGrid[y0 + i*dy][x0])
            }
        } else if y0 == y1 && x0 != x1 {
            let dx = (x0<x1) ? 1 : -1
            for i in 0...abs(x0-x1) {
                word.append(wordGrid[y0][x0 + i*dx])
            }
        } else if abs(y0-y1) == abs(x0-x1) {
            var (dx, dy) = (0,0)
            if x0 < x1 && y0 < y1 {
                (dx, dy) = (1,1)
            } else if x0 > x1 && y0 > y1 {
                (dx, dy) = (-1,-1)
            } else if x0 < x1 && y0 > y1 {
                (dx, dy) = (1,-1)
            } else if x0 > x1 && y0 < y1 {
                (dx, dy) = (-1,1)
            }
            for i in 0...abs(y0-y1) {
                word.append(wordGrid[y0 + i * dy][x0 + i * dx])
            }
        }
        return word
    }
    
    @IBAction func reloadGrid(_ sender: Any) {
        resetButton.shake()
        newGame()
    }
    
    @IBAction func clearGrid(_ sender: Any) {
        clearButton.shake()
        resetGame()
    }
    
    @IBAction func getTip(_ sender: Any) {
        tipsButton.shake()
        let (y,x) = tips.remove(at: Int.random(in: 0..<tips.count))
        let indexPath = IndexPath(row: y*12 + x, section: 0)
        wordGridCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        selectionLineView.beginSelectionLine(x: x, y: y)
        if tips.count == 0 {
            tipsButton.isEnabled = false
        }
    }
    
    @objc func sliding(panGesture: UIPanGestureRecognizer) {
        let location = panGesture.location(in: wordGridCollectionView)
        guard let indexPath = wordGridCollectionView.indexPathForItem(at: location)else { return }
        let (x,y) = indexPathToXY(indexPath: indexPath)
        switch panGesture.state {
        case .began:
            selectedCells.append(indexPath)
            selectionLineView.beginSelectionLine(x: x, y: y)
            wordGridCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        case .changed:
            if selectionLineView.continueSelectionLine(x: x, y: y) {
                if !(selectedCells.contains(indexPath)) {
                    wordGridCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
                    selectedCells.append(indexPath)
                } else {
                    if selectedCells.lastIndex(of: indexPath)! < selectedCells.count - 1 {
                        wordGridCollectionView.deselectItem(at: selectedCells[selectedCells.endIndex-1], animated: true)
                        selectedCells.remove(at: selectedCells.endIndex-1)
                    }
                }
            }
        case .ended:
            let (x0, y0) = (selectedCells[0].row % rows, selectedCells[0].row/cols)
            let (x1, y1) = (selectedCells.last!.row % rows, selectedCells.last!.row/cols)
            let answer = checkWord(x0: x0, y0: y0, x1: x1, y1: y1)
            if words.contains(answer) {
                selectionLineView.correctSelectionLine()
                wordsCollectionView.selectCell(target: answer)
                correct += 1
                if correct == words.count {
                    startConfettiView()
                }
            } else {
                for i in selectedCells{
                    wordGridCollectionView.deselectItem(at: i, animated: true)
                }
                selectionLineView.finishSelectionLine()
            }
            selectedCells = []
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rows*cols
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CharacterViewCell
        let (x,y) = (indexPath.row % rows, indexPath.row/cols)
        cell.characterLabel.text = wordGrid[y][x]
        
        return cell
    }
}
