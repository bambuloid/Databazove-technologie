import pyarrow.parquet as pq
import pandas as pd
tabulka = pq.ParquetFile("D:/PROJEKT/program/databazove/2. rocnik/Databazove-technologie/parquet/green_tripdata_2024-01.parquet")
table = "D:/PROJEKT/program/databazove/2. rocnik/Databazove-technologie/parquet/green_tripdata_2024-01.parquet"
metadata = tabulka.metadata


#print("\n", tabulka.schema_arrow)
vendorID_index = tabulka.schema_arrow.names.index("passenger_count")
vendorID = metadata.row_group(0).column(vendorID_index)
vendorID_stats = vendorID.statistics

"""print("Column:", vendorID.path_in_schema)
print("Physical type:", vendorID.physical_type)
print("Compression:", vendorID.compression)
print("Number of values:", vendorID.num_values)
print("Compressed size:", vendorID.total_compressed_size)
print("Uncompressed size:", vendorID.total_uncompressed_size)

if vendorID_stats is not None:
    print("Min:", vendorID_stats.min)
    print("Max:", vendorID_stats.max)
    print("Null:", vendorID_stats.null_count)"""

#lpep_pickup_datetime, VendorID, passenger_count, trip_distance


pocetCestujucich = pd.read_parquet(path=table, columns=["passenger_count"])
print(round(pocetCestujucich.mean(), 2))

