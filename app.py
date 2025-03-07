from flask import Flask, jsonify, send_file
import pandas as pd
import matplotlib.pyplot as plt

app = Flask(__name__)

# Load your dataset (ensure the file is in the same directory or provide the correct path)
df = pd.read_csv('crime_dataset_india.csv')

@app.route('/')
def hello_world():
    return 'Welcome to the Crime Analysis App!'

@app.route('/crime_analysis')
def crime_analysis():
    # Most common crimes reported in different cities
    crime_by_city = df.groupby(['City', 'Crime Description']).size().unstack().fillna(0)
    crime_by_city.plot(kind='bar', stacked=True, figsize=(12, 6))
    plt.title("Most Common Crimes Reported in Different Cities")
    plt.xlabel("City")
    plt.ylabel("Number of Crimes")
    plt.legend(title="Crime Type")
    plt.xticks(rotation=45)

    # Save the plot
    plt.savefig('crime_by_city.png')
    plt.close()  # Close the plot to avoid issues with Flask's threading

    # Return the image file
    return send_file('crime_by_city.png', mimetype='image/png')

@app.route('/closure_rate')
def closure_rate():
    # Crimes with the highest case closure rates
    closure_rates = df[df['Case Closed'] == 'Yes'].groupby('Crime Description').size() / df.groupby('Crime Description').size()
    closure_rates.dropna().sort_values(ascending=False).plot(kind='bar', figsize=(10, 5), color='green')
    plt.title("Crime Types with Highest Case Closure Rates")
    plt.xlabel("Crime Type")
    plt.ylabel("Closure Rate")
    plt.xticks(rotation=45)

    # Save the plot
    plt.savefig('closure_rate.png')
    plt.close()  # Close the plot to avoid issues with Flask's threading

    # Return the image file
    return send_file('closure_rate.png', mimetype='image/png')

@app.route('/violent_crimes')
def violent_crimes():
    # Most commonly used weapons in violent crimes
    violent_crimes = df[df['Crime Description'].str.contains("ASSAULT|HOMICIDE|EXTORTION|KIDNAPPING", case=False, na=False)]
    weapon_counts = violent_crimes['Weapon Used'].value_counts()
    weapon_counts.plot(kind='bar', figsize=(10, 5), color='red')
    plt.title("Most Commonly Used Weapons in Violent Crimes")
    plt.xlabel("Weapon Type")
    plt.ylabel("Frequency")
    plt.xticks(rotation=45)

    # Save the plot
    plt.savefig('violent_crimes_weapons.png')
    plt.close()  # Close the plot to avoid issues with Flask's threading

    # Return the image file
    return send_file('violent_crimes_weapons.png', mimetype='image/png')

@app.route('/top_crimes')
def top_crimes():
    # Top 5 most frequently occurring crimes across all cities
    top_crimes = df['Crime Description'].value_counts().head(5)
    top_crimes.plot(kind='bar', figsize=(10, 5), color='blue')
    plt.title("Top 5 Most Frequently Occurring Crimes")
    plt.xlabel("Crime Type")
    plt.ylabel("Number of Cases")
    plt.xticks(rotation=45)

    # Save the plot
    plt.savefig('top_crimes.png')
    plt.close()  # Close the plot to avoid issues with Flask's threading

    # Return the image file
    return send_file('top_crimes.png', mimetype='image/png')

@app.route('/metro_vs_non_metro')
def metro_vs_non_metro():
    # Define metro cities (modify based on your dataset)
    metro_cities = ["Mumbai", "Delhi", "Bangalore", "Kolkata", "Chennai", "Hyderabad", "Pune"]

    # Categorize cities as Metro or Non-Metro
    df["City Type"] = df["City"].apply(lambda x: "Metro" if x in metro_cities else "Non-Metro")

    # Count crimes in Metro vs. Non-Metro areas
    crime_by_city_type = df["City Type"].value_counts()

    # Plot the comparison
    crime_by_city_type.plot(kind="bar", figsize=(8, 5), color=["blue", "orange"])
    plt.title("Crime Frequency: Metro vs. Non-Metro Cities")
    plt.xlabel("City Type")
    plt.ylabel("Number of Crimes")
    plt.xticks(rotation=0)

    # Save the plot
    plt.savefig('metro_vs_non_metro.png')
    plt.close()  # Close the plot to avoid issues with Flask's threading

    # Return the image file
    return send_file('metro_vs_non_metro.png', mimetype='image/png')

@app.route('/crime_closure_rate')
def crime_closure_rate():
    # Filter cases that are closed
    closed_cases = df[df['Case Closed'] == 'Yes']

    # Group by Crime Description and count the closed cases
    closure_rates = closed_cases.groupby('Crime Description').size().reset_index(name='Closed Cases')

    # Calculate the total number of cases for each crime type
    total_cases = df.groupby('Crime Description').size().reset_index(name='Total Cases')

    # Merge the two DataFrames
    closure_rates = pd.merge(closure_rates, total_cases, on='Crime Description')

    # Calculate the closure rate
    closure_rates['Closure Rate'] = closure_rates['Closed Cases'] / closure_rates['Total Cases']

    # Sort by Closure Rate in descending order
    closure_rates = closure_rates.sort_values(by='Closure Rate', ascending=False)

    # Plot the data
    plt.figure(figsize=(12, 8))
    plt.bar(closure_rates['Crime Description'], closure_rates['Closure Rate'])
    plt.xlabel('Crime Description')
    plt.ylabel('Closure Rate')
    plt.title('Crime Types with Highest Case Closure Rates')
    plt.xticks(rotation=90)

    # Save the plot
    plt.savefig('crime_closure_rate.png')
    plt.close()  # Close the plot to avoid issues with Flask's threading

    # Return the image file
    return send_file('crime_closure_rate.png', mimetype='image/png')

if __name__ == '__main__':
    app.run(debug=True)
