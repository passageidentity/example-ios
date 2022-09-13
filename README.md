<img src="https://storage.googleapis.com/passage-docs/passage-logo-gradient.svg" alt="Passage logo" style="width:250px;"/>

# Example iOS Application

This example iOS app demonstrates the basic integration of the [Passage SDK](https://github.com/passageidentity/passage-ios) in a Swift iOS application. Before implementing the Passage iOS SDK in your own app, it may be most helpful to get this example app up and running with your own Passage credentials.

## **Requirements**

- iOS 14+
- Xcode 14 +
- An Apple Developer account and Team
- A Passage account and app
- A public `apple-app-site-association` file hosted with your website

## **Configuration**

### 1. Update app Signing & Capabilities

- Modify the `webcredentials` and `applinks` Associated Domains domains to match the domain where your `apple-app-site-association` file is hosted
- Select your development team
- Modify the bundle id, if needed

NOTE: Your selected development team and bundle id MUST correspond with the application id you provide in your site’s `apple-app-site-association` file. Learn more about setting up this file [here](https://developer.apple.com/documentation/xcode/supporting-associated-domains).

<img width="984" alt="Screen Shot 2022-09-11 at 4 28 06 PM" src="https://user-images.githubusercontent.com/16176400/189553768-691a6470-4bf9-402e-bb60-0c019477f8e9.png">



### 2. Add Passage.plist file

- Add key `appId` with the value of your Passage app id
- Add key `authOrigin` with the value of your Passage app auth origin url

<img width="982" alt="Screen Shot 2022-09-11 at 4 30 46 PM" src="https://user-images.githubusercontent.com/16176400/189553770-0e797e8e-5a40-46c5-9180-403700843628.png">


### 3. Run the app! 🚀
If all of the configuration was setup correctly, you should be able to run this application in the simulator or on a real device through Xcode!
