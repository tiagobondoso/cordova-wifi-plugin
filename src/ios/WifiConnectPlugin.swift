import NetworkExtension
import Foundation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

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
        var ssid: String?

        // Try fetching SSID using CNCopyCurrentNetworkInfo (iOS 13 and earlier)
        if #available(iOS 13.0, *) {
            ssid = getWiFiSSID()
        }

        // Try fetching SSID using NEHotspotNetwork.fetchCurrent() (iOS 14+ with entitlement)
        if #available(iOS 14.0, *), ssid == nil {
            NEHotspotNetwork.fetchCurrent { currentNetwork in
                if let fetchedSSID = currentNetwork?.ssid {
                    self.sendSuccessResult(ssid: fetchedSSID, command: command)
                } else {
                    self.sendErrorResult(message: "⚠️ Could not retrieve SSID. Make sure your app has the correct entitlements.", command: command)
                }
            }
            return // Important: Fetching is async, so return here
        }

        // Send result based on retrieved SSID
        if let foundSSID = ssid {
            sendSuccessResult(ssid: foundSSID, command: command)
        } else {
            sendErrorResult(message: "⚠️ Could not retrieve SSID. Ensure location permissions are enabled.", command: command)
        }
    }

    // Helper function to get Wi-Fi SSID (iOS 13 and earlier)
    func getWiFiSSID() -> String? {
        if let interfaces = CNCopySupportedInterfaces() as? [String] {
            for interface in interfaces {
                if let info = CNCopyCurrentNetworkInfo(interface as CFString) as? [String: AnyObject] {
                    return info[kCNNetworkInfoKeySSID as String] as? String
                }
            }
        }
        return nil
    }

    // Helper function to send success result
    func sendSuccessResult(ssid: String, command: CDVInvokedUrlCommand) {
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "✅ Connected to SSID: \(ssid)")
        self.commandDelegate.send(result, callbackId: command.callbackId)
    }

    // Helper function to send error result
    func sendErrorResult(message: String, command: CDVInvokedUrlCommand) {
        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
        self.commandDelegate.send(result, callbackId: command.callbackId)
    }

}
