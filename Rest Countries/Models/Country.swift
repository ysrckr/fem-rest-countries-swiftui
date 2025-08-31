//
//  Country.swift
//  Rest Countries
//
//  Created by Yaşar Çakır on 27.08.2025.
//

import Foundation

struct CountryName: Codable {
    var common: String
    var official: String
}

struct Flag: Codable {
    var png: String
    var svg: String
    var alt: String
}

struct Country: Codable {
    var name: CountryName
    var flags: Flag
    var population: Int
    var cca2: String
    var region: String
    var capital: [String]
    let borders: [String]
}
