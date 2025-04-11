import requests
import json
import mysql.connector
from mysql.connector import Error
import sys # To exit if DB connection fails

# --- Configuration ---
CONFIG_FILE = 'config/db_config.json'

API_URL = "http://universities.hipolabs.com/search"
# Fetch data for a specific country, e.g., United States, as an example
API_PARAMS = {'country': 'United States'}

# --- Database Connection ---
def load_db_config():
    """Loads database configuration from the JSON file."""
    try:
        with open(CONFIG_FILE, 'r') as f:
            config = json.load(f)
            print(f"Database configuration loaded from {CONFIG_FILE}")
            return config
    except FileNotFoundError:
        print(f"Error: Configuration file '{CONFIG_FILE}' not found.")
        sys.exit(1) # Exit if config is missing
    except json.JSONDecodeError:
        print(f"Error: Could not parse configuration file '{CONFIG_FILE}'. Check JSON format.")
        sys.exit(1) # Exit if config is invalid
    except Exception as e:
        print(f"An unexpected error occurred while loading config: {e}")
        sys.exit(1)

def create_db_connection(config):
    """Creates a database connection."""
    connection = None
    try:
        connection = mysql.connector.connect(
            host=config['localhost'],
            user=config['root'],
            password=config['naadmin'],
            database=config['student_advising']
        )
        print("MySQL Database connection successful")
    except Error as e:
        print(f"Error connecting to MySQL Database: {e}")
        sys.exit(1) # Exit if connection fails
    return connection

# --- API Fetching ---
def fetch_university_data(url, params):
    """Fetches data from the specified API."""
    try:
        response = requests.get(url, params=params, timeout=10) # Added timeout
        response.raise_for_status()  # Raise an exception for bad status codes (4xx or 5xx)
        print(f"Successfully fetched data from {response.url}")
        return response.json()
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from API: {e}")
        return None
    except json.JSONDecodeError:
        print("Error: Could not decode JSON response from API.")
        return None

# --- Data Insertion ---
def insert_data(connection, data):
  
    if not data:
        print("No data to insert.")
        return

    cursor = connection.cursor()
    inserted_count = 0
    skipped_count = 0

    
    for university in data:
        uni_name = university.get('name')
        # Basic check for valid name
        if uni_name and isinstance(uni_name, str):
            try:
                # Check if department already exists
                cursor.execute("SELECT DepartmentID FROM Departments WHERE DepartmentName = %s", (uni_name,))
                result = cursor.fetchone()

                if not result:
                    # Insert if not exists
                    sql = "INSERT INTO Departments (DepartmentName) VALUES (%s)"
                    cursor.execute(sql, (uni_name,))
                    inserted_count += 1
                else:
                    # print(f"Skipping duplicate Department: {uni_name}")
                    skipped_count += 1

            except Error as e:
                print(f"Error inserting data for {uni_name}: {e}")
                connection.rollback() # Rollback on error for this item
            except Exception as e:
                 print(f"An unexpected error occurred during insertion for {uni_name}: {e}")
                 connection.rollback() # Rollback on error for this item

    try:
        connection.commit()
        print(f"Data insertion attempt complete. Inserted: {inserted_count}, Skipped (duplicates): {skipped_count}")
    except Error as e:
        print(f"Error committing data to database: {e}")
        connection.rollback() # Rollback commit if final commit fails
    finally:
        cursor.close()


# --- Main Execution ---
if __name__ == "__main__":
    print("--- Starting API Fetcher Script ---")

    # 1. Load Config
    db_config = load_db_config()

    # 2. Connect to DB
    db_connection = create_db_connection(db_config)

    # 3. Fetch Data from API
    print(f"Fetching data from API: {API_URL} with params: {API_PARAMS}")
    api_data = fetch_university_data(API_URL, API_PARAMS)

    # 4. Insert Data into DB
    if api_data:
        print(f"Fetched {len(api_data)} records from API.")
        insert_data(db_connection, api_data)
    else:
        print("Could not fetch data from API. Skipping database insertion.")

    # 5. Close DB Connection
    if db_connection and db_connection.is_connected():
        db_connection.close()
        print("MySQL connection closed.")

    print("--- API Fetcher Script Finished ---")