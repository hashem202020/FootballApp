//
//  NavigationAction.swift
//  footballLeaguesApp
//
//  Created by Mohamed Hashem on 28/04/2022.
//

import Foundation

public enum NavigationAction<ViewModelType>: Equatable where ViewModelType: Equatable {
  
  case present(view: ViewModelType)
  case presented(view: ViewModelType)
}
