import 'package:equatable/equatable.dart';

abstract class SpeedtestEvent extends Equatable {
  const SpeedtestEvent();
}

class StartSpeedtest extends SpeedtestEvent { 
  @override
  List<Object> get props => [];
}
