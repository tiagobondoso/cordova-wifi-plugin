import NetworkExtension
import Foundation

@objc(WifiConnectPlugin)
class WifiConnectPlugin: CDVPlugin {
    
    @objc(connectToWifi:)
    func connectToWifi(command: CDVInvokedUrlCommand) {
        let ssid = command.argument(at: 0) as? String ?? ""
        let password = command.argument(at: 1) as? String ?? ""
        
        if ssid.isEmpty {
            let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "SSID cannot be empty.")
            self.commandDelegate.send(result, callbackId: command.callbackId)
            return
        }
        
        if password.isEmpty {
            // Create Wi-Fi configuration without password
            let configuration = NEHotspotConfiguration(ssid: ssid)
            NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
                if let error = error {
                    self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                } else {
                    self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Connected to \(ssid)"), callbackId: command.callbackId)
                }
            }
        } else {
            // Create Wi-Fi configuration
            let configuration = NEHotspotConfiguration(ssid: ssid, passphrase: password, isWEP: false)
            
            NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
                if let error = error {
                    self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: error.localizedDescription), callbackId: command.callbackId)
                } else {
                    self.commandDelegate.send(CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Connected to \(ssid)"), callbackId: command.callbackId)
                }
            }
        }
    }

    @objc(getConnectedSSID:)
        func getConnectedSSID(command: CDVInvokedUrlCommand) {
            NEHotspotNetwork.fetchCurrent { (currentNetwork) in
                    if let ssid = currentNetwork?.ssid {
                        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: ssid)
                        self.commandDelegate.send(result, callbackId: command.callbackId)
                    } else {
                        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Could not retrieve SSID.")
                        self.commandDelegate.send(result, callbackId: command.callbackId)
                    }
                }
    }

    @objc(hasNetworkExtension:)
    func hasNetworkExtension(command: CDVInvokedUrlCommand) {
        var hasExtension = false

        if #available(iOS 14.0, *) {
            if let _ = NEHotspotNetwork.fetchCurrent() {
                hasExtension = true
            }
        }

        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: hasExtension)
        self.commandDelegate.send(result, callbackId: command.callbackId)
    }


}
