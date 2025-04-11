# Student Advising System

## Project Description [cite: 94]

This project provides a backend system for managing student academic advising at a college. It uses MySQL to store information about students, advisors, courses, advising sessions, and degree milestones. The system includes scripts to set up the database, populate it with sample data, and fetch external data (demonstrated using a university list API).

## Technologies Used [cite: 98]

* **Backend Database:** MySQL
* **Schema & Data Scripts:** SQL
* **API Integration & DB Interaction:** Python 3
    * `requests` library (for API calls)
    * `mysql-connector-python` library (for MySQL connection)
* **Configuration:** JSON

## Setup Instructions [cite: 99]

1.  **Prerequisites:** [cite: 95]
    * Install MySQL Server ([https://dev.mysql.com/downloads/mysql/](https://dev.mysql.com/downloads/mysql/))
    * Install Python 3 ([https://www.python.org/downloads/](https://www.python.org/downloads/))
    * Install required Python libraries:
        ```bash
        pip install requests mysql-connector-python
        ```

2.  **Database Setup:**
    * Connect to your MySQL server.
    * Create the database for the project:
        ```sql
        CREATE DATABASE student_advising;
        ```
    * Use the created database:
        ```sql
        USE student_advising;
        ```
    * Run the schema script to create the tables:
        ```bash
        mysql -u your_mysql_user -p student_advising < schema.sql
        ```
        (Replace `your_mysql_user` with your MySQL username. You will be prompted for your password).

3.  **Configuration:** [cite: 100]
    * Edit the `config/db_config.json` file.
    * Replace the placeholder values for `host`, `user`, `password`, and `database` with your actual MySQL connection details[cite: 76, 78].

4.  **Populate Sample Data (Optional but Recommended):** [cite: 99]
    * Run the sample data script:
        ```bash
        mysql -u your_mysql_user -p student_advising < sample_data.sql
        ```

## Usage Instructions & End-to-End Execution [cite: 96, 101]

1.  **Fetch External Data:**
    * Run the Python script to fetch data from the external API (universities.hipolabs.com in this example) and insert it into the database (demonstrated by adding universities as departments):
        ```bash
        python api_fetcher.py
        ```
    * **Note:** The `universities.hipolabs.com` API does not provide detailed course data[cite: 47, 48, 49]. For actual course information, you would need to adapt the `api_fetcher.py` script to use a different API (e.g., College Scorecard[cite: 50, 63], specific university APIs[cite: 51], or OCCAPI [cite: 52, 63]) and modify the data insertion logic accordingly.

2.  **Interacting with the Database:**
    * You can now connect to the `student_advising` database using any MySQL client (like MySQL Workbench, DBeaver, or the command line) to query, insert, update, or delete data.
    * Example Query: Find all students advised by Dr. Grace Hopper:
        ```sql
        SELECT s.Name AS StudentName, s.ContactInformation AS StudentContact
        FROM StudentInformation s
        JOIN AdvisorInformation a ON s.AssignedAdvisorID = a.AdvisorID
        WHERE a.Name = 'Dr. Grace Hopper';
        ```

## Project Structure [cite: 81]