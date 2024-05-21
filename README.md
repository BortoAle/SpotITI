# SpotITI: A Custom Indoor Navigation Solution

## Introduction

Navigating large and complex indoor environments can be challenging, especially for people unfamiliar with the layout. SpotITI addresses this challenge by providing an innovative indoor navigation solution that can easily be adapted for use in any building.
## Project Overview

SpotITI is a custom-made indoor navigation system designed to determine a user's position using EAN-8 barcodes placed strategically around the building. The app scans these barcodes, calculates the user's location and direction using the built-in compass, and displays an arrow on the screen to guide the user to their destination.

### How It Works

1. **Barcode Scanning**: EAN-8 barcodes are placed around the building, and the app scans these codes in the background without requiring any effort from the user.
2. **Position Calculation**: The app processes the scanned barcode data to determine the user's current location.
3. **Direction Determination**: The app uses the smartphone's compass, combined with trigonometric calculations, to establish the user's heading.
4. **Navigation Guidance**: An arrow on the screen directs the user toward their destination, updating in real-time as they move.


## Technical Architecture

Developed entirely in Swift and SwiftUI, the iOS app handles user interactions, barcode scanning, and navigation guidance. It ensures a seamless and intuitive user experience, with the app scanning barcodes in the background to provide real-time positioning and navigation. The project uses Swift and SwiftUI features such as Generics, Observable, and environment injections throughout the whole app to have an organized and scalable architecture.

### Technologies

SpotITI leverages several advanced technologies to ensure accurate and reliable indoor navigation:

- **Scandit SDK**: The project integrates the Scandit SDK, known for its fast and reliable EAN-8 barcode scanning capabilities. This is crucial for environments with variable lighting and motion conditions.
- **Core Location**: Used to send updates of the user's location heading to the app that then uses it to calculate the direction to show to the user.
- **AVFoundation**: Thanks to AVFoundation, the app can play various confirmation sounds during navigation, allowing the user to reach their destination without needing to continuously look at the screen.

## Design and Usability

SpotITI's design emphasizes simplicity and usability, ensuring that even first-time users can navigate the building. Much attention was put into the UX research, defining different sketches and deciding on the best user flow. The concept of the app is to save time, so SpotITI is designed to be as straightforward as possible for the user. Even the first time you open it, SpotITI is easy and understandable, providing only the data you need at the moment you need it.

## Benefits

SpotITI addresses a significant need within large buildings:

- **Improved Accessibility**
- **Time Efficiency**
- **Scalability**

### Improved Accessibility

SpotITI enhances the accessibility of large buildings by providing a tool that allows people to navigate independently. This reduces the reliance on staff for guidance, making it easier for visitors to find their way around.

### Time Efficiency

SpotITI saves users time by providing the shortest path to their destinations. This efficiency is particularly beneficial in large and complex buildings where finding the correct route can be time-consuming.

### Scalability

The design and technology behind SpotITI make it easily scalable. The system can be adapted to additional buildings or campuses with minimal adjustments. This versatility makes it suitable for various types of large buildings, such as hospitals, malls, and corporate campuses.

## Installation

1. Clone the  [iOS App project](https://github.com/BortoAle/SpotITI) from GitHub and open it in Xcode.

2. Go to [Scandit](https://ssl.scandit.com/dashboard/sign-up?p=test) and create an account to get an API Key for the Scandit Data Capture SDK.
3. Create a file called `Secrets.plist` in the project folder and add a key with name `API_KEY` and the value being the API Key provided by Scandit.
4. Clone the [SpotITI Backend](https://github.com/GioIacca9/BussolaITIBackend) repository.
5. Configure a MySQL database called "bussola" accessible on port 3306. The database password has to be specified in the environment variable `DB_PWD`.
6. Start the server:

    ```sh
    $ npm i
    $ npm run start:dev
    ```

    > The service uses port `3000`, and the OpenAPI docs are available at `/docs`.

7. In the `APIManager.swift` file, replace the URLs with the local server URLs.

## Conclusion

By joining advanced technologies, leveraging the Swift programming language's capabilities, and focusing on user-centric design, SpotITI provides a solution to indoor navigation challenges. The project is open-source so that anyone can learn from or contribute to it at any time. 
