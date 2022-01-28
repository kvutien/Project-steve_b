# Steve_B Earth Observer
## Introduction
In 1991 when I visited some friends in Goshen, Indiana, USA, I met there a group of Amish people. The head of the group was a man who could forecast the weather of the coming week quite accurately, although he had no meteorological academic background. He simply had a long observation experience, as a farmer. His friends even say that he could even predict pretty well the yield of the coming season.

This example made me deeply convinced that if simple farmers were given simple tools to observe satellite images, they can build their own knowledge, and if they can share this knowledge among them, together they can anticipate on potential weather changes for their families.

With the technologies available in the 21st century, this is possible:
* **Google Earth Engine** or **EO Explorer** bring free and up-to-date satellite images as well as powerful image processing tools.
* **Flutter** or **React Native** supports making mobile apps for Android and iOS.
* **Blockchain** tools can be used to share in a decentralised and trusted manner each one's analysis, and build up individual reputation, as in the Amish community.

In the honor of *Steve Birky*, my brother-in-law, who spent his life helping people in need, this is a **free** mobile-based tool to observe by satellite the health of vegetation everywhere in the world. No registration required, no advertisement.

## How to use the mobile app
* Android devices: Download from Play Store at ...<URL>
* iOS devices: download from App Store at ...<URL>

Once the app installed, double-click on the app to launch. No login required. Nothing to pay. 

This is an example on an iPad mini 6" screen: ![screenshot on ipad mini](./assets/images/iPad_mini_6".png)

* By default the app shows the Mekong delta in Vietnam.
* Click on "Search places" and type a location name. The app will move there, anywhere in the world.
* Click the image and drag to move the area that is displayed. 
* The image is divided in 2 panes; click and drag the icon "< >" to change how the screen estate is shared between the 2:
  * The left pane shows the satellite image taken by Copernicus on a desired date.
  * The right pane shows the Google data in several layers: map view, aerial view, vegetation view.
* On top left you have the zoom button. Click on "+" to zoom in. Click on "-" to zoom out.

## Contents of this repository
This is a Flutter project, compatible Android and iOS. Here is how to install Flutter if you want to improve on the app.

The code is inspired from the example given in [https://inappwebview.dev/docs/in-app-webview/basic-usage/](https://inappwebview.dev/docs/in-app-webview/basic-usage/)

* install Android Studio
* install Flutter
* fork and clone the repository
* open the project in Android Studio and run

  More ...
