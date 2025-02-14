// :replace-start: {
//   "terms": {
//     "partitionBasedSyncApp": "app",
//     "flexibleSyncApp": "app"
//   }
// }
import RealmSwift
import SwiftUI

let APP_SERVICES_APP_ID_HERE = "example-testers-kvjdy"

// :snippet-start: mongodb-realm
// MARK: Atlas App Services (Optional)

// The Atlas App Services app. Change YOUR_APP_SERVICES_APP_ID_HERE to your App Services app ID.
// If you don't have an App Services app and don't wish to use Sync for now,
// you can change this to:
//   let app: RealmSwift.App? = nil
let partitionBasedSyncApp: RealmSwift.App? = RealmSwift.App(id: APP_SERVICES_APP_ID_HERE)
// :snippet-end:

let flexibleSyncApp: RealmSwift.App? = RealmSwift.App(id: "swift-flexible-vkljj")

let realm = ItemGroup.previewRealm
let itemGroup = realm.objects(ItemGroup.self)
let personProfile = SwiftUI_Person.previewRealm.objects(Profile.self)
let personWithoutDogs = SwiftUI_Person.previewRealmNoDogs.objects(SwiftUI_Person.self).first!

@main
struct SwiftUICatalogApp: SwiftUI.App {
    static let viewBuilders: [String: () -> AnyView] = [
        "AppendObjectToList": { AnyView(PersonDogView(person: personWithoutDogs)) },
        "DefaultView": { AnyView(DefaultView()) },
        "DogDetails": { AnyView(DogDetailView(dog: SwiftUI_Dog.dog1)) },
        "EditDogDetails": { AnyView(DogDetailsView(dog: SwiftUI_Dog.dog1)) },
        "FilterNSPredicate": { AnyView(FilterDogsViewNSPredicate().environment(\.realm, SwiftUI_Dog.previewRealmJustDogs)) },
        "FilterTypeSafeQuery": { AnyView(FilterDogsViewTypeSafeQuery().environment(\.realm, SwiftUI_Dog.previewRealmJustDogs)) },
        "FSContentView": { AnyView(FlexibleSyncContentView(flexibleSyncApp: flexibleSyncApp!))},
        "FSOrLocalRealm": { AnyView(FlexibleSyncOrLocalRealmView()) },
        "OpenFSRealm": { AnyView(OpenFlexibleSyncRealmView()) },
        "OpenPBSRealm": { AnyView(OpenPartitionBasedSyncRealmView()) },
        "PassRealmObjects": { AnyView(SetUpDogsView()) },
        "PBSContentView": { AnyView(PartitionBasedSyncContentView(thisApp: partitionBasedSyncApp!))},
        "PBSOrLocalRealm": { AnyView(PartitionBasedSyncOrLocalRealmView()) },
        "ProfileView": { AnyView(ProfileView(profile: personProfile.first!)) },
        "SearchableDogsView": { AnyView(SearchableDogsView().environment(\.realm, SwiftUI_Dog.previewRealmJustDogs)) },
        "SectionedResultsList": { AnyView(SectionedDogsView().environment(\.realm, SwiftUI_Dog.previewRealmJustDogs))},
        "SectionedResultsListFiltered": { AnyView(SectionedDogsViewFiltered().environment(\.realm, SwiftUI_Dog.previewRealmJustDogs))},
        "WriteToCollection": { AnyView(DogsListView().environment(\.realm, SwiftUI_Dog.previewRealmJustDogs)) }
    ]
    
    var body: some Scene {
        WindowGroup {
            if let viewName = ProcessInfo().customUITestedView,
               let viewBuilder = Self.viewBuilders[viewName] {
                viewBuilder()
            } else {
                AnyView(DefaultView())
            }
        }
    }
}

struct DefaultView: View {
    var body: some View {
        Text("This is the default view of the SwiftUI unit test host app.")
    }
}

extension ProcessInfo {
    var customUITestedView: String? {
        guard environment["MyUITestsCustomView"] == "true" else { return nil }
        return environment["MyCustomViewName"]
    }
}

enum SyncType {
    case pbs, fs
}
// :replace-end:
