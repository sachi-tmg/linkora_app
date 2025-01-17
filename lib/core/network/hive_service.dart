import 'package:hive_flutter/hive_flutter.dart';
import 'package:linkora_app/app/constants/hive_table_constant.dart';
import 'package:linkora_app/features/auth/data/model/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  static Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}linkora_app.db';

    Hive.init(path);

    // Register Adapters
    // Hive.registerAdapter(CourseHiveModelAdapter());
    // Hive.registerAdapter(BatchHiveModelAdapter());
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  // // Batch Queries
  // Future<void> addBatch(BatchHiveModel batch) async {
  //   var box = await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchBox);
  //   await box.put(batch.batchId, batch);
  // }

  // Future<void> deleteBatch(String id) async {
  //   var box = await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchBox);
  //   await box.delete(id);
  // }

  // Future<List<BatchHiveModel>> getAllBatches() async {
  //   // Sort by BatchName
  //   var box = await Hive.openBox<BatchHiveModel>(HiveTableConstant.batchBox);
  //   return box.values.toList()
  //     ..sort((a, b) => a.batchName.compareTo(b.batchName));
  // }

  // // Course Queries
  // Future<void> addCourse(CourseHiveModel course) async {
  //   var box = await Hive.openBox<CourseHiveModel>(HiveTableConstant.courseBox);
  //   await box.put(course.courseId, course);
  // }

  // Future<void> deleteCourse(String id) async {
  //   var box = await Hive.openBox<CourseHiveModel>(HiveTableConstant.courseBox);
  //   await box.delete(id);
  // }

  // Future<List<CourseHiveModel>> getAllCourses() async {
  //   var box = await Hive.openBox<CourseHiveModel>(HiveTableConstant.courseBox);
  //   return box.values.toList();
  // }

  // Auth Queries
  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<void> deleteAuth(String id) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.delete(id);
  }

  Future<List<AuthHiveModel>> getAllAuth() async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Login using username and password
  Future<AuthHiveModel?> login(String email, String password) async {
    // var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.studentBox);
    // var auth = box.values.firstWhere(
    //     (element) =>
    //         element.username == username && element.password == password,
    //     orElse: () => AuthHiveModel.initial());
    // return auth;

    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
        (element) => element.email == email && element.password == password);
    box.close();
    return user;
  }

  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  // Clear User Box
  Future<void> clearUserBox() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
