**Parichay Mahan Rashtra _an app to discover Maharashtra_**

## :iphone:Overview
Parichay Mahan-Rashtra, the Maharashtra Tourism app, reveals hidden gems, offering a unique exploration experience. Beyond well-known sites, it's a comprehensive guide to the state's rich culture, history, and traditions. Focused on tourist engagement, it showcases lesser-known destinations, providing authentic information for diverse preferences. Committed to presenting Maharashtra's true beauty, it caters to tourists, travelers, and researchers seeking distinctive insights.

## :rocket:Features
-**Destination Selection:** Choose from various categories of places to visit in Maharashtra.Access detailed information about selected places, including ratings sourced from Firebase.

-**Virtual Tour:** Embark on a virtual tour of dream destinations using Google Maps' Street View feature.

-**Bucket List:** Curate a personalized bucket list of favorite places for future reference.Receive tailored recommendations based on your selections.

-**Guide Recruitment:** Join as a local guide by filling out necessary details.Authenticate guides securely using IDFY API integration.

-**Festival Section:** Stay informed about upcoming festivals in Maharashtra, including dates and locations.

-**AI Itinerary Planning:** Let AI assist in planning trip itineraries based on your preferences.Customize and share itineraries with others seamlessly.

-**Transport Booking:** Book flights and trains directly within the app via the transport section.

-**Monument Identification AI:** Utilize AI to identify monuments and gain insights about them instantly.

-**Add a Place:** Suggest new places to be added to the app.

-**Admin Panel:** Admin panel integration for verifying and adding suggested places to Firebase.

## :computer:Installation Guide
Follow these steps to install and run TravelApp on your local machine:

1. **Clone Repository:**
   ```
   git clone https://github.com/devanganaB/Parichay_GDSC
   ```

2. **Navigate to Directory:**
   ```
   cd parichay
   ```

3. **Install Dependencies:**
   ```
   flutter pub get
   ```

4. **Set Up Environment Variables:**
   - Create a `.env` file in the root directory.
   - Add the necessary environment variables.

5. **Start the Application:**
   - It is preferred that you use an emulator for better experience
   ```
   flutter run
   ```

7. **Start the backend server**
   - Switch to a new terminal in the same project
   ```
   cd server
   ```
8. **Install dependencies**
   ```
   pip install Flask flask-cors pandas
   ```
9. **Run the Flask Server**
   ```
   python app.py
   ```
10. **Start the Admin app**

##  :earth_americas:United Nations's Sustainable Development goal and target
Our solution aligns with United Nations' Sustainable Development Goal 8 - Decent Work and Economic Growth. The inspiration stems from the untapped potential of numerous Maharashtra destinations capable of fostering economic growth through tourism. By highlighting these hidden gems, our project aims to generate employment opportunities and contribute to the overall economic well-being of the region.

## :gear:Technology

Parichay utilizes advanced technologies to offer users an immersive and seamless travel experience. The app is built using a combination of robust frameworks and platforms, ensuring reliability, scalability, and performance.

- **Flutter**: Parichay's front-end is developed using Flutter, Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. Flutter enables smooth animations, expressive UI, and fast development cycles.

- **Firebase**: Firebase powers Parichay's back-end, providing a comprehensive suite of tools for app development, including authentication, real-time database, cloud storage, and hosting. Firebase ensures seamless data synchronization and scalable infrastructure.

- **Angular**: Parichay's admin panel is built using Angular, a platform for building web applications with TypeScript and HTML. Angular offers a powerful framework for creating dynamic and interactive user interfaces, making it ideal for managing and verifying user-generated content.

- **Google Maps**: Parichay integrates Google Maps for location-based services, enabling users to explore destinations, plan itineraries, and navigate with ease. Google Maps offers accurate geolocation data, interactive maps, and street views for a rich and immersive travel experience.

- **Gemini**: Parichay leverages Gemini, a GraphQL client for Flutter, to efficiently fetch and manage data from the server. Gemini streamlines data fetching and state management, optimizing performance and reducing network overhead.




