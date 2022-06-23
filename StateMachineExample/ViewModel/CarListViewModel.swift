//
//  CarListViewModel.swift
//  StateMachineExample
//
//  Created by Магомед Ахильгов on 23.06.2022.
//

import Foundation

enum CarListState: Equatable {
  case initial
  case loading
  case results
  case empty
  case error
}

// MARK: - CarListEvent

enum CarListEvent {
  case onAppear

  case retry
  case reload
  case fetchNextPage

  case didFetchResultsSuccessfully(_ results: [Car])
  case didFetchResultsFailure(_ error: Error)
  case didFetchResultsEmpty

  case openCarDetail(_ car: Car)
}

class CarListViewModel: StateMachine<CarListState, CarListEvent> {

  // MARK: Lifecycle

  init() {
    super.init(.initial)
  }

  // MARK: Internal

  var data: [Car] = []
  var page: Int = 0

  override func handleEvent(_ event: CarListEvent) -> CarListState? {
    switch(state, event) {
    case (.initial, .onAppear):
      fetchData()
      return .loading

    case (.loading, .didFetchResultsSuccessfully(let results)),
         (.results, .didFetchResultsSuccessfully(let results)):
      return .results

    case (.loading, .didFetchResultsFailure(let error)):
      stateError = error
      return .error

    case (.loading, .didFetchResultsEmpty):
      return .empty

    case (.results, .didFetchResultsEmpty):
      break // Don't change the state to empty as we have some results to show to the user.

    case (.results, .reload):
      break

    case
      (.empty, .retry),
      (.error, .retry):
      fetchData()
      return .loading

    default:
      fatalError("Event not handled...")
    }

    return nil
  }

  override func handleStateUpdate(_ oldState: CarListState, new newState: CarListState) {
    switch(oldState, newState) {
    case (.initial, .loading):
      break
    case (.loading, .results):
      break
    case (.loading, .empty):
      data = []
      stateError = nil
    case (.error, .loading):
      stateError = nil
    case
      (.loading, .error),
      (.empty, .loading):
      data = []
      page = 1
    default:
      fatalError("You lended in a misterious place... Coming from \(oldState) and trying to get to \(newState)")
    }
  }

  // MARK: Private

  private func fetchData(_ page: Int = 1) {
    Task {
      do {
        try await Task.sleep(nanoseconds: 2_000_000_000) // Simulate the async call
        await MainActor.run {
          send(event: .didFetchResultsSuccessfully([.init(id: UUID(), brand: "Something")]))
        }
      } catch {
        send(event: .didFetchResultsFailure(error))
      }
    }
  }

}
