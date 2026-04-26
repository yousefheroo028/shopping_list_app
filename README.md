# Shopping List App

A modern Flutter application designed to help users efficiently manage and organize their grocery lists with real-time backend synchronization.

## State Management
This project utilizes **Bloc/Cubit** for state management, specifically leveraging **HydratedBloc** to provide seamless state persistence across app restarts.

## Key Features
- **Real-time Backend Integration**: Seamlessly syncs grocery items with a remote database using HTTP services for reliable data consistency.
- **Local Persistence**: Uses `HydratedBloc` to ensure that your shopping list is saved locally and remains available even after the app is closed or when offline.
- **Categorized Management**: Organizes grocery items into specific categories (e.g., Meat, Vegetables, Fruits), helping users find and manage their items more effectively.
