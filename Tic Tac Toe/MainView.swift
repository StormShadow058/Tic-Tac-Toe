//
//  MainView.swift
//  Tic Tac Toe
//
//  Created by Vansh Maheshwari on 01/02/22.
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0..<9) { i in
                        ZStack {
                            SquareView(proxy: geometry)
                            
                            IndicatorView(imageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.playerMoveProcessing(for: i)
                        }
                    }
                }
                Spacer()
            }
            .disabled(viewModel.gameDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: {alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.buttonTitle,
                                              action: { viewModel.resetGame() }))
            })
        }
    }
}


enum Player {
    case human, comp
}


struct Play {
    let player: Player
    let borardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
}

struct SquareView: View {
    
    var proxy: GeometryProxy
    
    var body: some View {
        Rectangle()
            .foregroundColor(.red)
            .frame(width: proxy.size.width/3 - 15, height: proxy.size.width/3 - 15)
    }
}

struct IndicatorView: View {
    
    var imageName: String
    
    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .foregroundColor(.white)
            .frame(width: 65, height: 65)
    }
}
