# 캡스톤디자인 프로젝트

## Requirements
* Any Operating System (ie. MacOS X, Linux, Windows)
* Any IDE with Flutter SDK installed (ie. IntelliJ, Android Studio, VSCode etc)

## Features
 * Made marks with Naver Map
 * Url scheme to Kakao Map Navigator
 * Used firebase
 * Custom photo feed 
 * Post photo posts from camera or gallery
   * Like posts
   * Comment on posts
        * View all comments on a post
 * Search for users
 * Realtime Messaging and Sending images
 * Deleting Posts
 * Profile Pages
   * Change profile picture
   * Change username
   * Follow / Unfollow Users
 * Notifications Feed showing recent likes / comments of your posts + new followers
 * Swipe to delete notification

## Installation

```bash
# Prepare your Flutter environment
# Go to https://flutter.dev/docs/get-started/install
# After configured go ahead

# Clone this repository
$ git clone git@github.com:jamesleetu/fornature.git

# Go into the repository
$ cd fornature

# Check issues
$ flutter doctor

# Get dependencies
$ flutter pub get

# Build APK
$ flutter build apk --release
```

## Used packages
Version control (You can check thorugh https://pub.dev/)
```yaml
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.3
  google_sign_in: ^5.0.3
  flutter_icons: ^1.1.0
  percent_indicator: ^3.0.1
  cached_network_image: ^3.0.0
  flutter_spinkit: ^5.0.0
  cloud_firestore: ^2.2.0
  fluttertoast: ^8.0.7
  animations: ^2.0.0
  image: ^3.0.2
  uuid: ^3.0.4
  firebase_auth: ^1.2.0
  firebase_core: ^1.2.0
  image_picker: ^0.7.5+2
  firebase_storage: ^8.1.0
  path_provider: ^2.0.1
  geolocator: ^7.0.3
  geocoding: ^2.0.0
  timeago: ^3.0.2
  like_button: ^2.0.2
  google_fonts: ^2.1.0
  provider: ^5.0.0
  modal_progress_hud: ^0.1.3
  image_cropper: ^1.4.0
  shared_preferences: ^2.0.5
  data_connection_checker: ^0.3.4
  naver_map_plugin: ^0.9.6
  qrscan: ^0.2.22
  image_gallery_saver: ^1.6.9
  permission_handler: ^8.0.0+2
  url_launcher: ^5.1.3
  http:
  android_intent: ^2.0.2
  ```
  
  ## More
  You can check more information about project through [2021 Capstone Design 1 Wiki](http://cscp2.sogang.ac.kr/CSE4186/index.php/%EC%A0%9C%EB%A1%9C%EC%9B%A8%EC%9D%B4%EC%8A%A4%ED%8A%B8%EC%83%B5_%EB%A7%A4%ED%95%91_%EC%95%B1)
