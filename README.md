# ![OutSystems](https://anetie.pt/wp-content/uploads/2017/08/outsystems-wpcf_300x300.jpg) 
# WifiConnectPlugin

## Overview

The **WifiConnectPlugin** is a Cordova plugin designed specifically for iOS applications to connect users to a specified Wi-Fi network seamlessly. Utilizing the `NEHotspotConfiguration` API, this plugin allows applications to suggest and connect to a Wi-Fi network by providing the SSID and password directly from the app. 

This plugin is ideal for OutSystems mobile applications requiring dynamic Wi-Fi network connections to a particular network, enhancing user experience by avoiding manual network switching.

### Features:
- Connect to a specified Wi-Fi network programmatically.
- Error handling for invalid or empty SSID inputs.
- Success and error callbacks for seamless integration into your app’s workflow.

## Installation

To install the **WifiConnectPlugin** in your Cordova-based OutSystems mobile app, follow these steps:

1. Add the plugin to your Cordova project:
    ```bash
    cordova plugin add <path-to-your-plugin-directory>
    ```

2. Ensure your iOS app has the necessary entitlements for Wi-Fi network configuration:
    - The plugin will automatically add the required **Hotspot Configuration** capability to your `Entitlements-Debug.plist` and `Entitlements-Release.plist` files.

3. Build your Cordova project:
    ```bash
    cordova build ios
    ```

## Usage

After installing the plugin, you can use it in your JavaScript code as follows:

1. **Connect to Wi-Fi**

    ```javascript
    var ssid = "Your_SSID";
    var password = "Your_Password";

    WifiConnectPlugin.connectToWifi(ssid, password, 
        function(successMessage) {
            console.log("Success: " + successMessage);
        }, 
        function(errorMessage) {
            console.error("Error: " + errorMessage);
        }
    );
    ```

### Methods:

- **connectToWifi(ssid, password, successCallback, errorCallback)**  
    Connects to the Wi-Fi network specified by the `ssid` and `password`.
    
    - **ssid**: The name of the Wi-Fi network (SSID).
    - **password**: The password for the Wi-Fi network.
    - **successCallback**: Function that gets called when the connection is successful.
    - **errorCallback**: Function that gets called when an error occurs.

### Example:

```javascript
WifiConnectPlugin.connectToWifi("MyNetworkSSID", "MyNetworkPassword", 
    function(success) {
        console.log("Connected to Wi-Fi successfully: " + success);
    },
    function(error) {
        console.error("Failed to connect: " + error);
    }
);
```

## Author

**André Grillo**  
*Native Mobile Developer - iOS & Android*  
*OutSystems*

## License

This plugin is licensed under the **MIT License**.
