//
//  ResultsViewModel.swift
//  lab1
//
//  Created by Даниил Крымлов on 11.09.2023.
//

import Foundation

struct MethodTest : Identifiable {
    
    var id = UUID()
    var array : [Int] = []
    var iterations : Int = 0
    var sortTime : Duration = Duration.zero
    
    mutating func addIteration(){
        iterations = iterations + 1
    }
    
    mutating func bubbleSort(){
            
        let clock = ContinuousClock()
            
        let result = clock.measure {
            for i in 0..<(array.count-1) { // 1
                for j in 0..<(array.count-i-1){ // 2
                    addIteration()
                    if (array[j + 1] < array[j]){
                        let temp = array[j + 1]
                        array[j + 1] = array[j]
                        array[j] = temp
                    }
                }
            }
        }
        sortTime = result
        
    }
    
    mutating func insertionSort(){
        
        let clock = ContinuousClock()
        
        let result = clock.measure {
            for i in 1..<array.count { // 1
                
                let key = array[i] // 2
                var j = i - 1
                
                addIteration()
                while j >= 0 && key < array[j]{ // 3
                    addIteration()
                    array[j+1] = array[j] // 4
                    j = j - 1
                }
                
                array[j + 1] = key // 5
            }
        }
        
        sortTime = result
        
    }
    
    mutating func selectionSort(){
        
        let clock = ContinuousClock()
        
        let result = clock.measure {
            
            for i in 0..<(array.count-1) {
                
                var key = i // 1
                
                for j in i+1..<array.count {// 2
                    addIteration()
                    if (array[j] < array[key]) {
                        addIteration()
                        key = j
                    }
                    
                }
                addIteration()
                guard i != key else {
                    continue
                }
                
                array.swapAt(i, key) // 3
            }
        }
        
        sortTime = result
    }
    
    mutating func _quickSort(array : [Int]) -> [Int] {
        addIteration()
        if array.count < 2 { return array } // 0
                
                var data = array
                
                let pivot = data.remove(at: 0) // 1
                addIteration()
                let left = data.filter { $0 < pivot } // 2
                addIteration()
                let right = data.filter { !($0 < pivot) } // 3
                let middle = [pivot]
                
                return _quickSort(array: left) + middle + _quickSort(array: right) // 4
    }
    
    mutating func quickSort(){
        let clock = ContinuousClock()
        
        let result = clock.measure {
            array = _quickSort(array: array)
        }
        
        sortTime = result
    }
    
    mutating func _bucketSort() -> [Int]{
        
        let reverse = false
        
        addIteration()
        guard array.count > 0 else { return [] }
                
                let max = array.max()!
                var buckets = [Int](repeating: 0, count: (max + 1))
                var out = [Int]()
                
                for i in 0..<array.count {
                    buckets[array[i]] = buckets[array[i]] + 1
                }

                buckets.enumerated().forEach { index, value in
                    addIteration()
                    guard value > 0 else { return }
                    
                    out.append(contentsOf: [Int](repeating: index, count: value))
                }

                return reverse == true ? out.reversed() : out
        
    }
    
    mutating func bucketSort(){
        let clock = ContinuousClock()
        
        let result = clock.measure {
            array = _bucketSort()
        }
        sortTime = result
    }
    
}

class ResultsViewModel : ObservableObject {
    
    @Published private var bubble = MethodTest()
    @Published private var insertion = MethodTest()
    @Published private var selection = MethodTest()
    @Published private var quick = MethodTest()
    @Published private var bucket = MethodTest()
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveArrayAsFile(array: [Int]) {
        
        let fileName = "myFileName.txt"
        var filePath = ""
        // Fine documents directory on device
        let dirs:[String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if dirs.count > 0 {
            let dir = dirs[0] //documents directory
            filePath = dir.appending("/" + fileName)
            print("Local path = \(filePath)")
        } else {
            print("Could not find local directory to store file")
            return
        }
        // Set the contents
        let fileContentToWrite = "Text to be recorded into file"
        do {
            // Write contents to file
            try fileContentToWrite.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
        
    }
    
    func getTopMethodByIterations() -> String {
        if bubble.iterations <= insertion.iterations && bubble.iterations <= selection.iterations && bubble.iterations <= quick.iterations && bubble.iterations <= bucket.iterations{
            return "Bubble Sort"
        }else if insertion.iterations <= bubble.iterations && insertion.iterations <= selection.iterations && insertion.iterations <= quick.iterations && insertion.iterations <= bucket.iterations{
            return "Insertion Sort"
        }else if selection.iterations <= bubble.iterations && selection.iterations <= insertion.iterations && selection.iterations <= quick.iterations && selection.iterations <= bucket.iterations{
            return "Selection Sort"
        }else if quick.iterations <= bubble.iterations && quick.iterations <= insertion.iterations && quick.iterations <= selection.iterations && quick.iterations <= bucket.iterations{
            return "Quick Sort"
        }else if bucket.iterations <= bubble.iterations && bucket.iterations <= insertion.iterations && bucket.iterations <= selection.iterations && bucket.iterations <= quick.iterations{
            return "Bucket Sort"
        }
        return ""
    }
    
    func getTopMethodByExecutionTime() -> String {
        
        if bubble.sortTime <= insertion.sortTime && bubble.sortTime <= selection.sortTime && bubble.sortTime <= quick.sortTime && bubble.sortTime <= bucket.sortTime{
            return "Bubble Sort"
        }else if insertion.sortTime <= bubble.sortTime && insertion.sortTime <= selection.sortTime && insertion.sortTime <= quick.sortTime && insertion.sortTime <= bucket.sortTime{
            return "Insertion Sort"
        }else if selection.sortTime <= bubble.sortTime && selection.sortTime <= insertion.sortTime && selection.sortTime <= quick.sortTime && selection.sortTime <= bucket.sortTime{
            return "Selection Sort"
        }else if quick.sortTime <= bubble.sortTime && quick.sortTime <= insertion.sortTime && quick.sortTime <= selection.sortTime && quick.sortTime <= bucket.sortTime{
            return "Quick Sort"
        }else if bucket.sortTime <= bubble.sortTime && bucket.sortTime <= insertion.sortTime && bucket.sortTime <= selection.sortTime && bucket.sortTime <= quick.sortTime{
            return "Bucket Sort"
        }
        return ""
        
    }
    
    var bubbleSortMethod : MethodTest {
        return bubble
    }
    
    var insertionSortMethod : MethodTest {
        return insertion
    }
    
    var selectionSortMethod : MethodTest {
        return selection
    }
    
    var quickSortMethod : MethodTest {
        return quick
    }
    
    var bucketSortMethod : MethodTest {
        return bucket
    }
    
    func setArray(array : [Int]){
        self.bubble.array = array
        self.insertion.array = array
        self.selection.array = array
        self.quick.array = array
        self.bucket.array = array
    }
    
    func bubbleSort(){
        bubble.bubbleSort()
    }
    
    func insertionSort(){
        insertion.insertionSort()
    }
    
    func selectionSort(){
        selection.selectionSort()
    }
    
    func quickSort(){
        quick.quickSort()
    }
    
    func bucketSort(){
        bucket.bucketSort()
    }
    
    
    
    
}
