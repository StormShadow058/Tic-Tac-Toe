//
//  Alerts.swift
//  Tic Tac Toe
//
//  Created by Vansh Maheshwari on 01/02/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWins = AlertItem(title: Text("You Win!"),
                              message: Text("You are a good player."),
                              buttonTitle: Text("Hell Yeah!"))
    
    static let compWins = AlertItem(title: Text("You Lost!"),
                              message: Text("The AI takes the lead."),
                              buttonTitle: Text("Retry?"))
    
    static let draw = AlertItem(title: Text("Draw!"),
                              message: Text("GG!"),
                              buttonTitle: Text("Play Again?"))
}
