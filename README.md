![Passage Swift](https://storage.googleapis.com/passage-docs/passage-github-banner.png)

# Example Passkey Complete iOS Application

This example iOS app demonstrates the basic integration of the [Passage Swift SDK](https://github.com/passageidentity/passage-swift) in a Swift iOS application. Before implementing the Passage Swift SDK in your own app, it may be most helpful to get this example app up and running with your own Passage credentials.

## **Requirements**

- iOS 14+
- Xcode 14 +
- An Apple Developer account and Team
- A Passage account and app
- A public `apple-app-site-association` file hosted with your website

## **Get started**

### Update app Signing & Capabilities

- Modify the `webcredentials` and `applinks` Associated Domains domains to match the domain where your `apple-app-site-association` file is hosted
- Select your development team
- Modify the bundle id, if needed

NOTE: Your selected development team and bundle id MUST correspond with the application id you provide in your site’s `apple-app-site-association` file. Learn more about setting up this file [here](https://developer.apple.com/documentation/xcode/supporting-associated-domains).

<img width="984" alt="Screen Shot 2022-09-11 at 4 28 06 PM" src="https://user-images.githubusercontent.com/16176400/189553768-691a6470-4bf9-402e-bb60-0c019477f8e9.png">


### Run the app! 🚀
If all of the configuration was setup correctly, you should be able to run this application in the simulator or on a real device through Xcode!

---
<br />
<p align="center">
  <picture>
    <source media="(prefers-color-scheme: light)" srcset="https://storage.googleapis.com/passage-docs/logo-small-light.pngg" width="150">
    <source media="(prefers-color-scheme: dark)" srcset="https://storage.googleapis.com/passage-docs/logo-small-dark.png" width="150">
    <img alt="Passage Logo" src="https://storage.googleapis.com/passage-docs/logo-small-light.png" width="150">
  </picture>
</p>

<p align="center">Give customers the passwordless future they deserve. To learn more check out <a href="https://passage.1password.com">passage.1password.com</a></p>

<p align="center">This project is licensed under the MIT license. See the <a href="./LICENSE"> LICENSE</a> file for more info.</p>