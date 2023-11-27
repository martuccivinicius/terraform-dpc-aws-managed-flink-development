from pyflink.table import EnvironmentSettings, TableEnvironment
import os
import json
from pyflink.table.expressions import *
from pyflink.table.window import *

# 1. Creates a Table Environment
env_settings = EnvironmentSettings.in_streaming_mode()
table_env = TableEnvironment.create(env_settings)

statement_set = table_env.create_statement_set()


is_local = (
    True if os.environ.get("IS_LOCAL") else False
)  # set this env var in your local environment


if is_local:
    # only for local, overwrite variable to properties and pass in your jars delimited by a semicolon (;)
    print("Running Flink locally...")

    CURRENT_DIR = "/Users/viniciusdeoliveiramartucci/Documents/GitHub/martucci-glue-streaming/auxiliar-scripts/apache-flink/tutorial-aws-flink/kinesis-stream-to-firehose"

    APPLICATION_PROPERTIES_FILE_PATH = f"{CURRENT_DIR}/application_properties.json"  # local

    table_env.get_config().set(
        "pipeline.jars",
        f"file:////Users/viniciusdeoliveiramartucci/Documents/GitHub/martucci-glue-streaming/auxiliar-scripts/apache-flink/tutorial-aws-flink/kinesis-stream-to-firehose/lib/aws-kinesis-analytics-python-apps-1.jar"
    )


else:
    APPLICATION_PROPERTIES_FILE_PATH = "/etc/flink/application_properties.json"  # on Kinesis Data Analytics


def get_application_properties():
    if os.path.isfile(APPLICATION_PROPERTIES_FILE_PATH):
        with open(APPLICATION_PROPERTIES_FILE_PATH, "r") as file:
            contents = file.read()
            properties = json.loads(contents)
            return properties
    else:
        print('A file at "{}" was not found'.format(APPLICATION_PROPERTIES_FILE_PATH))


def property_map(props, property_group_id):
    for prop in props:
        if prop["PropertyGroupId"] == property_group_id:
            return prop["PropertyMap"]

def create_source_table(table_name, stream_name, region, stream_initpos):
    return """ CREATE TABLE IF NOT EXISTS {0} (
                ticker VARCHAR(6),
                price DOUBLE,
                event_time TIMESTAMP(3),
                WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND

              )
              PARTITIONED BY (ticker)
              WITH (
                'connector' = 'kinesis',
                'stream' = '{1}',
                'aws.region' = '{2}',
                'scan.stream.initpos' = '{3}',
                'format' = 'json',
                'json.timestamp-format.standard' = 'ISO-8601'
              ) """.format(
        table_name, stream_name, region, stream_initpos
    )


def create_output_table(table_name, deliver_stream_name, region):
    return f""" CREATE TABLE IF NOT EXISTS {table_name} (
                ticker VARCHAR(6),
                start_timestamp TIMESTAMP(3),
                end_timestamp TIMESTAMP(3),
                rowtime_timestamp TIMESTAMP(3),
                average_price DOUBLE

              )
              WITH (
                  'connector' = 'firehose',
                  'delivery-stream' = '{deliver_stream_name}',
                  'aws.region' = '{region}',
                  'format' = 'json',
                  'json.timestamp-format.standard' = 'ISO-8601'
              ) """


def main():
    # Application Property Keys
    input_property_group_key = "consumer.config.0"
    producer_property_group_key = "producer.config.0"

    input_stream_key = "input.stream.name"
    input_region_key = "aws.region"
    input_starting_position_key = "flink.stream.initpos"

    output_stream_key = "output.stream.name"
    output_region_key = "aws.region"

    # tables
    input_table_name = "input_table"
    output_table_name = "output_table"

    # get application properties
    props = get_application_properties()

    input_property_map = property_map(props, input_property_group_key)
    output_property_map = property_map(props, producer_property_group_key)

    input_stream = input_property_map[input_stream_key]
    input_region = input_property_map[input_region_key]
    stream_initpos = input_property_map[input_starting_position_key]

    print(f"Kinesis Input stream {input_stream} in region {input_region} using initpos {stream_initpos}")

    output_stream = output_property_map[output_stream_key]
    output_region = output_property_map[output_region_key]

    print(f"Kinesis output Stream {output_stream} in region {output_region}")

    # 1. Creates a source table from a Kinesis Data Stream
    print(f" Creating source table {input_table_name} from source stream {input_stream} in region {input_region} using {stream_initpos}")
    table_env.execute_sql(
        create_source_table(input_table_name, input_stream, input_region, stream_initpos)
    )

    #2. Creates a sink table writing to a Kinesis Firehose Delivery Strem
    print(f" Creating destination table {output_table_name} to destination stream {output_stream} in region {output_region}.")
    table_env.execute_sql(
        create_output_table(output_table_name,output_stream, output_region)
    )

    # 3. Insert from Source to Destination/Print
    tickets = table_env.from_path(input_table_name)  # schema (a, b, c, rowtime)

    table_result = (tickets
    .window(Tumble.over(lit(15).seconds).on(col('event_time')).alias("w"))
    .group_by(col('w'), col('ticker')) 
    .select(col('ticker'), 
            col('w').start.alias('start_timestamp'), 
            col('w').end.alias('end_timestamp'), 
            col('w').rowtime.alias('rowtime_timestamp'), 
            col('price').avg.alias('average_price')
            )
             
    ).execute_insert(output_table_name)


    if is_local:
        table_result.wait()
    else:
        # get job status through TableResult
        print(table_result.get_job_client().get_job_status())


if __name__ == "__main__":
    main()
