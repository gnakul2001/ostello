import 'dart:convert';
import 'dart:io';

import 'package:ostello/models/centers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define the DBHelper class which provides utility functions
// to manage SQLite database operations for 'centers'.
class DBHelper {
  // Static variable to hold the instance of the SQLite database.
  static Database? _database;

// Define the current version of the database.
// This can be used for migrations if the database schema changes in the future.
  static const int version = 1;

// Private constructor for the singleton pattern.
// Ensures that only one instance of DBHelper is created.
  DBHelper._privateConstructor();

// Static instance of DBHelper to provide a single point of access to the database helper.
  static final DBHelper instance = DBHelper._privateConstructor();

// Getter method for the database instance.
// If the database is not initialized, it initiates the database, otherwise returns the existing instance.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

// Initialization method for the database.
// If the database doesn't exist, it creates one.
// If it exists, it simply opens it.
  Future<Database> _initDatabase() async {
    // Define the path where the database file will be stored.
    String path = join(await getDatabasesPath(), 'centers_database.db');

    // Open the database. If it doesn't exist, the onCreate method will be called.
    return openDatabase(path, version: version, onCreate: _createDb);
  }

  // Method to delete the database file.
  // 1. Get the path to the database file using the 'getDatabasesPath()' method and 'join' function.
  // 2. Check if the database file exists using the 'File' class.
  // 3. If the database file exists, delete it using the 'databaseFactory.deleteDatabase()' method.
  // 4. Reset the '_database' variable to null.
  Future<void> deleteDatabase() async {
    // Construct the path to the database file.
    String path = join(await getDatabasesPath(), 'centers_database.db');

    // Check if the file exists.
    if (await File(path).exists()) {
      await databaseFactory.deleteDatabase(path);
    }

    // Reset the database instance variable.
    _database = null;
  }

  // Method to create the necessary tables in the database.
  // It creates two tables: 'centers' and 'center_tags'.
  // The 'centers' table stores information about coaching centers.
  // The 'center_tags' table stores tags for each center with a foreign key reference to the 'centers' table.
  Future<void> _createDb(Database db, int version) async {
    // Execute the SQL command to create the 'centers' table.
    await db.execute('''
      -- Main table for coaching centers
      CREATE TABLE centers(
          id INTEGER PRIMARY KEY,       -- Primary Key for the table.
          image_type TEXT,              -- Type of image (asset, network, etc.).
          image_url TEXT,               -- URL or path to the center's image.
          location TEXT,                -- Location of the center.
          name TEXT,                    -- Name of the center.
          rating FLOAT,                 -- Rating of the center.
          distance INTEGER,             -- Distance to the center.
          discount INTEGER,             -- Discount offered by the center.
          tags TEXT,                    -- Tags associated with the center (JSON encoded).
          bottom_texts TEXT             -- Additional texts for the center (JSON encoded).
      );
    ''');

    // Execute the SQL command to create the 'center_tags' table.
    await db.execute('''
      -- Table to store tags for each center
      CREATE TABLE center_tags(
          id INTEGER PRIMARY KEY,       -- Primary Key for the table.
          center_id INTEGER,            -- Foreign Key referencing the 'centers' table.
          tag_text TEXT,                -- Text of the tag.
          FOREIGN KEY (center_id) REFERENCES centers(id)  -- Establishing the foreign key relationship.
      );
    ''');
  }

  // Method to insert a list of 'CenterModel' objects into the database.
  // The method first deletes the current database to ensure a fresh start.
  // Then, it proceeds to insert the center data and associated tags.
  Future<void> insertCenterModels(List<CenterModel> centerModels) async {
    // Delete the existing database.
    await deleteDatabase();

    // Get an instance of the database.
    final db = await database;

    // Create a batch operation to insert all center data in one go.
    var centerBatch = db.batch();

    // Loop through each center model and prepare its data for insertion.
    for (var centerModel in centerModels) {
      var centerData = {
        'image_type':
            centerModel.centerImage?.type, // Image type (asset, network, etc.).
        'image_url':
            centerModel.centerImage?.url, // URL or path to the center's image.
        'location': centerModel.centerLocation, // Location of the center.
        'name': centerModel.centerName, // Name of the center.
        'rating': centerModel.centerRating, // Rating of the center.
        'distance': centerModel.centerDistance, // Distance to the center.
        'discount':
            centerModel.centerDiscount, // Discount offered by the center.
        'tags': jsonEncode((centerModel.centerTags ?? [])
            .map((e) => e.tagText)
            .toList()), // Tags associated with the center.
        'bottom_texts': jsonEncode(
            centerModel.bottomTexts), // Additional texts for the center.
      };

      // Add the center data to the batch for insertion.
      centerBatch.insert('centers', centerData);
    }

    // Execute the batch insert for centers and capture the IDs of the inserted rows.
    List<Object?> centerIds = await centerBatch.commit();

    // Create another batch operation to insert tags associated with each center.
    var tagBatch = db.batch();

    // Loop through each center model again to insert its tags using the captured IDs.
    for (int i = 0; i < centerModels.length; i++) {
      for (var tag in centerModels[i].centerTags!) {
        var tagData = {
          'center_id': centerIds[i], // Reference to the center's ID.
          'tag_text': tag.tagText, // Text of the tag.
        };

        // Add the tag data to the batch for insertion.
        tagBatch.insert('center_tags', tagData);
      }
    }

    // Execute the batch insert for tags.
    await tagBatch.commit(noResult: true);
  }

  // Function to fetch centers based on various filters.
  Future<List<CenterModel>> fetchFilteredCenters({
    String searchTerm = "", // Search term for center names.
    String sortFilter = "", // Filter to sort the results.
    bool filterJEE = false, // Flag to filter centers offering JEE coaching.
    bool filterOffers = false, // Flag to filter centers with discounts.
    bool filterWithin2KM = false, // Flag to filter centers within 2KM distance.
  }) async {
    // Get a reference to the database.
    final db = await database;

    // Base WHERE command for filtering by center name.
    String whereCommand =
        searchTerm.isNotEmpty ? "WHERE name LIKE '%$searchTerm%'" : "";

    // Append to WHERE command if filtering by offers.
    if (filterOffers) {
      whereCommand +=
          "${whereCommand.isNotEmpty ? " and " : " WHERE "}centers.discount > 0";
    }

    // Append to WHERE command if filtering by distance.
    if (filterWithin2KM) {
      whereCommand +=
          "${whereCommand.isNotEmpty ? " and " : " WHERE "}centers.distance < 2000";
    }

    // Append to WHERE command if filtering by JEE tag.
    if (filterJEE) {
      whereCommand +=
          "${whereCommand.isNotEmpty ? " and " : " WHERE "}centers.id IN (select center_id from center_tags where tag_text = 'JEE')";
    }

    // Base ORDER BY command based on the sort filter.
    String orderByCommand = "";
    switch (sortFilter) {
      case "distance":
        orderByCommand = "ORDER BY distance ASC";
        break;
      case "discount":
        orderByCommand = "ORDER BY discount DESC";
        break;
      case "rating":
        orderByCommand = "ORDER BY rating DESC";
        break;
    }

    // Construct the final SQL query.
    String query = """
      SELECT centers.id, centers.image_type, centers.image_url, centers.location, centers.name, 
             centers.rating, centers.distance, centers.discount, centers.bottom_texts, centers.tags
      FROM centers 
      $whereCommand
      $orderByCommand;
    """;

    // Execute the SQL query and fetch the results.
    final List<Map<String, dynamic>> result = await db.rawQuery(query);

    // List to store the processed center models.
    List<CenterModel> centerList = [];

    // Loop through each row in the result set.
    for (var row in result) {
      // Extract the required columns from the current row.
      final imageType = row['image_type'];
      final imageUrl = row['image_url'];
      final location = row['location'];
      final name = row['name'];
      final rating = row['rating'].toDouble();
      final distance = row['distance'];
      final discount = row['discount'].toDouble();
      final bottomTexts = jsonDecode(row['bottom_texts']).cast<String>();
      final tagText = [
        ...jsonDecode(row['tags'])
            .cast<String>()
            .map((e) => CenterTag(tagText: e))
      ];

      // Construct and add the CenterModel to the list.
      centerList.add(
        CenterModel(
          centerImage: CenterImage(type: imageType, url: imageUrl),
          centerLocation: location,
          centerName: name,
          centerRating: rating,
          centerDistance: distance,
          centerDiscount: discount,
          centerTags: [
            ...tagText,
            ...[
              // Add a discount tag if applicable.
              if (discount > 0)
                CenterTag(
                  tagText: "$discount% Off",
                  isHighlighted: true,
                )
            ],
          ],
          bottomTexts: bottomTexts,
        ),
      );
    }

    // Return the list of CenterModel objects.
    return centerList;
  }
}
