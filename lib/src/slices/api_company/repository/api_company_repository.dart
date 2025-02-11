/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:sqflite_sqlcipher/sqlite_api.dart';

import '../model/api_company_model.dart';

class ApiCompanyRepository {
  static const String _table = 'company';
  final Database _database;

  ApiCompanyRepository(this._database);

  Future<ApiCompanyModel> insert(ApiCompanyModel company) async {
    DateTime now = DateTime.now();
    company.modified = now;
    company.created = now;
    int id = await _database.insert(_table, company.toJson());
    company.companyId = id;
    return company;
  }

  Future<ApiCompanyModel> update(ApiCompanyModel company) async {
    company.modified = DateTime.now();
    await _database.update(
      _table,
      company.toJson(),
      where: 'company_id = ?',
      whereArgs: [company.companyId],
    );
    return company;
  }

  Future<ApiCompanyModel?> getById(int id) async {
    final List<Map<String, Object?>> rows =
        await _database.query(_table, where: "company_id = ?", whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ApiCompanyModel.fromJson(rows[0]);
  }

  Future<ApiCompanyModel?> getByDomain(String domain) async {
    final List<Map<String, Object?>> rows =
        await _database.query(_table, where: "domain = ?", whereArgs: [domain]);
    if (rows.isEmpty) return null;
    return ApiCompanyModel.fromJson(rows[0]);
  }
}
