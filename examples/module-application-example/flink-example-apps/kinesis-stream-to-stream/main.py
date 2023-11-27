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
is_local = True
if is_local:
    # only for local, overwrite variable to properties and pass in your jars delimited by a semicolon (;)
    print("Running Flink locally...")
    APPLICATION_PROPERTIES_FILE_PATH = "application_properties.json"  # local

    CURRENT_DIR = os.path.abspath(os.getcwd())
    CURRENT_DIR = "/Users/viniciusdeoliveiramartucci/Documents/GitHub/martucci-glue-streaming/auxiliar-scripts/apache-flink/tutorial-aws-flink/kinesis-stream-to-stream"

    table_env.get_config().set(
        "pipeline.jars",
        f"file:///{CURRENT_DIR}/lib/flink-sql-connector-kinesis-4.1.0-1.17.jar"
    )
    APPLICATION_PROPERTIES_FILE_PATH = f"{CURRENT_DIR}/application_properties.json"  # local

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


def create_print_table(table_name, stream_name, region, stream_initpos):
    return """ CREATE TABLE IF NOT EXISTS {0} (
                ticker VARCHAR(6),
                price DOUBLE,
                event_time TIMESTAMP(3),
                WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND

              )
              WITH (
                'connector' = 'print'
              ) """.format(
        table_name, stream_name, region, stream_initpos
    )

def create_output_table(table_name, stream_name, region):
    return """ CREATE TABLE IF NOT EXISTS {0} (
                ticker VARCHAR(6),
                price DOUBLE,
                event_time TIMESTAMP(3)

              )
              PARTITIONED BY (ticker)
              WITH (
                'connector' = 'kinesis',
                'stream' = '{1}',
                'aws.region' = '{2}',
                'sink.partitioner-field-delimiter' = ';',
                'sink.batch.max-size' = '100',
                'format' = 'json',
                'json.timestamp-format.standard' = 'ISO-8601'
              ) """.format(
        table_name, stream_name, region
    )

def create_fake_source_table(table_name):
    return """ CREATE TABLE IF NOT EXISTS {0} (
                ticker VARCHAR(6),
                price DOUBLE,
                event_time TIMESTAMP(3),
                WATERMARK FOR event_time AS event_time - INTERVAL '5' SECOND

              )
              PARTITIONED BY (ticker)
              WITH (
                'connector' = 'datagen',
                'number-of-rows' = '10'
              ) """.format(table_name)

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
    table_result = table_env.execute_sql("INSERT INTO {0} SELECT * FROM {1}"
                                            .format(output_table_name, input_table_name))

    if is_local:
        table_result.wait()
    else:
        # get job status through TableResult
        print(table_result.get_job_client().get_job_status())


if __name__ == "__main__":
    main()
