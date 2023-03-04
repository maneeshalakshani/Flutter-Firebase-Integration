# Flutter-Firebase-Integration

  - https://firebase.google.com/
  - Go to console
  - Add Project (Title, Disable google analytics for project) -> Create Project
  - Select Android
  - package name
    - Android-> app -> src -> main -> AndroidManifest.xml -> line 2
  - Register App
  - Download 'google-services.json'
  - Paste the downloaded file in -> Android -> app -> past file
  - Click Next
  - Android -> build.gradle
    - classpath within dependencied in middle
  - Android -> app -> build.gradle
    - id 'com.google.gms.google-services' (apply plugin insted of id)
  - Click Next -> Continue to console  
  
  ### Create Database
  
  - Build -> Firestore database -> Create Database
  - select start in test mode
  - Next -> Enable
