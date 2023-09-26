//
//  ResultView.swift
//  lab1
//
//  Created by Даниил Крымлов on 11.09.2023.
//

import SwiftUI
import Charts
import UniformTypeIdentifiers

struct TextDocument: FileDocument {
    static var readableContentTypes: [UTType] {
        [.plainText]
    }
    
    var text = ""
    
    init(text: String) {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            text = ""
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: Data(text.utf8))
    }
}

struct ArrayObject : Identifiable {
    
    let id : Int
    let value : Int
    
}

func getArrayObject(array : [Int]) -> [ArrayObject]{
    
    var arrayObject : [ArrayObject] = []
    for (index, value) in array.enumerated(){
        arrayObject.append(ArrayObject.init(id: index, value: value))
    }
    return arrayObject
    
}

struct ResultView: View {
    
    let array : [Int]
    
    @State var isExporting : Bool = false
    @ObservedObject var viewModel = ResultsViewModel()
    
    init(array: [Int], viewModel: ResultsViewModel = ResultsViewModel()) {
        self.array = array
        self.viewModel = viewModel
        viewModel.setArray(array: array)
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    var body: some View {
        
            NavigationStack{
                
                VStack{
                    Chart{
                        ForEach(getArrayObject(array: array)) { item in
                            BarMark(
                                x: .value("Mount", item.id),
                                y: .value("Value", item.value)
                            )
                        }
                    }
                    .frame(height: 150)
                    .padding()
                    
                    Chart{
                        ForEach(getArrayObject(array: viewModel.bubbleSortMethod.array)) { item in
                            BarMark(
                                x: .value("Mount", item.id),
                                y: .value("Value", item.value)
                            )
                        }
                    }
                    
                    .frame(height: 150)
                    .padding()
                    
                    List{
                        Section(header: Text("Leaderboard")){
                            HStack{
                                Text("Entry Array: " + array.description)
                            }
                            HStack{
                                Text("Top by Iterations: " + viewModel.getTopMethodByIterations())
                            }
                            HStack{
                                Text("Top by Time: " + viewModel.getTopMethodByExecutionTime())
                            }
                        }
                        Section(header: Text("Bubble Sort")){
                            HStack{
                                Text(viewModel.bubbleSortMethod.array.description ).frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(viewModel.bubbleSortMethod.iterations))
                            }
                            Text(String(describing: viewModel.bubbleSortMethod.sortTime))
                        }
                        Section(header: Text("Insertion Sort")){
                            HStack{
                                Text(viewModel.insertionSortMethod.array.description ).frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(String(viewModel.insertionSortMethod.iterations))
                            }
                            Text(String(describing: viewModel.insertionSortMethod.sortTime))
                        }
                        Section(header: Text("Selection Sort")){
                            HStack{
                                Text(viewModel.selectionSortMethod.array.description ).frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(viewModel.selectionSortMethod.iterations))
                            }
                            Text(String(describing: viewModel.selectionSortMethod.sortTime))
                        }
                        Section(header: Text("Quick Sort")){
                            HStack{
                                Text(viewModel.quickSortMethod.array.description ).frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(viewModel.quickSortMethod.iterations))
                            }
                            Text(String(describing: viewModel.quickSortMethod.sortTime))
                        }
                        Section(header: Text("Bucket Sort")){
                            HStack{
                                Text(viewModel.bucketSortMethod.array.description ).frame(maxWidth: .infinity, alignment: .leading)
                                Text(String(viewModel.bucketSortMethod.iterations))
                            }
                            Text(String(describing: viewModel.bucketSortMethod.sortTime))
                        }
                    }
                }.onAppear{
                    viewModel.bubbleSort()
                    viewModel.insertionSort()
                    viewModel.selectionSort()
                    viewModel.quickSort()
                    viewModel.bucketSort()
                }
                .background(Color(uiColor: UIColor.secondarySystemBackground))
                .navigationTitle("Result").toolbar{
                    Button("Save", action: {
                        self.isExporting.toggle()
                    })
                }
                .fileExporter(
                    isPresented: $isExporting,
                    document: TextDocument(text: array.description),
                    contentType: .plainText
                ) { result in
                    switch result {
                    case .success(let file):
                        print(file)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(array: [2,1,5,10,6,8,0])
    }
}
