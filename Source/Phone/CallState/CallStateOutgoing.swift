// Copyright 2016 Cisco Systems Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

class CallStateOutgoing: CallState {

    override var status: Call.Status {
        return .Ringing
    }
    
    override func update() {
        if info.hasLeft {
            doActionWhenLocalCancelled()
        } else if info.hasAtLeastOneRemoteParticipantantJoined {
            doActionWhenConnected()
        } else if info.hasAtLeastOneRemoteParticipantantDeclined {
            doActionWhenRemoteDeclined()
        }
    }
    
    private func doActionWhenConnected() {
        call.state = CallStateConnected(call)
        callNotificationCenter.notifyCallConnected(call)
    }
    
    private func doActionWhenLocalCancelled() {
        callManager.removeCall(call.url)
        call.state = CallStateLocalCancelled(call)
        callNotificationCenter.notifyCallDisconnected(call, disconnectionType: DisconnectionType.LocalCancelled)
    }
    
    private func doActionWhenRemoteDeclined() {
        callManager.removeCall(call.url)
        call.hangup(nil)
        call.state = CallStateRemoteDeclined(call)
        callNotificationCenter.notifyCallDisconnected(call, disconnectionType: DisconnectionType.RemoteDeclined)
    }
}