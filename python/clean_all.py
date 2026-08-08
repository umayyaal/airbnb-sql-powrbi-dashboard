import csv
import os

RAW_DIR = r"D:\airbnb-project\raw"
CLEAN_DIR = r"D:\airbnb-project\clean"

cities = ["barcelona", "london", "paris", "nyc"]
file_types = {
    "listings": 90,
    "calendar": 5
}

for city in cities:
    for ftype, expected_cols in file_types.items():
        input_file = os.path.join(RAW_DIR, f"{city}_{ftype}.csv")
        output_file = os.path.join(CLEAN_DIR, f"{city}_{ftype}_clean.csv")

        if not os.path.exists(input_file):
            print(f"SKIP (not found): {input_file}")
            continue

        good_rows = 0
        bad_rows = 0

        with open(input_file, "r", encoding="utf-8", newline="") as infile, \
             open(output_file, "w", encoding="utf-8", newline="") as outfile:

            reader = csv.reader(infile)
            writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL,
                                 escapechar="\\", doublequote=False)

            header = next(reader)
            writer.writerow(header)

            for row in reader:
                if len(row) == expected_cols:
                    writer.writerow(row)
                    good_rows += 1
                else:
                    bad_rows += 1

        print(f"{city}_{ftype}: {good_rows} good rows, {bad_rows} bad rows skipped -> {output_file}")

print("\nDone. All cleaned files are in D:\\airbnb-project\\clean")