//
//  MockMission.swift
//  LurkerTests
//
//  Created by Sam Spencer on 4/1/22.
//  Copyright © 2022 Sam Spencer
//

import XCTest
import BackgroundTasks
@testable import Lurker

final class MockMission: Mission {
    
    var style: MissionStyle {
        return .brief
    }
    
    var identifier: String {
        return "com.lurker.mission.mock.01"
    }
    
    func runTask(_ taskInfo: BGTask) async -> Bool {
        return true
    }
    
    func earliestStart() -> Date? {
        return nil
    }
    
}
