//
//  Product.swift
//  Shopping
//
//  Created by Reimos on 7/25/25.
//

import Foundation

struct DummyProduct {
    let imageName: String
    let name: String
    let description: String
    let price: String
}

let dummyProducts: [DummyProduct] = [
    DummyProduct(imageName: "coffee_mocha", name: "모카 커피", description: "달콤한 초콜릿 향의 부드러운 커피", price: "4500"),
    DummyProduct(imageName: "sandwich_egg", name: "에그 샌드위치", description: "촉촉한 계란", price: "4500"),
    DummyProduct(imageName: "green_tea", name: "녹차 라떼", description: "은은한 녹차 향과 고소한 우유의 만남", price: "4500"),
    DummyProduct(imageName: "bag_canvas", name: "캔버스 백", description: "심플한 디자인의 데일리 캔버스 가방", price: "4500"),
    DummyProduct(imageName: "notebook_set", name: "노트북 세트", description: "3권 구성의 감성적인 무지노트", price: "4500"),
    DummyProduct(imageName: "earphones_wireless", name: "무선 이어폰", description: "선 없이 자유롭게, 고음질 무선 이어폰", price: "69000"),
    DummyProduct(imageName: "cup_tumbler", name: "텀블러", description: "보온/보냉 기능이 우수한 스테인리스 텀블러", price: "4500"),
    DummyProduct(imageName: "choco_cookie", name: "초코 쿠키", description: "바삭하고 달콤한 초콜릿 칩 쿠키", price: "4500"),
    DummyProduct(imageName: "pen_gel", name: "젤 펜 세트", description: "다채로운 색상의 부드러운 젤 펜 10종", price: "4500"),
    DummyProduct(imageName: "lamp_desk", name: "LED 데스크 램프", description: "밝기 조절이 가능한 심플한 디자인 조명", price: "4500")
]
