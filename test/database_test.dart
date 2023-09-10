import 'package:flutter_test/flutter_test.dart';
import 'package:ostello/constants/constants.dart';
import 'package:ostello/database/db_helper.dart';
import 'package:ostello/models/centers.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Set the default database factory to the FFI (Foreign Function Interface) version of the SQLite database.
  databaseFactory = databaseFactoryFfi;

// Create an instance of the DBHelper for database operations.
  final dbHelper = DBHelper.instance;

// Define a list of sample center data for testing purposes.
  final sampleCenter = [
    // A center model with a name "UniqueCenter", tagged with "JEE", offering a 10% discount, located 1 KM away with a 4.5 rating.
    CenterModel(
      centerImage: CenterImage(
          url: Constants.iconAskOstello,
          type: "asset"), // Image from assets using the AskOstello icon.
      centerName: "UniqueCenter",
      centerTags: [CenterTag(tagText: "JEE")],
      centerDiscount: 10.0,
      centerDistance: 1000, // Represented in meters, hence 1 KM.
      centerRating: 4.5,
    ),
    // Another center with the name "UniqueCenter", located 1.5 KM away, with a 4.0 rating and 5% discount.
    CenterModel(
      centerImage: CenterImage(
          url: Constants.iconAskOstello,
          type: "asset"), // Image from assets using the AskOstello icon.
      centerName: "UniqueCenter",
      centerDistance: 1500, // Represented in meters, hence 1.5 KM.
      centerRating: 4.0,
      centerDiscount: 5.0,
    ),
    // A center named "AnotherCenter", tagged with "JEE", located 0.5 KM away with a 5.0 rating and offering a 20% discount.
    CenterModel(
      centerImage: CenterImage(
          url: Constants.iconAskOstello,
          type: "asset"), // Image from assets using the AskOstello icon.
      centerName: "AnotherCenter",
      centerTags: [CenterTag(tagText: "JEE")],
      centerDistance: 500, // Represented in meters, hence 0.5 KM.
      centerRating: 5.0,
      centerDiscount: 20.0,
    ),
    // A center named "DistantCenter", located 2.5 KM away with a 4.0 rating and no discount offered.
    CenterModel(
      centerImage: CenterImage(
          url: Constants.iconAskOstello,
          type: "asset"), // Image from assets using the AskOstello icon.
      centerName: "DistantCenter",
      centerDistance: 2500, // Represented in meters, hence 2.5 KM.
      centerRating: 4.0,
      centerDiscount: 0.0, // No discount is being offered for this center.
    ),
  ];

  group('Database Initialization Tests', () {
    // Test to check if the 'centers' table exists in the database.
    test('Centers Table Exists', () async {
      // Get the database instance from the dbHelper.
      final db = await dbHelper.database;

      // Execute the raw SQL query to check for the presence of 'centers' table.
      final result = await db.rawQuery(
          'SELECT name FROM sqlite_master WHERE type="table" AND name="centers"');

      // Ensure the query result contains the name 'centers'.
      expect(result.first['name'], 'centers');
    });

    // Test to check if the 'center_tags' table exists in the database.
    test('Center Tags Table Exists', () async {
      final db = await dbHelper.database;
      final result = await db.rawQuery(
          'SELECT name FROM sqlite_master WHERE type="table" AND name="center_tags"');
      expect(result.first['name'], 'center_tags');
    });

    // Test to validate the columns present in the 'centers' table.
    test('Centers Table Columns', () async {
      final db = await dbHelper.database;

      // Fetch the column details of 'centers' table.
      final result = await db.rawQuery('PRAGMA table_info(centers)');

      // Extract the names of all columns from the result.
      final columnNames = result.map((column) => column['name']).toList();

      // Check if the expected columns are present in the 'centers' table.
      expect(columnNames, contains('id'));
      expect(columnNames, contains('image_type'));
      expect(columnNames, contains('image_url'));
      expect(columnNames, contains('location'));
      expect(columnNames, contains('name'));
      expect(columnNames, contains('rating'));
      expect(columnNames, contains('distance'));
      expect(columnNames, contains('discount'));
      expect(columnNames, contains('tags'));
      expect(columnNames, contains('bottom_texts'));
    });

    // Test to validate the columns present in the 'center_tags' table.
    test('Center Tags Table Columns', () async {
      final db = await dbHelper.database;

      // Fetch the column details of 'center_tags' table.
      final result = await db.rawQuery('PRAGMA table_info(center_tags)');

      // Extract the names of all columns from the result.
      final columnNames = result.map((column) => column['name']).toList();

      // Check if the expected columns are present in the 'center_tags' table.
      expect(columnNames, contains('id'));
      expect(columnNames, contains('center_id'));
      expect(columnNames, contains('tag_text'));
    });

    // Test to validate the foreign key constraint of 'center_tags' table with respect to 'centers' table.
    test('Center Tags Table Foreign Key Constraint', () async {
      final db = await dbHelper.database;

      // Fetch the SQL used to create 'center_tags' table.
      final result = await db.rawQuery(
          'SELECT sql FROM sqlite_master WHERE type="table" AND name="center_tags"');
      final createSQL = result.first['sql'];

      // Check if the foreign key constraint referencing 'centers' table is present in the creation SQL.
      expect(createSQL,
          contains('FOREIGN KEY (center_id) REFERENCES centers(id)'));
    });
  });

  group('Database AUTOINCREMENT Tests', () {
    // Test to ensure that the 'id' column in 'centers' table auto-increments correctly.
    test('Centers Table AUTOINCREMENT Constraint', () async {
      final dbHelper1 = DBHelper.instance;

      // Insert a center into the database.
      await dbHelper1.insertCenterModels([sampleCenter[0]]);

      // Retrieve the ID of the last inserted center.
      final initialCenters = await dbHelper1.fetchFilteredCenters();
      final initialLastId = initialCenters.last.id ?? 0;

      // Insert another center into the database.
      await dbHelper1.insertCenterModels([sampleCenter[1]], deleteDB: false);
      final newCenters = await dbHelper1.fetchFilteredCenters();

      // Ensure the new center's ID is incremented by 1 compared to the previous center's ID.
      expect(newCenters.last.id, initialLastId + 1);
      await dbHelper1.deleteDatabase();
    });

    // Test to ensure that the 'id' column in 'center_tags' table auto-increments correctly.
    test('Center Tags Table AUTOINCREMENT Constraint', () async {
      final dbHelper1 = DBHelper.instance;
      final db = await dbHelper1.database;

      // Insert a tag into 'center_tags' table.
      final initialTagId = await db
          .insert('center_tags', {'center_id': 1, 'tag_text': 'SampleTag1'});

      // Insert another tag into 'center_tags' table.
      await db
          .insert('center_tags', {'center_id': 1, 'tag_text': 'SampleTag2'});

      // Retrieve the ID of the last inserted tag.
      final tagsResult =
          await db.query('center_tags', orderBy: 'id DESC', limit: 1);
      final newTagId = tagsResult.first['id'];

      // Ensure the new tag's ID is incremented by 1 compared to the previous tag's ID.
      expect(newTagId, initialTagId + 1);
      await dbHelper.deleteDatabase();
    });
  });

  // Test to check if centers can be successfully inserted and fetched.
  test('Insert and Fetch Centers', () async {
    // Inserting sample center data into the database.
    await dbHelper.insertCenterModels(sampleCenter);

    // Fetching the inserted centers from the database.
    final centers = await dbHelper.fetchFilteredCenters();

    // Ensuring the total number of fetched centers matches the number of inserted centers.
    expect(centers.length, 4);
  });

  // Group for testing fetching data with various filters.
  group('Fetch with Filters', () {
    // Setting up the database by inserting sample centers before each test.
    setUp(() async {
      await dbHelper.insertCenterModels(sampleCenter);
    });

    // Sub-group focused on testing search term filters.
    group("Search Terms", () {
      // Test to fetch centers based on a specific search term.
      test('Fetch Centers with Specific SearchTerm', () async {
        final centersByName =
            await dbHelper.fetchFilteredCenters(searchTerm: "UniqueCenter");

        // Check if the fetched centers are not empty.
        expect(centersByName, isNotEmpty);

        // Ensure two centers have the name "UniqueCenter".
        expect(centersByName.length, 2);

        // Ensure each fetched center's name contains the search term.
        for (final center in centersByName) {
          expect(center.centerName!.contains("UniqueCenter"), isTrue);
        }
      });

      // Test to fetch all centers when the search term is empty.
      test('Fetch All Centers when SearchTerm is Empty', () async {
        final allCenters = await dbHelper.fetchFilteredCenters(searchTerm: "");

        // Ensure fetched centers are not empty.
        expect(allCenters, isNotEmpty);

        // Ensure all centers are fetched.
        expect(allCenters.length, 4);
      });
    });

    // Sub-group focused on testing sorting filters.
    group('Sorting Filters', () {
      // Test to fetch centers sorted by distance.
      test('Fetch Centers Sorted by Distance', () async {
        final centers =
            await dbHelper.fetchFilteredCenters(sortFilter: "distance");

        // Ensure fetched centers are not empty.
        expect(centers, isNotEmpty);

        // Check if the nearest and farthest centers are fetched correctly.
        expect(centers.first.centerDistance, 500);
        expect(centers.last.centerDistance, 2500);
      });

      // Test to fetch centers sorted by discount.
      test('Fetch Centers Sorted by Discount', () async {
        final centers =
            await dbHelper.fetchFilteredCenters(sortFilter: "discount");

        // Ensure fetched centers are not empty.
        expect(centers, isNotEmpty);

        // Check if the centers with highest and lowest discounts are fetched correctly.
        expect(centers.first.centerDiscount, 20);
        expect(centers.last.centerDiscount, 0);
      });

      // Test to fetch centers sorted by rating.
      test('Fetch Centers Sorted by Rating', () async {
        final centers =
            await dbHelper.fetchFilteredCenters(sortFilter: "rating");

        // Ensure fetched centers are not empty.
        expect(centers, isNotEmpty);

        // Check if the centers with highest and lowest ratings are fetched correctly.
        expect(centers.first.centerRating, 5.0);
        expect(centers.last.centerRating, 4.0);
      });
    });

    // Test to fetch centers with the "JEE" tag.
    test("Filter: JEE Tag", () async {
      final jeeCenters = await dbHelper.fetchFilteredCenters(filterJEE: true);

      // Ensure only the centers with the "JEE" tag are fetched.
      expect(jeeCenters.length, 2);
      for (final center in jeeCenters) {
        expect(center.centerTags!.any((tag) => tag.tagText == "JEE"), isTrue);
      }
    });

    // Test to fetch centers with a discount.
    test("Filter: Discount", () async {
      final discountCenters =
          await dbHelper.fetchFilteredCenters(filterOffers: true);

      // If there are any centers with discounts, ensure each of them has a discount greater than zero.
      if (discountCenters.isNotEmpty) {
        for (final center in discountCenters) {
          expect(center.centerDiscount, greaterThan(0.0));
        }
      }
    });

    // Test to fetch centers located within 2 kilometers.
    test('Fetch Centers Within 2KM', () async {
      final nearCenters =
          await dbHelper.fetchFilteredCenters(filterWithin2KM: true);

      // If there are any centers within 2 kilometers, ensure each of them is indeed within that distance.
      if (nearCenters.isNotEmpty) {
        for (final center in nearCenters) {
          expect(center.centerDistance, lessThan(2000));
        }
      }
    });

    // Test to fetch centers based on combined filters: search term and the "JEE" tag.
    test('Combined Filters: searchTerm + JEE Tag', () async {
      final centersByNameAndJee = await dbHelper.fetchFilteredCenters(
          searchTerm: "UniqueCenter", filterJEE: true);

      // If there are any centers matching the combined filters, ensure each of them satisfies both conditions.
      if (centersByNameAndJee.isNotEmpty) {
        for (final center in centersByNameAndJee) {
          expect(center.centerName!.contains("UniqueCenter"), isTrue);
          expect(center.centerTags!.any((tag) => tag.tagText == "JEE"), isTrue);
        }
      }
    });

    // Test to fetch centers based on combined filters: search term and distance.
    test('Combined Filters: searchTerm + Distance', () async {
      final centersByNameAndDistance = await dbHelper.fetchFilteredCenters(
          searchTerm: "UniqueCenter", filterWithin2KM: true);

      // If there are any centers matching the combined filters, ensure each of them satisfies both conditions.
      if (centersByNameAndDistance.isNotEmpty) {
        for (final center in centersByNameAndDistance) {
          expect(center.centerName!.contains("UniqueCenter"), isTrue);
          expect(center.centerDistance, lessThan(2000));
        }
      }
    });

    // Test to fetch centers based on combined filters: search term and offers.
    test('Combined Filters: searchTerm + Offers', () async {
      final centersByNameAndOffers = await dbHelper.fetchFilteredCenters(
          searchTerm: "UniqueCenter", filterOffers: true);

      // If there are any centers matching the combined filters, ensure each of them satisfies both conditions.
      if (centersByNameAndOffers.isNotEmpty) {
        for (final center in centersByNameAndOffers) {
          expect(center.centerName!.contains("UniqueCenter"), isTrue);
          expect(center.centerDiscount, greaterThan(0));
        }
      }
    });
  });

  // Test for deleting the entire database.
  test('Delete Database', () async {
    // Request to delete the database.
    await dbHelper.deleteDatabase();

    // Ensure that after deletion, the current database instance is null.
    expect(dbHelper.currDatabase, isNull);
  });
}
