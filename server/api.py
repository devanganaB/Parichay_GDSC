# # Import necessary modules
# from flask import Flask, request, jsonify
# import pickle
# import pandas as pd
# from flask_cors import CORS

# # Create Flask application instance
# app = Flask(__name__)

# # Enable CORS for all routes
# CORS(app)

# # Load the pre-trained model from Pickle file
# with open('C:/Users/Devangana/Desktop/db/flutterD/flutter_projects/Parichay_FB/server/recommendation_model.pkl', 'rb') as file:
#     cosine_sim = pickle.load(file)

# # Load the dataset from CSV file
# df = pd.read_csv('C:/Users/Devangana/Desktop/db/flutterD/flutter_projects/Parichay_FB/server/places_dataset.csv')

# # Dictionary to store recommendations for each location
# recommendations_dict = {}

# # Route definition for fetching recommendations
# @app.route('/get_recommendations', methods=['POST'])
# def get_recommendations():
#     # Get JSON data from the request
#     data = request.get_json()

#     # Extract the location from the JSON data
#     location = data.get('location')

#     # Check if recommendations exist for the location
#     if location in recommendations_dict:
#         # Retrieve existing recommendations for the location
#         existing_recommendations = recommendations_dict[location]
#         # Calculate the index from which to start fetching additional recommendations
#         start_index = len(existing_recommendations)
#     else:
#         # If no recommendations exist for the location, start from index 0
#         existing_recommendations = []
#         start_index = 0

#     # Find the index of the location in the dataset
#     location_index = df[df['Location'] == location].index[0]

#     # Get the cosine similarity scores for the location
#     sim_scores = list(enumerate(cosine_sim[location_index]))

#     # Sort the locations based on similarity scores
#     sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

#     # Get the next 10 similar locations
#     next_recommendations = [df['Location'].iloc[score[0]] for score in sim_scores[start_index+1:(start_index + 11)]]

#     # Append the new recommendations to the existing list for the location
#     recommendations_dict[location] = existing_recommendations + next_recommendations

#     # Return JSON response with the recommendations
#     return jsonify({'recommendations': recommendations_dict[location]})

# # Run the Flask app
# if __name__ == '__main__':
#     app.run()



# app.py
from flask import Flask, request, jsonify
import pickle
import pandas as pd
from flask_cors import CORS

app = Flask(__name__)

CORS(app)

# Load the model
with open('C:/Users/Devangana/Desktop/db/flutterD/flutter_projects/Parichay_FB/server/recommendation_model.pkl', 'rb') as file:
    cosine_sim = pickle.load(file)

# Load the dataset
df = pd.read_csv('C:/Users/Devangana/Desktop/db/flutterD/flutter_projects/Parichay_FB/server/places_dataset.csv')

# Dictionary to store recommendations for each location
recommendations_dict = {}

@app.route('/get_recommendations', methods=['POST'])

def get_recommendations():
    data = request.get_json()
    location = data.get('location')

    # Find the index of the location in the dataset
    location_index = df[df['Location'] == location].index[0]

    # Get the cosine similarity scores for the location
    sim_scores = list(enumerate(cosine_sim[location_index]))

    # Sort the locations based on similarity scores
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)

    # Get the top 11 similar locations
    top_locations = [df['Location'].iloc[score[0]] for score in sim_scores[1:11]]

    return jsonify({'recommendations': top_locations})

    # # Append the new recommendations to the existing list for the location
    # if location in recommendations_dict:
    #     recommendations_dict[location].extend(top_locations)
    # else:
    #     recommendations_dict[location] = top_locations

    # # Return JSON response with the recommendations
    # return jsonify({'recommendations': recommendations_dict[location]})

if __name__ == '__main__':
    app.run(debug=True)










# from flask import Flask, request, jsonify

# app = Flask(__name__)

# @app.route('/api', methods=['GET'])
# def returnascii():
#     d = {}
#     inputchr = str(request.args.get('query'))
#     answer = str(ord(inputchr))
#     d['output'] = answer

#     return jsonify(d)

# if __name__ == '__main__':
#     app.run(debug=True)


# from flask import Flask

# app = Flask(__name__)

# @app.route('/')
# def hello_world():
#     return 'Hello, World!'

# if __name__ == '__main__':
#     app.run(debug=True)