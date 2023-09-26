//
//  Models.swift
//  lab1
//
//  Created by Даниил Крымлов on 11.09.2023.
//

import Foundation

struct Point : Identifiable{
    var id = UUID()
    let x : Int
    let y : Int
}

struct TriangleFigure : Identifiable{
    var id = UUID()
    let point1 : Point
    let point2 : Point
    let point3 : Point
}

struct QuadrangleFigure : Identifiable{
    var id = UUID()
    let point1 : Point
    let point2 : Point
    let point3 : Point
    let point4 : Point
}

struct CircleFigure : Identifiable{
    var id = UUID()
    let center : Point
    let radius : Int
}

struct EllipseFigure : Identifiable{
    var id = UUID()
    
}
