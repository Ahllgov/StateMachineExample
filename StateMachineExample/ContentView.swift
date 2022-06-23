//
//  ContentView.swift
//  StateMachineExample
//
//  Created by Магомед Ахильгов on 23.06.2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: CarListViewModel

    var body: some View {
      VStack {
        switch(viewModel.state) {
        case .initial:
          Text("Initial")
        case .loading:
          Text("Loading...")
        case .results:
          Text("Results: \(viewModel.data.count) items")
        case .error:
          Text("Oops... Something went wrong")
          Text(viewModel.stateError?.localizedDescription ?? "Some misterious error")
        case .empty:
          Text("Oo... No results 🥺")
        }
      }
      .onAppear {
        viewModel.send(event: .onAppear)
      }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
