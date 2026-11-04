# Tether
CS 425 project repo for Adam, Jackson and Elijah.  
Tether is an innovative software application allowing artists to share and  
collaborate on their original works.  


Tether is supported by:  
  -Flutter codebase for client-side code  
  -Cloudflare for intermediate data encryption  
  -Google Firebase and Cloud Storage for the backend database.
  

## Prerequisites
1. Install the Flutter SDK. [https://docs.flutter.dev/learn/pathway/quick-install]


## Building Architecture
Our best bet at achieving seperation of concerns within our build is by using the MVVM architecture pattern.  
Here's a resource to familarize yourself with MVVM in Flutter. [https://www.youtube.com/watch?v=zQcTrCFV-KU]  
In a nutshell...  


Model:  

    - The data access layer. This is where we will make API calls to Firebase and Cloudflare
    - Also stores our custom datatype definitions (Post, Chat, User, etc).
    
