import os

# List of table names and their descriptions
table_data = [
    {
        "name": "airbyte_raw_dlytica_academy_lead_converted_lead_tbln3zyr01r2qasyc",
        "description": "Raw data for converted leads"
    },
    {
        "name": "airbyte_raw_dlytica_academy_lead_enquiryform_tbl22p4oozlac4ryo",
        "description": "Raw data for enquiry forms"
    },
    {
        "name": "airbyte_raw_dlytica_academy_lead_old_leads_tblgmh2uk7fw3mvpx",
        "description": "Raw data for old leads"
    },
    {
        "name": "airbyte_raw_dlytica_academy_lead_openhouse_nepal_tbloek7yzj1c1qi52",
        "description": "Raw data for open house events in Nepal"
    },
    {
        "name": "airbyte_raw_dlytica_academy_lead_professional_month_tblgyw00osesvndqy",
        "description": "Raw data for professional month leads"
    },
    {
        "name": "airbyte_raw_dlytica_academy_lead_screened_leads_tblelhdxsn4et31rl",
        "description": "Raw data for screened leads"
    },
    {
        "name": "airbyte_raw_dlytica_academy_lead_50__discounts_for_students_tblxjuoaaggifjb06",
        "description": "Raw data for 50% discounts for students"
    }
]

# Directory to save the SQL files
output_dir = "."
os.makedirs(output_dir, exist_ok=True)

# Function to generate file name and SQL content
def generate_sql_file(table):
    # Extract the meaningful part of the table name
    table_base_name = table["name"].replace("airbyte_raw_", "").replace("tbl", "").replace("_", " ").title().replace(" ", "_")
    
    # Generate the SQL file name
    file_name = f"silver_{table_base_name}.sql"

    # Generate SQL content
    sql_content = f"""-- Auto-generated file for {table['description']}

with leads as (
    {{ flatten_json_trino('bronze_raw.{table['name']}', '_airbyte_data', 'ST_') }}
)
select * from leads;
"""

    # Write the SQL content to the file
    file_path = os.path.join(output_dir, file_name)
    with open(file_path, "w") as sql_file:
        sql_file.write(sql_content)

    print(f"Generated: {file_path}")

# Generate SQL files for all tables
for table in table_data:
    generate_sql_file(table)

print("All SQL files have been generated.")
