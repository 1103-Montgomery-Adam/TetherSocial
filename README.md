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
    - Named conventionally as Services or Managers
    - Also stores our custom datatype definitions (Post, Chat, User, etc).
    - Example...
    - class TrackService {
        // This is the ONLY place that talks directly to Firestore
        Future<List<Track>> fetchLatestTracks() async {
        final snapshot = await FirebaseFirestore.instance.collection('tracks').get();
        return snapshot.docs.map((doc) => Track.fromJson(doc.data())).toList();
        }
      }

View:

    - Classes strickly involved with rendering UI
    - Shouldn't really be preforming any data logic
    - Should own an instance of it's associated ViewModel
    - Relies on the ViewModel to do actual data stuff
    - Example...
    - class FeedView extends StatelessWidget {
        // Inject the ViewModel
        final FeedViewModel viewModel;
        const FeedView({super.key, required this.viewModel});
        @override
        Widget build(BuildContext context) {
          return Scaffold(
            body: Center(
              // This builder redraws whenever notifyListeners() is called
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  //Continued UI specific logic
    
ViewModel:

      - Classes which bridge the gap between the data access layer (model) and UI layers (View)
      - Calls handy methods provided by the Model layer
      - Each ViewModel class is almost always associated to a View class
          Ex. AuthView has a AuthViewModel, CreateView has a CreateViewModel, etc.
      - Example...
      - class FeedViewModel extends ChangeNotifier {
          final TrackService _trackService; // Injected Model service!!!
          List<Track> tracks = [];
          bool isLoading = false;
        
          FeedViewModel(this._trackService);
        
          Future<void> loadFeed() async {
            isLoading = true;
            notifyListeners(); // Tells View to show a loading spinner
        
            // The ViewModel doesn't touch Firebase, it just asks the Service
            tracks = await _trackService.fetchLatestTracks();
            
            isLoading = false;
            notifyListeners(); // Tells View to show the list of tracks
          }
        }


## Github practices
To avoid giant merge conflicts we can do a few things...
1- Branch and Merge off of the Indev branch, saving main for finalized stable code.
2- Make branches small in scope, maybe it's just adding a feature or testing a small piece.
3- Merge development branches back into Indev frequently, keeping it up to date.
