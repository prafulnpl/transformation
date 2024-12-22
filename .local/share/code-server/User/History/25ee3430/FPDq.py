import os

# List of your Airbyte raw tables
airbyte_raw_tables = [
    "airbyte_raw_bus",
    "airbyte_raw_classsubject",
    "airbyte_raw_country",
    "airbyte_raw_shift",
    "airbyte_raw_currentyear",
    "airbyte_raw_department",
    "airbyte_raw_district",
    "airbyte_raw_education",
    "airbyte_raw_employment",
    "airbyte_raw_examtype",
    "airbyte_raw_faculty",
    "airbyte_raw_fiscal_year",
    "airbyte_raw_generalstudent",
    "airbyte_raw_guardian",
    "airbyte_raw_hostel",
    "airbyte_raw_house",
    "airbyte_raw_nationality",
    "airbyte_raw_occupation",
    "airbyte_raw_relation",
    "airbyte_raw_remark",
    "airbyte_raw_schoolattendance",
    "airbyte_raw_studentclass",
    "airbyte_raw_studenthistory",
    "airbyte_raw_studentmain",
    "airbyte_raw_studentremark",
    "airbyte_raw_studentsubject",
    "airbyte_raw_subject",
    "airbyte_raw_subjectattendance",
    "airbyte_raw_teachermain",
    "airbyte_raw_teachersdetail",
    "airbyte_raw_vdc",
    "airbyte_raw_zone"
]

# Directory where you want to save the .sql files
output_directory = "."

# Create the directory if it doesn't exist
os.makedirs(output_directory, exist_ok=True)

# Template for the SQL model with properly escaped curly brackets
sql_template = """-- Model: {model_name}

with leads as (
    {{{{ flatten_json_trino('bronze_raw.{table_name}', '_airbyte_data', 'ST_') }}}}
)
select * from leads
"""

# Function to remove the 'airbyte_raw_' prefix and add 'silver_' prefix
def get_model_name(table_name):
    if table_name.startswith("airbyte_raw_"):
        return "silver_" + table_name[len("airbyte_raw_"):]
    else:
        return "silver_" + table_name

# Generate and write each .sql file
for table in airbyte_raw_tables:
    model_name = get_model_name(table)
    # Format the SQL content with the model name and table name
    sql_content = sql_template.format(model_name=model_name, table_name=table)
    # Write the content to the corresponding .sql file
    file_path = os.path.join(output_directory, f"{model_name}.sql")
    with open(file_path, 'w') as file:
        file.write(sql_content)
    print(f"Created model: {file_path}")

print("\nAll SQL model files have been generated successfully!")
