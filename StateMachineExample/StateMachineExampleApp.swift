//
//  StateMachineExampleApp.swift
//  StateMachineExample
//
//  Created by Магомед Ахильгов on 23.06.2022.
//

import SwiftUI

@main
struct StateMachineExampleApp: App {
    
    @StateObject private var viewModel = CarListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
