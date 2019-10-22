import 'package:equatable/equatable.dart';

abstract class NetworksScanEvent extends Equatable {
  const NetworksScanEvent();
}

class StartScan extends NetworksScanEvent {
  @override
  List<Object> get props => [];
}
