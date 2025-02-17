
### Short exercise done in Jan 2020 with the following features:
- **Does a call to the stackoverflow API to get top 10 (by reputation) users and displays them in a table**
- Implemented using MVVM-C (using closures)
- Tapping on a user expands the cell to show follow and block options
- Following or blocking a user updates the cell immediately.

### Structure
• Organized by feature or "flow" in Scenes folder. Each Scene should have at least one view and one viewModel. Ideally a coordinator too.
• Models and Services in their separate folder as they can be used with more than one Scene.

###  Networking

• There will be a core network module that executes all the requests, that all the services talk to.
• There will be a service for each identifiable requirement, the viewModel should use this service via the API protocol defined by the service. The service will ask the networkModule to execute the request. Services can be plugged into any viewModel.
• Regarding configurations and url generation, using enums for query parameter values, while using static structs for query parameter keys. In a real application, a configuration would be injected depending on the scheme/environment, instead of using a static struct.

###  Architecture

• The UITableViewController is notified via a closure when the state of the viewModel changed, and reacts accordingly. In the real world I would accomplish this with observables.
 
 ### Configuration

• A lot of static structs used that would be replaced by dependency injection when reading from a storage / configuration file / configuration service.

### Tableview / Table view architecture and state management:

-  Saving blocked/followed state to mock what a preference storage would look like in dictionary, did not persist this in any way so it will reset on app relaunch.
- UserTableViewCell class got a little too big for my liking, though I think responsibilities are still being delegated properly, there is definitely room for improvement mainly with cleaning up the constraint logic by making it more readable and obvious.
