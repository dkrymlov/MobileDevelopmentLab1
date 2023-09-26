//
//  ContentView.swift
//  lab1
//
//  Created by Даниил Крымлов on 11.09.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var array : [Int] = []
    @State private var itemToAdd = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                Form{
                    Text(array.description)
                    HStack{
                        TextField("Number", text: $itemToAdd).keyboardType(.numberPad)
                        Button("Add", action: {
                            array.append(Int(itemToAdd) ?? 0)
                            itemToAdd = ""
                        })
                    }
                    if array.count >= 2 {
                        NavigationLink(destination: ResultView(array: array)){
                            Text("Sort")
                        }
                    }
                }
            }.navigationTitle("Sorting App").toolbar{
                Button(action: {
                    array = []
                }, label: {
                    Image(systemName: "arrow.clockwise")
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
