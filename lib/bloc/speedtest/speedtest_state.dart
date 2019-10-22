import 'package:equatable/equatable.dart';

abstract class SpeedtestState extends Equatable {
  const SpeedtestState();
}

class InitialSpeedtestState extends SpeedtestState {

  final Map<String, double> speedtestResults = const { 
    'kilobits': 0,
    'megabits': 0,
    'kilobytes': 0,
    'megabytes': 0
  };

  @override
  List<Object> get props => [speedtestResults];
}

class SpeedtestComplete extends SpeedtestState {

  final Map<String, double> speedtestResults;

  SpeedtestComplete(this.speedtestResults);

  @override
  List<Object> get props => [speedtestResults];
}

class SpeedtestInProgress extends SpeedtestState {
  @override
  List<Object> get props => [];
}

class SpeedtestError extends SpeedtestState {

  final String errorCode;
  final String errorMessage;
  final String errorDetails;

  SpeedtestError(this.errorCode, this.errorMessage, this.errorDetails);

  @override
  List<Object> get props => [errorCode, errorMessage, errorDetails];
} 
