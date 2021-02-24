//
//  ContentView.swift
//  MyWifiConnectionCheckerApp
//
//  Created by Junichi Tomida on 2021/02/19.
//

import SwiftUI
import SystemConfiguration


struct ContentView: View {
    @State var statusText = "Wi-Fi Check!"
    var body: some View {
        Text(statusText)
            .font(.largeTitle)
            .padding()
        
        VStack {
            Button(action: {
                if(connectedToNetwork()){
                    statusText = "connected!"
                }else{
                    statusText = "disconnected!"
                }
            }) {
                Text("Check!")
                    .foregroundColor(Color.white)
                    .padding(.all)
                    .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color.blue/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

func connectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
