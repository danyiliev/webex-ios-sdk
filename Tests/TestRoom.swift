// Copyright 2016 Cisco Systems Inc
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import Quick
import Nimble
import SparkSDK

class TestRoom {
    var room: Room?
    var id: String? {
        return room?.id
    }
    var title: String? {
        return room?.title
    }
    
    init?() {
        do {
            room = try SparkTestFixture.sharedInstance!.spark.rooms.create(title: "room_for_test")
            
        } catch let error as NSError {
            fail("Failed to create room, \(error.localizedFailureReason)")
            
            return nil
        }
    }
    
    deinit {
        guard id != nil else {
            return
        }
        do {
            try SparkTestFixture.sharedInstance!.spark.rooms.delete(roomId: id!)
        } catch let error as NSError {
            fail("Failed to delete room, \(error.localizedFailureReason)")
        }
    }
}

class TestRoom: XCTestCase {
    private var fixture: SparkTestFixture! = SparkTestFixture.sharedInstance
    var room: Room?
    var id: String? {
        return room?.id
    }
    var title: String? {
        return room?.title
    }
    
    init?() {
        room = createRoom(title: "room_for_test")
    }
    
    deinit {
        deleteRoom(roomId: id)
        
    }
    
    private func createRoom(title: String) -> Room? {
        let request = { (completionHandler: (ServiceResponse<Room>) -> Void) in
            fixture.createRoom(testCase: self, title: title)
        }
        return 
    }
    
    private func deleteRoom(roomId: String) {
        let authStrategy: JWTAuthStrategy
        let roomClient = RoomClient(AuthenticationStrategy: authStrategy)
        roomClient.delete(testCase: self, roomId: roomId)
    }
    
}
