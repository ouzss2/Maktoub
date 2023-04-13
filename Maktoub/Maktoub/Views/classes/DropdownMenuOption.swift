//
//  DropdownMenuOption.swift
//  Maktoub
//
//  Created by user236595 on 4/6/23.
//

import Foundation
struct DropdownMenuOption: Identifiable, Hashable {
    let id = UUID().uuidString
    let option: String
}

extension DropdownMenuOption {
    static let testSingleMonth: DropdownMenuOption = DropdownMenuOption(option: "March")
    static let testAllMonths: [DropdownMenuOption] = [
        DropdownMenuOption(option: "January"),
        DropdownMenuOption(option: "February"),
        DropdownMenuOption(option: "March"),
        DropdownMenuOption(option: "April"),
        DropdownMenuOption(option: "May"),
        DropdownMenuOption(option: "June"),
        DropdownMenuOption(option: "July"),
        DropdownMenuOption(option: "August"),
        DropdownMenuOption(option: "September"),
        DropdownMenuOption(option: "October"),
        DropdownMenuOption(option: "November"),
        DropdownMenuOption(option: "December")
    ]
}
