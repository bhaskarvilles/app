/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'config_environment.dart';
import 'config_sentry.dart';

class ConfigLog {
  ConfigLog() {
    Logger.root.level = ConfigEnvironment.isDevelop || ConfigEnvironment.isLocal
        ? Level.ALL
        : Level.INFO;
    Logger.root.onRecord.listen(onRecord);
  }

  void onRecord(LogRecord record) {
    if (ConfigEnvironment.isPublic)
      ConfigSentry.message(record.message, level: _toSentryLevel(record.level));
    else
      print(
          '${_formatTime(record.time)}: ${record.level.name} [${record.loggerName}] ${record.message}');
  }

  String _formatTime(DateTime timestamp) {
    return timestamp.day.toString().padLeft(2, '0') +
        '/' +
        timestamp.month.toString().padLeft(2, '0') +
        '/' +
        timestamp.year.toString().replaceRange(0, 2, '') +
        " " +
        timestamp.hour.toString().padLeft(2, '0') +
        ":" +
        timestamp.minute.toString().padLeft(2, '0') +
        ":" +
        timestamp.second.toString().padLeft(2, '0') +
        "." +
        timestamp.millisecond.toString().padRight(3, '0');
  }

  SentryLevel _toSentryLevel(Level level) {
    if (level == Level.FINEST || level == Level.FINER || level == Level.FINE)
      return ConfigSentry.levelDebug;
    else if (level == Level.WARNING)
      return ConfigSentry.levelWarn;
    else if (level == Level.SEVERE)
      return ConfigSentry.levelError;
    else if (level == Level.SHOUT)
      return ConfigSentry.levelFatal;
    else
      return ConfigSentry.levelInfo;
  }
}
